import 'package:flutter_test/flutter_test.dart';
import 'package:sproutlab/domain/adaptive/daily_journey_planner.dart';
import 'package:sproutlab/domain/learning/item_progress.dart';
import 'package:sproutlab/domain/learning/learning_candidate.dart';
import 'package:sproutlab/domain/learning/learning_index.dart';
import 'package:sproutlab/domain/learning/session_planner.dart';
import 'package:sproutlab/domain/models/age_band.dart';
import 'package:sproutlab/domain/models/readiness.dart';
import 'package:sproutlab/domain/regional/learning_preferences.dart';
import 'package:sproutlab/domain/settings/local_settings.dart';

void main() {
  final settings = LocalSettings.defaults.copyWith(
    learningRegion: LearningRegion.india,
  );
  final index = LearningIndex();

  List<LearningCandidate> candidates({
    Set<String> introduced = const {},
  }) {
    return index.visible(
      settings: settings,
      band: AgeBand.c,
      includeDrafts: true,
      introducedItemIds: introduced,
    );
  }

  test('the same inputs plan the same mixed session', () {
    const planner = LearningSessionPlanner();
    final first = planner.plan(
      band: AgeBand.c,
      readiness: Readiness.steady,
      candidates: candidates(),
      progress: const [],
    );
    final second = planner.plan(
      band: AgeBand.c,
      readiness: Readiness.steady,
      candidates: candidates(),
      progress: const [],
    );
    expect(first.map((slot) => slot.activity.id), [
      for (final slot in second) slot.activity.id,
    ]);
    expect(first.where((slot) => slot.role == JourneyRole.current).length, 2);
    expect(first.length, lessThanOrEqualTo(5));
  });

  test('recall is withheld until the item has been introduced', () {
    const planner = LearningSessionPlanner();
    final fresh = planner.plan(
      band: AgeBand.c,
      readiness: Readiness.steady,
      candidates: candidates(),
      progress: const [],
    );
    expect(
      fresh.any((slot) => slot.activity.id.contains('review')),
      isFalse,
    );
    expect(
      fresh.any((slot) => slot.activity.id.contains('recall')),
      isFalse,
    );

    final afterTeach = planner.plan(
      band: AgeBand.c,
      readiness: Readiness.steady,
      candidates: candidates(introduced: {'letter-hi-a', 'in-rajasthan'}),
      progress: [
        LearningItemSnapshot(
          itemId: 'letter-hi-a',
          mode: PracticeMode.listen,
          contentVersion: 1,
          attempts: 1,
          correct: 1,
          unaidedCorrect: 1,
          hintsUsed: 0,
          assisted: 0,
          recalledCount: 0,
          status: ItemPracticeStatus.introduced,
          lastSeenAt: 10,
        ),
        LearningItemSnapshot(
          itemId: 'in-rajasthan',
          mode: PracticeMode.recognize,
          contentVersion: 1,
          attempts: 1,
          correct: 1,
          unaidedCorrect: 1,
          hintsUsed: 0,
          assisted: 0,
          recalledCount: 0,
          status: ItemPracticeStatus.introduced,
          lastSeenAt: 11,
        ),
      ],
    );
    expect(
      afterTeach.any(
        (slot) =>
            slot.activity.id == 'lesson:hindi:review:a' ||
            slot.activity.id.contains('capital:rajasthan') ||
            slot.activity.id.contains('review'),
      ),
      isTrue,
    );
  });

  test('gentle readiness reduces new material', () {
    const planner = LearningSessionPlanner();
    final slots = planner.plan(
      band: AgeBand.c,
      readiness: Readiness.gentle,
      candidates: candidates(
        introduced: {'letter-hi-a', 'letter-hi-aa', 'in-rajasthan'},
      ),
      progress: [
        LearningItemSnapshot(
          itemId: 'letter-hi-a',
          mode: PracticeMode.listen,
          contentVersion: 1,
          attempts: 3,
          correct: 3,
          unaidedCorrect: 0,
          hintsUsed: 3,
          assisted: 3,
          recalledCount: 0,
          status: ItemPracticeStatus.practising,
          lastSeenAt: 30,
        ),
        LearningItemSnapshot(
          itemId: 'letter-hi-aa',
          mode: PracticeMode.listen,
          contentVersion: 1,
          attempts: 2,
          correct: 2,
          unaidedCorrect: 0,
          hintsUsed: 2,
          assisted: 2,
          recalledCount: 0,
          status: ItemPracticeStatus.practising,
          lastSeenAt: 20,
        ),
      ],
    );
    expect(
      slots.where((slot) => slot.role == JourneyRole.current).length,
      lessThanOrEqualTo(1),
    );
    expect(slots.where((slot) => slot.role == JourneyRole.review).length, 2);
  });

  test('the default daily mix stays stable when no regional extras are passed', () {
    const planner = DailyJourneyPlanner();
    final first = planner.plan(
      dateKey: '2026-10-03',
      band: AgeBand.a,
      records: const [],
      difficultyBySkill: const {},
    );
    final second = planner.plan(
      dateKey: '2026-10-03',
      band: AgeBand.a,
      records: const [],
      difficultyBySkill: const {},
    );
    expect(first.map((slot) => slot.activity.id), [
      for (final slot in second) slot.activity.id,
    ]);
    expect(
      first.every(
        (slot) =>
            !slot.activity.id.startsWith('lesson:') &&
            !slot.activity.id.startsWith('geo:') &&
            !slot.activity.id.startsWith('heritage:'),
      ),
      isTrue,
    );
  });
}
