import '../games/play/activity_catalog.dart';
import '../games/play/activity_definition.dart';
import '../games/play/activity_skill.dart';
import '../learning/item_progress.dart';
import '../learning/learning_candidate.dart';
import '../learning/session_planner.dart';
import '../models/age_band.dart';
import '../models/game_category.dart';
import '../models/readiness.dart';
import '../monetization/free_entitlement_policy.dart';
import '../progress/activity_record.dart';
import 'local_date.dart';

enum JourneyRole { current, review, stretch }

class PlannedActivity {
  const PlannedActivity({required this.activity, required this.role});

  final ActivityDefinition activity;
  final JourneyRole role;
}

class DailyJourneyPlanner {
  const DailyJourneyPlanner({this.catalog = const ActivityCatalog()});

  final ActivityCatalog catalog;

  List<PlannedActivity> plan({
    required String dateKey,
    required AgeBand band,
    required List<ActivityRecord> records,
    required Map<String, int> difficultyBySkill,
    bool premiumActive = false,
    Readiness readiness = Readiness.steady,
    List<LearningCandidate> regionalCandidates = const [],
    List<LearningItemSnapshot> itemProgress = const [],
  }) {
    final seed = dateSeed(dateKey);
    if (band == AgeBand.toddler) {
      final pictures = catalog.forBand(GameCategory.matching, band);
      final exhausted =
          !premiumActive &&
          records
                  .where(
                    (record) =>
                        record.completed &&
                        record.countedAsFree &&
                        record.engineType == GameCategory.matching.storageKey,
                  )
                  .length >=
              5;
      if (exhausted) {
        final replays = [
          for (final record in records)
            if (record.completed &&
                record.engineType == GameCategory.matching.storageKey)
              ?catalog.byId(record.activityId),
        ];
        if (replays.isNotEmpty) {
          return [
            for (var i = 0; i < 3; i++)
              PlannedActivity(
                activity: replays[(seed + i) % replays.length],
                role: JourneyRole.review,
              ),
          ];
        }
      }
      return [
        for (var i = 0; i < 3; i++)
          PlannedActivity(
            activity: pictures[(seed + i) % pictures.length],
            role: JourneyRole.current,
          ),
      ];
    }
    final logic = seed.isEven ? GameCategory.pattern : GameCategory.maze;
    final otherLogic = logic == GameCategory.pattern
        ? GameCategory.maze
        : GameCategory.pattern;
    final observation = seed.isEven
        ? GameCategory.matching
        : GameCategory.findDifference;
    final used = <String>{};
    final currentSlots = <PlannedActivity>[];
    for (final category in [
      GameCategory.maths,
      GameCategory.vocabulary,
      logic,
      observation,
    ]) {
      final picked = _pick(
        category: category,
        difficulty: _difficulty(difficultyBySkill, category, band),
        records: records,
        premiumActive: premiumActive,
        used: used,
        preferReplay: false,
      )!;
      used.add(picked.id);
      currentSlots.add(
        PlannedActivity(activity: picked, role: JourneyRole.current),
      );
    }
    ActivityDefinition? regionalReview;
    if (regionalCandidates.isNotEmpty) {
      final session = const LearningSessionPlanner().plan(
        band: band,
        readiness: readiness,
        candidates: regionalCandidates,
        progress: itemProgress,
        records: records,
      );
      PlannedActivity? regionalFresh;
      for (final slot in session) {
        if (slot.role == JourneyRole.current && regionalFresh == null) {
          regionalFresh = slot;
        }
        if (slot.role == JourneyRole.review && regionalReview == null) {
          regionalReview = slot.activity;
        }
      }
      if (regionalFresh != null) {
        used.remove(currentSlots.last.activity.id);
        used.add(regionalFresh.activity.id);
        currentSlots[currentSlots.length - 1] = PlannedActivity(
          activity: regionalFresh.activity,
          role: JourneyRole.current,
        );
      }
    }
    final reviewDifficulty = _difficulty(difficultyBySkill, otherLogic, band);
    final reviewPick =
        regionalReview ??
        _confidencePick(
          category: otherLogic,
          difficulty: reviewDifficulty,
          records: records,
          premiumActive: premiumActive,
          used: used,
          band: band,
        );
    used.add(reviewPick.id);
    final review = PlannedActivity(
      activity: reviewPick,
      role: JourneyRole.review,
    );
    final withStretch = _applyStretch(
      slots: currentSlots,
      records: records,
      premiumActive: premiumActive,
      difficultyBySkill: difficultyBySkill,
      band: band,
      used: used,
    );
    return [review, ...withStretch];
  }

  int _difficulty(
    Map<String, int> stored,
    GameCategory category,
    AgeBand band,
  ) {
    final skill = skillForCategory(category);
    return (stored[skill] ?? (band.index + 1)).clamp(1, 4);
  }

  ActivityDefinition _confidencePick({
    required GameCategory category,
    required int difficulty,
    required List<ActivityRecord> records,
    required bool premiumActive,
    required Set<String> used,
    required AgeBand band,
  }) {
    final completed = _leastRecentCompleted(
      records: records,
      used: used,
      premiumActive: premiumActive,
    );
    if (completed != null) {
      return completed;
    }
    final easier = difficulty > 1 ? difficulty - 1 : difficulty;
    return _pick(
      category: category,
      difficulty: easier,
      records: records,
      premiumActive: premiumActive,
      used: used,
      preferReplay: false,
      fallbackBand: band,
    )!;
  }

