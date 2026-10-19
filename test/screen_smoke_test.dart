import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sproutlab/app/session_providers.dart';
import 'package:sproutlab/core/design_system/learning_area.dart';
import 'package:sproutlab/core/design_system/sprout_theme.dart';
import 'package:sproutlab/data/repositories/drift_journey_repository.dart';
import 'package:sproutlab/domain/adaptive/daily_journey_planner.dart';
import 'package:sproutlab/domain/games/play/activity_catalog.dart';
import 'package:sproutlab/domain/models/age_band.dart';
import 'package:sproutlab/domain/models/child_profile.dart';
import 'package:sproutlab/domain/models/game_category.dart';
import 'package:sproutlab/domain/progress/activity_record.dart';
import 'package:sproutlab/domain/rewards/reward_shelf.dart';
import 'package:sproutlab/domain/rewards/reward_snapshot.dart';
import 'package:sproutlab/domain/settings/local_settings.dart';
import 'package:sproutlab/features/explore/explore_screen.dart';
import 'package:sproutlab/features/home/home_screen.dart';
import 'package:sproutlab/features/play/play_chrome.dart';
import 'package:sproutlab/features/rewards/rewards_screen.dart';
import 'package:sproutlab/domain/models/readiness.dart';
import 'package:sproutlab/domain/regional/learning_preferences.dart';
import 'package:sproutlab/domain/regional/regional_availability.dart';
import 'package:sproutlab/features/onboarding/onboarding_screen.dart';
import 'package:sproutlab/features/parent/grown_up_settings_screen.dart';
import 'package:sproutlab/features/parent/learning_preferences_screen.dart';
import 'package:sproutlab/domain/geography/geography_catalog.dart';
import 'package:sproutlab/domain/heritage/heritage_catalog.dart';
import 'package:sproutlab/domain/lessons/lesson_catalog.dart';
import 'package:sproutlab/features/geography/geography_activity_screen.dart';
import 'package:sproutlab/features/heritage/heritage_activity_screen.dart';
import 'package:sproutlab/features/lessons/lesson_activity_screen.dart';
import 'package:sproutlab/features/parent/credits_screen.dart';
import 'package:sproutlab/features/regional/regional_module_screen.dart';

const _settings = LocalSettings(
  soundEffectsEnabled: true,
  musicEnabled: false,
  narrationEnabled: false,
  onboardingComplete: true,
  onboardingStep: 5,
  draftAgeBand: AgeBand.d,
  draftAvatarId: 'fox',
  draftNickname: null,
  learningRegion: LearningRegion.india,
  teachingLanguage: TeachingLanguage.bilingual,
);

class _OpenGate extends ParentGateSession {
  @override
  bool build() => true;
}

const _profile = ChildProfile(
  id: 1,
  nickname: 'Mia',
  avatarId: 'fox',
  ageBand: AgeBand.d,
  createdAtMillis: 0,
  active: true,
);

class _FakeSession extends SessionController {
  @override
  Future<AppSession> build() async {
    return const AppSession(settings: _settings, profile: _profile);
  }
}

const _catalog = ActivityCatalog();

List<ActivityRecord> _records(bool withProgress) {
  if (!withProgress) {
    return const [];
  }
  return [
    for (final category in [GameCategory.maths, GameCategory.knowledge])
      for (final activity in _catalog.forBand(category, AgeBand.d).take(5))
        ActivityRecord(
          activityId: activity.id,
          engineType: category.storageKey,
          attempts: 2,
          completions: 1,
          bestStars: 2,
          hintsUsed: 0,
          lastPlayedAt: 1000 + activity.variant,
          countedAsFree: true,
        ),
  ];
}

