import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sproutlab/app/bootstrap_state.dart';
import 'package:sproutlab/app/session_providers.dart';
import 'package:sproutlab/core/design_system/sprout_theme.dart';
import 'package:sproutlab/data/local/database/app_database.dart';
import 'package:sproutlab/data/repositories/drift_profile_repository.dart';
import 'package:sproutlab/data/repositories/drift_progress_repository.dart';
import 'package:sproutlab/data/repositories/drift_settings_repository.dart';
import 'package:sproutlab/domain/games/play/play_checkpoint.dart';
import 'package:sproutlab/domain/lessons/development_pack.dart';
import 'package:sproutlab/domain/lessons/lesson_catalog.dart';
import 'package:sproutlab/domain/models/age_band.dart';
import 'package:sproutlab/domain/models/game_category.dart';
import 'package:sproutlab/domain/regional/learning_preferences.dart';
import 'package:sproutlab/domain/settings/local_settings.dart';
import 'package:sproutlab/features/lessons/lesson_activity_screen.dart';
import 'package:sproutlab/features/regional/regional_module_screen.dart';
import 'package:sproutlab/domain/regional/regional_availability.dart';

void main() {
  Future<AppDatabase> seeded() async {
    final database = AppDatabase(NativeDatabase.memory());
    await DriftProfileRepository(database)
        .createProfile(avatarId: 'fox', ageBand: AgeBand.d);
    await DriftSettingsRepository(database).save(
      const LocalSettings(
        soundEffectsEnabled: true,
        musicEnabled: false,
        narrationEnabled: true,
        onboardingComplete: true,
        onboardingStep: 6,
        draftAgeBand: null,
        draftAvatarId: null,
        draftNickname: null,
        learningRegion: LearningRegion.india,
      ),
    );
    return database;
  }

  Future<ProviderContainer> pumpLesson(
    WidgetTester tester,
    AppDatabase database,
    String lessonId, {
    double textScale = 1,
  }) async {
    tester.view.physicalSize = const Size(411, 900) * 3;
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    final container = ProviderContainer(
      overrides: [
        bootstrapStateProvider.overrideWithValue(const BootstrapReady()),
        databaseProvider.overrideWith((ref) => database),
      ],
    );
    addTearDown(container.dispose);
    tester.platformDispatcher.textScaleFactorTestValue = textScale;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    final lesson = LessonCatalog().byId(lessonId)!;
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          theme: SproutTheme.child(),
          home: LessonActivityScreen(lesson: lesson),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await container.read(sessionProvider.future);
    return container;
  }

  testWidgets('word building accepts अनार and persists one badge', (
    tester,
  ) async {
    final database = await seeded();
    addTearDown(database.close);
    final container = await pumpLesson(
      tester,
      database,
      'lesson:hindi:build:anar',
    );
    expect(find.text('Development sample'), findsOneWidget);
    expect(find.text('Hear again'), findsOneWidget);
    await tester.ensureVisible(find.text('Skip', skipOffstage: false));
    await tester.pumpAndSettle();
    expect(find.text('Skip'), findsOneWidget);
    await tester.ensureVisible(find.widgetWithText(OutlinedButton, 'अ'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(OutlinedButton, 'अ'));
    await tester.tap(find.widgetWithText(OutlinedButton, 'न'));
    await tester.tap(find.widgetWithText(OutlinedButton, 'ा'));
    await tester.tap(find.widgetWithText(OutlinedButton, 'र'));
    await tester.pumpAndSettle();
    expect(find.text('अनार', skipOffstage: false), findsWidgets);
    await tester.tap(find.byKey(const Key('lesson-next')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    final progress = DriftProgressRepository(database);
    final rows = await progress.listForProfile(1);
    expect(rows.single.activityId, 'lesson:hindi:build:anar');
    expect(rows.single.engineType, GameCategory.hindi.storageKey);
    expect(rows.single.countedAsFree, isFalse);
    expect(await progress.levelBadgeCount(1), 1);
    await progress.saveCompletion(
      profileId: 1,
      activityId: 'lesson:hindi:build:anar',
      category: GameCategory.hindi,
      hintsUsed: 0,
      firstAttemptCorrect: true,
      stars: 3,
      premiumActive: false,
    );
    expect(await progress.levelBadgeCount(1), 1);
    expect(
      container.read(regionalModulesProvider),
      contains(RegionalModule.hindi),
    );
  });

  testWidgets('tracing follow-the-dots completes without a timer', (
    tester,
  ) async {
    final database = await seeded();
    addTearDown(database.close);
    await pumpLesson(tester, database, 'lesson:hindi:trace:a');
    expect(find.byKey(const Key('trace-follow')), findsOneWidget);
    for (var i = 0; i < 3; i++) {
      await tester.tap(find.byKey(const Key('trace-follow')));
      await tester.pump();
    }
    expect(find.text('Ready for next'), findsOneWidget);
    await tester.tap(find.byKey(const Key('lesson-next')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text('Finished'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('large text still shows matras and English Q copy', (
    tester,
  ) async {
    final database = await seeded();
    addTearDown(database.close);
    await pumpLesson(
      tester,
      database,
      'lesson:english:listen:q_queen',
      textScale: 2,
    );
    expect(find.text('Q', skipOffstage: false), findsWidgets);
    expect(
      find.textContaining(
        'does not start with a Hindi letter',
        skipOffstage: false,
      ),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
    await pumpLesson(tester, database, 'lesson:hindi:build:anar', textScale: 2);
    expect(find.text('अनार', skipOffstage: false), findsWidgets);
    expect(
      find.textContaining('pomegranate', skipOffstage: false),
      findsWidgets,
    );
    expect(
      find.textContaining('Anar means', skipOffstage: false),
      findsWidgets,
    );
    expect(tester.takeException(), isNull);
  });

  test('lesson checkpoints keep token ids and drop a mismatched id', () {
    final payload = lessonCheckpointPayload(
      lessonId: 'lesson:hindi:build:anar',
      strokeIndex: 2,
      assisted: true,
      accepted: false,
      wrong: 1,
      hints: 3,
      placed: const ['tok_a', 'tok_n'],
    );
    final parsed = parseLessonCheckpoint(
      payload,
      lessonId: 'lesson:hindi:build:anar',
    );
    expect(parsed, isNotNull);
    expect(parsed!.strokeIndex, 2);
    expect(parsed.assisted, isTrue);
    expect(parsed.placed, ['tok_a', 'tok_n']);
    expect(payload, isNot(contains('0.28')));
    expect(
      parseLessonCheckpoint(payload, lessonId: 'lesson:hindi:trace:a'),
      isNull,
    );
  });

  testWidgets('Hindi module lists samples when the region is India', (
    tester,
  ) async {
    final database = await seeded();
    addTearDown(database.close);
    tester.view.physicalSize = const Size(411, 900) * 3;
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    final container = ProviderContainer(
      overrides: [
        bootstrapStateProvider.overrideWithValue(const BootstrapReady()),
        databaseProvider.overrideWith((ref) => database),
      ],
    );
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          theme: SproutTheme.child(),
          home: const RegionalModuleScreen(module: RegionalModule.hindi),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await container.read(sessionProvider.future);
    await tester.pumpAndSettle();
    expect(find.text('Trace अ', skipOffstage: false), findsOneWidget);
    expect(find.text('Build अनार'), findsOneWidget);
    expect(find.text('Development samples'), findsWidgets);
  });

  test('development pack never invents reviewed audio files', () {
    for (final clip in developmentLanguagePack().clips.values) {
      expect(clip.hasReviewedFile, isFalse);
      expect(clip.assetPath, isNull);
    }
  });
}
