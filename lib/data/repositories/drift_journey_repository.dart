import 'package:drift/drift.dart';

import '../../../domain/adaptive/daily_journey_planner.dart';
import '../../../domain/adaptive/local_date.dart';
import '../../../domain/games/play/activity_catalog.dart';
import '../../../domain/learning/item_progress.dart';
import '../../../domain/learning/learning_candidate.dart';
import '../../../domain/learning/learning_index.dart';
import '../../../domain/lessons/lesson_models.dart';
import '../../../domain/models/child_profile.dart';
import '../../../domain/models/age_band.dart';
import '../../../domain/progress/activity_record.dart';
import '../../../domain/regional/regional_availability.dart';
import '../../../domain/settings/local_settings.dart';
import '../local/database/app_database.dart' hide ChildProfile;

class JourneySlotView {
  const JourneySlotView({
    required this.position,
    required this.activityId,
    required this.title,
    required this.role,
    required this.done,
    required this.stars,
    this.skipped = false,
  });

  final int position;
  final String activityId;
  final String title;
  final JourneyRole role;
  final bool done;
  final int stars;
  final bool skipped;
}

class DailyJourneyView {
  const DailyJourneyView({
    required this.id,
    required this.dateKey,
    required this.slots,
  });

  final int id;
  final String dateKey;
  final List<JourneySlotView> slots;

  int get finishedCount => slots.where((slot) => slot.done).length;

  int get skippedCount =>
      slots.where((slot) => slot.skipped && !slot.done).length;
  bool get isComplete =>
      slots.isNotEmpty && finishedCount + skippedCount == slots.length;

  JourneySlotView? get current {
    for (final slot in slots) {
      if (!slot.done && !slot.skipped) {
        return slot;
      }
    }
    return null;
  }

  JourneySlotView? nextAfter(String activityId) {
    final index = slots.indexWhere((slot) => slot.activityId == activityId);
    if (index >= 0) {
      for (var cursor = index + 1; cursor < slots.length; cursor++) {
        if (!slots[cursor].done && !slots[cursor].skipped) {
          return slots[cursor];
        }
      }
    }
    for (final slot in slots) {
      if (!slot.done && !slot.skipped && slot.activityId != activityId) {
        return slot;
      }
    }
    return null;
  }
}

class DriftJourneyRepository {
  DriftJourneyRepository(this._database);

  final AppDatabase _database;
  final DailyJourneyPlanner _planner = const DailyJourneyPlanner();
  final ActivityCatalog _catalog = const ActivityCatalog();
  final Map<int, Future<DailyJourneyView>> _advances = {};

  Future<Map<String, int>> skillDifficulties(int profileId) async {
    final rows = await (_database.select(
      _database.skillProgress,
    )..where((table) => table.profileId.equals(profileId))).get();
    return {for (final row in rows) row.skillId: row.currentDifficulty};
  }

  Future<DailyJourneyView> ensure({
    required ChildProfile profile,
    required List<ActivityRecord> records,
    required DateTime now,
    bool premiumActive = false,
    LocalSettings? settings,
    List<LearningItemSnapshot> itemProgress = const [],
    int? afterCompletedJourneyId,
  }) {
    Future<DailyJourneyView> run() => _ensure(
      profile: profile,
      records: records,
      now: now,
      premiumActive: premiumActive,
      settings: settings,
      itemProgress: itemProgress,
      afterCompletedJourneyId: afterCompletedJourneyId,
    );
    if (afterCompletedJourneyId == null) return run();
    final pending = _advances[profile.id];
    if (pending != null) return pending;
    final result = run().whenComplete(() {
      _advances.remove(profile.id);
    });
    _advances[profile.id] = result;
    return result;
  }

  Future<DailyJourneyView> _ensure({
    required ChildProfile profile,
    required List<ActivityRecord> records,
    required DateTime now,
    bool premiumActive = false,
    LocalSettings? settings,
    List<LearningItemSnapshot> itemProgress = const [],
    int? afterCompletedJourneyId,
  }) async {
    final latest =
        await (_database.select(_database.dailyJourneys)
              ..where((table) => table.profileId.equals(profile.id))
              ..orderBy([(table) => OrderingTerm.desc(table.id)])
              ..limit(1))
            .getSingleOrNull();
    final existing = latest == null
        ? null
        : await _load(profile.id, latest.localDateKey, records);
    final parentLedChanged =
        existing != null &&
        existing.slots.any(
          (slot) =>
              (_catalog.byId(slot.activityId)?.band == AgeBand.toddler) !=
              (profile.ageBand == AgeBand.toddler),
        );
    if (existing != null &&
        !parentLedChanged &&
        (afterCompletedJourneyId != existing.id || !existing.isComplete)) {
      return existing;
    }
    // The persisted key identifies a session, independent of calendar resets.
    final dateKey = latest == null
        ? localDateKey(now)
        : '${localDateKey(now)}#${latest.id + 1}';
    final difficulties = await skillDifficulties(profile.id);
    final regional = _regionalCandidates(
      settings: settings,
      profile: profile,
      itemProgress: itemProgress,
    );
    final plan = _planner.plan(
      dateKey: dateKey,
      band: profile.ageBand,
      records: records,
      difficultyBySkill: difficulties,
      premiumActive: premiumActive,
      readiness: profile.readiness,
      regionalCandidates: regional,
      itemProgress: itemProgress,
    );
    await _database.transaction(() async {
      final again = await _load(profile.id, dateKey, records);
      if (again != null) {
        return;
      }
      final journeyId = await _database
          .into(_database.dailyJourneys)
          .insert(
            DailyJourneysCompanion.insert(
              profileId: profile.id,
              localDateKey: dateKey,
            ),
          );
      for (var index = 0; index < plan.length; index++) {
        await _database
            .into(_database.dailyJourneyItems)
            .insert(
              DailyJourneyItemsCompanion.insert(
                journeyId: journeyId,
                position: index,
                activityId: plan[index].activity.id,
                role: Value(plan[index].role.name),
                done: const Value(false),
              ),
            );
      }
    });
    return (await _load(profile.id, dateKey, records))!;
  }