DailyJourneyView _journey(int done) {
  final picks = [
    _catalog.forBand(GameCategory.maze, AgeBand.d)[0],
    _catalog.forBand(GameCategory.maths, AgeBand.d)[0],
    _catalog.forBand(GameCategory.vocabulary, AgeBand.d)[0],
    _catalog.forBand(GameCategory.pattern, AgeBand.d)[0],
    _catalog.forBand(GameCategory.findDifference, AgeBand.d)[0],
  ];
  return DailyJourneyView(
    id: 1,
    dateKey: '2026-10-02',
    slots: [
      for (var index = 0; index < picks.length; index++)
        JourneySlotView(
          position: index,
          activityId: picks[index].id,
          title: picks[index].title,
          role: index == 0 ? JourneyRole.review : JourneyRole.current,
          done: index < done,
          stars: index < done ? 3 : 0,
        ),
    ],
  );
}

Future<void> _pump(
  WidgetTester tester,
  Widget screen, {
  required Size size,
  double textScale = 1,
  bool withProgress = true,
  int journeyDone = 1,
}) async {
  tester.view.physicalSize = size * 3;
  tester.view.devicePixelRatio = 3;
  tester.platformDispatcher.textScaleFactorTestValue = textScale;
  addTearDown(tester.view.reset);
  addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
  final records = _records(withProgress);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        sessionProvider.overrideWith(_FakeSession.new),
        progressListProvider.overrideWith((ref) async => records),
        dailyJourneyProvider.overrideWith((ref) async => _journey(journeyDone)),
        rewardShelfProvider.overrideWith(
          (ref) async => withProgress
              ? const RewardShelf(
                  snapshot: RewardSnapshot(totalStars: 20),
                  unlockedAt: {},
                )
              : RewardShelf.empty,
        ),
        startedActivityIdsProvider.overrideWith((ref) async => <String>{}),
        premiumActiveProvider.overrideWith((ref) => false),
        parentGateProvider.overrideWith(_OpenGate.new),
        profilesProvider.overrideWith(
          (ref) async => const [
            _profile,
            ChildProfile(
              id: 2,
              nickname: 'Ravindranath',
              avatarId: 'owl',
              ageBand: AgeBand.a,
              createdAtMillis: 1,
              active: false,
              readiness: Readiness.gentle,
            ),
          ],
        ),
      ],
      child: MaterialApp(
        theme: SproutTheme.child(),
        home: Scaffold(body: screen),
      ),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 50));
}

const _sizes = {
  'narrow phone': Size(320, 640),
  'phone': Size(411, 731),
  'tablet': Size(800, 1280),
};

