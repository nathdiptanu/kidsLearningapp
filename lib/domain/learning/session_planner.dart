import '../adaptive/daily_journey_planner.dart';
import '../models/age_band.dart';
import '../models/readiness.dart';
import '../progress/activity_record.dart';
import 'item_progress.dart';
import 'learning_candidate.dart';

/// Local, explainable mix: new material, review of introduced material,
/// and an easy success. Recall is never offered before a teach activity.
class LearningSessionPlanner {
  const LearningSessionPlanner();

  List<PlannedActivity> plan({
    required AgeBand band,
    required Readiness readiness,
    required List<LearningCandidate> candidates,
    required List<LearningItemSnapshot> progress,
    List<ActivityRecord> records = const [],
  }) {
    final byItem = <String, List<LearningItemSnapshot>>{};
    for (final row in progress) {
      byItem.putIfAbsent(row.itemId, () => []).add(row);
    }
    final introduced = {
      for (final row in progress)
        if (row.correct > 0) row.itemId,
    };
    final struggling = readiness == Readiness.gentle || _struggling(progress);
    final newLimit = struggling ? 1 : 2;
    final reviewLimit = 2;
    final easyLimit = struggling ? 2 : 1;

    final offered = [
      for (final item in candidates)
        if (item.offeredFor(band, readiness)) item,
    ]..sort((a, b) => a.activity.id.compareTo(b.activity.id));

    final fresh = [
      for (final item in offered)
        if (item.introduces &&
            item.mode != PracticeMode.recall &&
            !introduced.contains(item.itemId) &&
            item.requiresItemIds.every(introduced.contains))
          item,
    ];
    final review =
        [
          for (final item in offered)
            if (introduced.contains(item.itemId) &&
                item.requiresItemIds.every(introduced.contains) &&
                (item.mode != PracticeMode.recall ||
                    introduced.contains(item.itemId)) &&
                _reviewable(item, byItem[item.itemId] ?? const []))
              item,
        ]..sort((a, b) {
          final rank = _reviewRank(b, byItem) - _reviewRank(a, byItem);
          if (rank != 0) {
            return rank;
          }
          return a.activity.id.compareTo(b.activity.id);
        });
    final easy = [
      for (final item in offered)
        if (introduced.contains(item.itemId) &&
            (item.mode == PracticeMode.listen ||
                item.mode == PracticeMode.recognize) &&
            _easy(item, byItem[item.itemId] ?? const [], records))
          item,
    ];

    final used = <String>{};
    final slots = <PlannedActivity>[];
    void take(List<LearningCandidate> pool, int limit, JourneyRole role) {
      var taken = 0;
      for (final item in pool) {
        if (taken >= limit || used.contains(item.activity.id)) {
          continue;
        }
        used.add(item.activity.id);
        slots.add(PlannedActivity(activity: item.activity, role: role));
        taken += 1;
      }
    }

    take(fresh, newLimit, JourneyRole.current);
    take(review, reviewLimit, JourneyRole.review);
    take(easy, easyLimit, JourneyRole.stretch);

    if (slots.length < 5) {
      take(easy, 5 - slots.length, JourneyRole.stretch);
    }
    if (slots.length < 5) {
      take(review, 5 - slots.length, JourneyRole.review);
    }
    return slots;
  }

  bool _struggling(List<LearningItemSnapshot> progress) {
    final recent = [...progress]
      ..sort((a, b) => b.lastSeenAt.compareTo(a.lastSeenAt));
    final window = recent.take(4).where((row) => row.attempts > 0);
    if (window.isEmpty) {
      return false;
    }
    var attempts = 0;
    var unaided = 0;
    var hints = 0;
    for (final row in window) {
      attempts += row.attempts;
      unaided += row.unaidedCorrect;
      hints += row.hintsUsed;
    }
    return unaided * 2 < attempts || hints * 2 >= attempts;
  }

  bool _reviewable(LearningCandidate item, List<LearningItemSnapshot> rows) {
    if (item.mode == PracticeMode.recall) {
      return rows.any(
            (row) => row.correct > 0 && row.mode != PracticeMode.recall,
          ) ||
          rows.any((row) => row.itemId == item.itemId && row.correct > 0);
    }
    return rows.any((row) => row.correct > 0);
  }

  int _reviewRank(
    LearningCandidate item,
    Map<String, List<LearningItemSnapshot>> byItem,
  ) {
    final rows = byItem[item.itemId] ?? const [];
    for (final row in rows) {
      if (row.mode == item.mode) {
        return switch (row.status) {
          ItemPracticeStatus.readyToReview => 2,
          ItemPracticeStatus.practising => 1,
          ItemPracticeStatus.introduced => 0,
        };
      }
    }
    return 0;
  }

  bool _easy(
    LearningCandidate item,
    List<LearningItemSnapshot> rows,
    List<ActivityRecord> records,
  ) {
    if (rows.any((row) => row.status == ItemPracticeStatus.readyToReview)) {
      return true;
    }
    for (final record in records) {
      if (record.activityId == item.activity.id &&
          record.completed &&
          record.bestStars >= 2) {
        return true;
      }
    }
    return rows.any(
      (row) => row.mode == PracticeMode.listen && row.correct > 0,
    );
  }
}