  Future<void> markDone({
    required int profileId,
    required String dateKey,
    required String activityId,
    required int stars,
  }) async {
    await _database.transaction(() async {
      final journey =
          await (_database.select(_database.dailyJourneys)..where(
                (table) =>
                    table.profileId.equals(profileId) &
                    table.localDateKey.equals(dateKey),
              ))
              .getSingleOrNull();
      if (journey == null) {
        return;
      }
      final items = await (_database.select(
        _database.dailyJourneyItems,
      )..where((table) => table.journeyId.equals(journey.id))).get();
      final match = items.where((item) => item.activityId == activityId);
      if (match.isEmpty || match.first.done) {
        return;
      }
      await (_database.update(_database.dailyJourneyItems)..where(
            (table) =>
                table.journeyId.equals(journey.id) &
                table.activityId.equals(activityId),
          ))
          .write(const DailyJourneyItemsCompanion(done: Value(true)));
      final doneCount = items.where((item) => item.done).length + 1;
      final starTotal = journey.starsEarned + stars;
      final nextIndex = items
          .where((item) => item.activityId != activityId && !item.done)
          .map((item) => item.position)
          .fold<int?>(null, (smallest, position) {
            if (smallest == null || position < smallest) {
              return position;
            }
            return smallest;
          });
      await (_database.update(
        _database.dailyJourneys,
      )..where((table) => table.id.equals(journey.id))).write(
        DailyJourneysCompanion(
          completedCount: Value(doneCount),
          starsEarned: Value(starTotal),
          currentIndex: Value(nextIndex ?? items.length),
        ),
      );
    });
  }

  /// Resolution is stored alongside the slot role, preserving the existing
  /// schema and distinguishing a skip from completed learning/rewards.
  Future<void> markSkipped({
    required int profileId,
    required String dateKey,
    required String activityId,
  }) async {
    await _database.transaction(() async {
      final journey =
          await (_database.select(_database.dailyJourneys)..where(
                (table) =>
                    table.profileId.equals(profileId) &
                    table.localDateKey.equals(dateKey),
              ))
              .getSingleOrNull();
      if (journey == null) return;
      final query = _database.select(_database.dailyJourneyItems)
        ..where(
          (table) =>
              table.journeyId.equals(journey.id) &
              table.activityId.equals(activityId),
        );
      final rows = await query.get();
      for (final item in rows) {
        if (item.done || item.role.endsWith(':skipped')) continue;
        await (_database.update(_database.dailyJourneyItems)..where(
              (table) =>
                  table.journeyId.equals(item.journeyId) &
                  table.position.equals(item.position),
            ))
            .write(
              DailyJourneyItemsCompanion(role: Value('${item.role}:skipped')),
            );
      }
    });
  }

  Future<DailyJourneyView?> _load(
    int profileId,
    String dateKey,
    List<ActivityRecord> records,
  ) async {
    final journey =
        await (_database.select(_database.dailyJourneys)..where(
              (table) =>
                  table.profileId.equals(profileId) &
                  table.localDateKey.equals(dateKey),
            ))
            .getSingleOrNull();
    if (journey == null) {
      return null;
    }
    final items =
        await (_database.select(_database.dailyJourneyItems)
              ..where((table) => table.journeyId.equals(journey.id))
              ..orderBy([(table) => OrderingTerm(expression: table.position)]))
            .get();
    return DailyJourneyView(
      id: journey.id,
      dateKey: dateKey,
      slots: [
        for (final item in items)
          if (_catalog.byId(item.activityId) != null)
            JourneySlotView(
              position: item.position,
              activityId: item.activityId,
              title: _catalog.byId(item.activityId)!.title,
              role: JourneyRole.values.firstWhere(
                (role) => role.name == item.role.split(':').first,
                orElse: () => JourneyRole.current,
              ),
              done: item.done,
              skipped: item.role.endsWith(':skipped'),
              stars: item.done ? _stars(records, item.activityId) : 0,
            ),
      ],
    );
  }

  List<LearningCandidate> _regionalCandidates({
    required LocalSettings? settings,
    required ChildProfile profile,
    required List<LearningItemSnapshot> itemProgress,
  }) {
    if (settings == null || RegionalAvailability.available(settings).isEmpty) {
      return const [];
    }
    return LearningIndex().visible(
      settings: settings,
      band: profile.ageBand,
      readiness: profile.readiness,
      includeDrafts: includeDevelopmentSamples(),
      introducedItemIds: {
        for (final row in itemProgress)
          if (row.hasBeenIntroduced) row.itemId,
      },
    );
  }

  int _stars(List<ActivityRecord> records, String activityId) {
    for (final record in records) {
      if (record.activityId == activityId) {
        return record.bestStars;
      }
    }
    return 0;
  }
}