void main() {
  final screens = <String, Widget Function()>{
    'Home': () => const HomeScreen(),
    'Explore': () => const ExploreScreen(),
    'Rewards': () => const RewardsScreen(),
    'Play again': () => const PlayAgainScreen(),
    for (final area in LearningArea.values)
      'Category ${area.title}': () => CategoryScreen(area: area),
    for (final module in RegionalModule.values)
      'Module ${module.storageKey}': () => RegionalModuleScreen(module: module),
    'Learning preferences': () => const LearningPreferencesScreen(),
    'Grown-up settings': () => const GrownUpSettingsScreen(),
    'Add a child': () => const AddChildScreen(),
    'Onboarding region step': () => OnboardingScreen(
      initial: _settings.copyWith(onboardingComplete: false, onboardingStep: 2),
    ),
    'Hindi trace': () => LessonActivityScreen(
      lesson: LessonCatalog().byId('lesson:hindi:trace:a')!,
    ),
    'Hindi build': () => LessonActivityScreen(
      lesson: LessonCatalog().byId('lesson:hindi:build:anar')!,
    ),
    'English Q': () => LessonActivityScreen(
      lesson: LessonCatalog().byId('lesson:english:listen:q_queen')!,
    ),
    'Discover India explore': () => GeographyActivityScreen(
      activity: GeographyCatalog().byId('geo:india:explore')!,
    ),
    'Discover India learn': () => GeographyActivityScreen(
      activity: GeographyCatalog().byId('geo:india:learn:goa')!,
    ),
    'Discover India heritage': () => HeritageActivityScreen(
      activity: HeritageCatalog().byId('heritage:india:identify:sanchi')!,
    ),
    'Discover India story': () => HeritageActivityScreen(
      activity: HeritageCatalog().byId('heritage:india:story:konark')!,
    ),
    'Sources and credits': () => const CreditsScreen(),
  };

  for (final screen in screens.entries) {
    for (final size in _sizes.entries) {
      testWidgets('${screen.key} renders on a ${size.key}', (tester) async {
        await _pump(tester, screen.value(), size: size.value);
        expect(tester.takeException(), isNull);
      });
    }
    testWidgets('${screen.key} renders at 2x text on a phone', (tester) async {
      await _pump(tester, screen.value(), size: _sizes['phone']!, textScale: 2);
      expect(tester.takeException(), isNull);
    });
    testWidgets('${screen.key} renders with no saved progress', (tester) async {
      await _pump(
        tester,
        screen.value(),
        size: _sizes['phone']!,
        withProgress: false,
        journeyDone: 0,
      );
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('Home shows the real journey count and Explore categories', (
    tester,
  ) async {
    await _pump(tester, const HomeScreen(), size: _sizes['phone']!);
    expect(find.text('1 of 5 activities complete'), findsOneWidget);
    expect(find.text('Continue adventure'), findsOneWidget);
    await _pump(tester, const ExploreScreen(), size: _sizes['tablet']!);
    for (final area in LearningArea.values) {
      expect(find.text(area.title), findsOneWidget);
    }
    expect(find.text('Hindi'), findsOneWidget);
    expect(find.text('Discover India'), findsOneWidget);
    expect(find.text('अ आ'), findsOneWidget);
    await tester.drag(find.byType(ListView).first, const Offset(0, -1800));
    await tester.pumpAndSettle();
    expect(find.text('Play again'), findsOneWidget);
  });

  final guidelineScreens = <String, Widget Function()>{
    'Explore with India cards': () => const ExploreScreen(),
    'Hindi module': () =>
        const RegionalModuleScreen(module: RegionalModule.hindi),
    'Learning preferences': () => const LearningPreferencesScreen(),
    'Onboarding region step': () => OnboardingScreen(
      initial: _settings.copyWith(onboardingComplete: false, onboardingStep: 2),
    ),
    'Hindi build': () => LessonActivityScreen(
      lesson: LessonCatalog().byId('lesson:hindi:build:anar')!,
    ),
  };
  for (final entry in guidelineScreens.entries) {
    testWidgets('${entry.key} meets tap target and contrast guidelines', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      await _pump(tester, entry.value(), size: _sizes['phone']!);
      await tester.pumpAndSettle();
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      await expectLater(tester, meetsGuideline(textContrastGuideline));
      semantics.dispose();
    });
  }

  testWidgets('a finished journey shows calm feedback without a button', (
    tester,
  ) async {
    await _pump(
      tester,
      const HomeScreen(),
      size: _sizes['phone']!,
      journeyDone: 5,
    );
    expect(find.text('5 of 5 activities complete'), findsOneWidget);
    expect(find.text('Continue adventure'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('completion summary renders on a narrow phone at 2x text', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await _pump(
      tester,
      FinishedBanner(
        stars: 2,
        points: 20,
        badgeLabel: 'Level 3 complete · Count the leaves',
        onDone: () {},
        onNext: () {},
        onReplay: () {},
      ),
      size: _sizes['narrow phone']!,
      textScale: 2,
    );
    expect(
      find.bySemanticsLabel(RegExp('2 of 3 stars'), skipOffstage: false),
      findsOneWidget,
    );
    await tester.drag(find.byType(ListView), const Offset(0, -3000));
    await tester.pumpAndSettle();
    expect(find.text('Next activity'), findsOneWidget);
    expect(tester.takeException(), isNull);
    semantics.dispose();
  });
}