  ActivityDefinition? _leastRecentCompleted({
    required List<ActivityRecord> records,
    required Set<String> used,
    required bool premiumActive,
  }) {
    final completed = records.where((record) => record.completed).toList()
      ..sort((a, b) => a.lastPlayedAt.compareTo(b.lastPlayedAt));
    for (final record in completed) {
      if (used.contains(record.activityId)) {
        continue;
      }
      final activity = catalog.byId(record.activityId);
      if (activity == null) {
        continue;
      }
      final access = _access(
        activity: activity,
        records: records,
        premiumActive: premiumActive,
      );
      if (access == LevelAccess.replay) {
        return activity;
      }
    }
    return null;
  }

  List<PlannedActivity> _applyStretch({
    required List<PlannedActivity> slots,
    required List<ActivityRecord> records,
    required bool premiumActive,
    required Map<String, int> difficultyBySkill,
    required AgeBand band,
    required Set<String> used,
  }) {
    final next = [...slots];
    for (var index = 0; index < next.length; index++) {
      final slot = next[index];
      final difficulty = _difficulty(
        difficultyBySkill,
        slot.activity.category,
        band,
      );
      if (difficulty >= 4) {
        continue;
      }
      final stretched = _pick(
        category: slot.activity.category,
        difficulty: difficulty + 1,
        records: records,
        premiumActive: premiumActive,
        used: used,
        preferReplay: false,
        allowMissing: true,
      );
      if (stretched == null || stretched.id == slot.activity.id) {
        continue;
      }
      used.remove(slot.activity.id);
      used.add(stretched.id);
      next[index] = PlannedActivity(
        activity: stretched,
        role: JourneyRole.stretch,
      );
      return next;
    }
    return next;
  }

  ActivityDefinition? _pick({
    required GameCategory category,
    required int difficulty,
    required List<ActivityRecord> records,
    required bool premiumActive,
    required Set<String> used,
    required bool preferReplay,
    AgeBand? fallbackBand,
    bool allowMissing = false,
  }) {
    final band = AgeBand.values[(difficulty - 1).clamp(0, 3)];
    final selected = _fromBand(
      band: band,
      category: category,
      records: records,
      premiumActive: premiumActive,
      used: used,
      preferReplay: preferReplay,
    );
    if (selected != null) {
      return selected;
    }
    if (fallbackBand != null && fallbackBand != band) {
      final fallback = _fromBand(
        band: fallbackBand,
        category: category,
        records: records,
        premiumActive: premiumActive,
        used: used,
        preferReplay: false,
      );
      if (fallback != null) {
        return fallback;
      }
    }
    if (allowMissing) {
      return null;
    }
    for (final candidateBand in AgeBand.values) {
      final replay = _fromBand(
        band: candidateBand,
        category: category,
        records: records,
        premiumActive: premiumActive,
        used: used,
        preferReplay: true,
      );
      if (replay != null) {
        return replay;
      }
    }
    final safe = catalog
        .forBand(category, fallbackBand ?? band)
        .where((activity) => !used.contains(activity.id))
        .where(
          (activity) =>
              _access(
                activity: activity,
                records: records,
                premiumActive: premiumActive,
              ) !=
              LevelAccess.locked,
        )
        .toList();
    if (safe.isNotEmpty) {
      return safe.first;
    }
    return _leastRecentCompleted(
          records: records,
          used: used,
          premiumActive: premiumActive,
        ) ??
        catalog.forBand(category, fallbackBand ?? band).first;
  }

  LevelAccess _access({
    required ActivityDefinition activity,
    required List<ActivityRecord> records,
    required bool premiumActive,
  }) {
    ActivityRecord? record;
    for (final item in records) {
      if (item.activityId == activity.id) {
        record = item;
      }
    }
    final freeCount = records
        .where(
          (item) =>
              item.engineType == activity.category.storageKey &&
              item.countedAsFree &&
              item.completed,
        )
        .length;
    if (activity.variant > 0) {
      final previousId =
          '${activity.category.storageKey}:v1:${activity.band.storageKey}:${activity.variant - 1}';
      var previousDone = false;
      for (final item in records) {
        if (item.activityId == previousId && item.completed) {
          previousDone = true;
          break;
        }
      }
      if (!previousDone) {
        return LevelAccess.locked;
      }
    }
    return const FreeEntitlementPolicy().decide(
      premiumActive: premiumActive,
      alreadyStarted: false,
      alreadyCompleted: record?.completed ?? false,
      uniqueFreeLevelsCompleted: freeCount,
    );
  }

  ActivityDefinition? _fromBand({
    required AgeBand band,
    required GameCategory category,
    required List<ActivityRecord> records,
    required bool premiumActive,
    required Set<String> used,
    required bool preferReplay,
  }) {
    final candidates = <ActivityDefinition>[];
    for (final activity in catalog.forBand(category, band)) {
      if (used.contains(activity.id)) {
        continue;
      }
      final decision = _access(
        activity: activity,
        records: records,
        premiumActive: premiumActive,
      );
      if (decision == LevelAccess.locked) {
        continue;
      }
      if (preferReplay && decision != LevelAccess.replay) {
        continue;
      }
      candidates.add(activity);
    }
    if (candidates.isEmpty) {
      return null;
    }
    if (preferReplay) {
      candidates.sort((a, b) {
        final aTime = _playedAt(records, a.id);
        final bTime = _playedAt(records, b.id);
        return aTime.compareTo(bTime);
      });
      return candidates.first;
    }
    final fresh = candidates.where((activity) {
      final played = _playedAt(records, activity.id);
      return played == 0;
    }).toList();
    final pool = fresh.isNotEmpty ? fresh : candidates;
    pool.sort((a, b) => a.variant.compareTo(b.variant));
    return pool.first;
  }

  int _playedAt(List<ActivityRecord> records, String activityId) {
    for (final record in records) {
      if (record.activityId == activityId) {
        return record.lastPlayedAt;
      }
    }
    return 0;
  }
}
