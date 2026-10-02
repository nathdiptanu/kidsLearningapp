import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sproutlab/app/app_identity.dart';
import 'package:sproutlab/app/bootstrap_state.dart';
import 'package:sproutlab/app/sprout_app.dart';
import 'package:sproutlab/core/design_system/sprout_theme.dart';
import 'package:sproutlab/core/design_system/widgets/feedback_overlay.dart';
import 'package:sproutlab/core/design_system/widgets/premium_lock_badge.dart';
import 'package:sproutlab/core/design_system/widgets/primary_kid_button.dart';
import 'package:sproutlab/core/errors/app_failure.dart';
import 'package:sproutlab/data/local/database/app_database.dart';
import 'package:sproutlab/data/repositories/drift_profile_repository.dart';
import 'package:sproutlab/data/repositories/drift_settings_repository.dart';
import 'package:sproutlab/domain/games/play/activity_catalog.dart';
import 'package:sproutlab/domain/models/age_band.dart';
import 'package:sproutlab/domain/models/game_category.dart';
import 'package:sproutlab/domain/regional/learning_preferences.dart';
import 'package:sproutlab/domain/settings/local_settings.dart';
import 'package:sproutlab/features/explore/explore_screen.dart';
import 'package:sproutlab/features/play/activity_screen.dart';

void main() {
  testWidgets('onboarding welcomes a grown-up and shows no price', (
    tester,
  ) async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    await tester.pumpWidget(_app(database));
    await tester.pumpAndSettle();
    expect(find.text(AppIdentity.visibleName), findsWidgets);
    expect(find.text('Saved on this device'), findsOneWidget);
    expect(find.textContaining('199'), findsNothing);
    expect(find.textContaining('₹'), findsNothing);
    expect(find.text('BrightSteps'), findsNothing);
  });

  testWidgets('onboarding persists and home appears after restart', (
    tester,
  ) async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    await tester.pumpWidget(_app(database));
    await tester.pumpAndSettle();
    await _tapContinue(tester);
    await _tapContinue(tester);
    expect(find.text('Choose which learning activities to show.'), findsOne);
    await tester.tap(find.text(LearningRegion.other.label));
    await tester.pumpAndSettle();
    await _tapContinue(tester);
    await tester.tap(find.text('Ages 4-5'));
    await tester.pumpAndSettle();
    await _tapContinue(tester);
    await _tapContinue(tester);
    await _tapContinue(tester);
    await tester.tap(find.text('Start playing'));
    await tester.pumpAndSettle();
    expect(find.text('Hello!'), findsOneWidget);
    expect(find.text('Rewards'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpWidget(_app(database));
    await tester.pumpAndSettle();
    expect(find.text('Hello!'), findsOneWidget);
    expect(find.text('Learning through short daily activities.'), findsNothing);
    final saved = await DriftSettingsRepository(database).load();
    expect(saved.learningRegion, LearningRegion.other);
    expect(saved.onboardingComplete, isTrue);
  });

  testWidgets('a maths activity can be missed, hinted and finished once', (
    tester,
  ) async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    await DriftProfileRepository(database)
        .createProfile(avatarId: 'sprout', ageBand: AgeBand.a);
    await DriftSettingsRepository(database)
        .save(LocalSettings.defaults.copyWith(onboardingComplete: true));
    final activity = const ActivityCatalog()
        .forBand(GameCategory.maths, AgeBand.a)
        .first;
    final questions = const ActivityCatalog().questionsFor(activity);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          bootstrapStateProvider.overrideWithValue(const BootstrapReady()),
          databaseProvider.overrideWith((ref) => database),
        ],
        child: MaterialApp(
          theme: SproutTheme.child(),
          home: ActivityScreen(
            activity: activity,
            idleAfter: const Duration(seconds: 30),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    for (final question in questions) {
      final wrong = question.choices.firstWhere(
        (choice) => choice.id != question.correctId,
      );
      final correct = question.choices.firstWhere(
        (choice) => choice.id == question.correctId,
      );
      await tester.ensureVisible(find.byKey(ValueKey(wrong.id)));
      await tester.tap(find.byKey(ValueKey(wrong.id)));
      await tester.pump();
      expect(find.text('Try again.'), findsOneWidget);
      await tester.ensureVisible(find.byKey(ValueKey(wrong.id)));
      await tester.tap(find.byKey(ValueKey(wrong.id)));
      await tester.pump();
      expect(find.text(question.firstHint), findsOneWidget);
      await tester.ensureVisible(find.byKey(ValueKey(correct.id)));
      await tester.tap(find.byKey(ValueKey(correct.id)));
      await tester.pumpAndSettle();
      if (find.text('Next').evaluate().isNotEmpty) {
        await tester.ensureVisible(find.text('Next'));
        await tester.tap(find.text('Next'));
        await tester.pumpAndSettle();
      }
    }
    expect(find.text('You finished!'), findsOneWidget);
    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();
  });

  testWidgets('home, explore and a game fit a small screen', (tester) async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    await DriftProfileRepository(database)
        .createProfile(avatarId: 'fox', ageBand: AgeBand.c, nickname: 'Asha');
    await DriftSettingsRepository(database)
        .save(LocalSettings.defaults.copyWith(onboardingComplete: true));
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(_app(database));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text('Hello, Asha!'), findsOneWidget);
    expect(find.text('0 of 5 activities complete'), findsOneWidget);
    expect(find.text('Start adventure'), findsOneWidget);
    await tester.tap(_navigation('Explore'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Maths'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.tap(find.byType(LevelCard).first);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Leave'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.byType(LevelCard), findsWidgets);
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.scrollUntilVisible(find.text('Logic'), 300);
    expect(find.text('Logic'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Knowledge'), 300);
    expect(find.text('Knowledge'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Tic-Tac-Toe'), 300);
    expect(find.text('Tic-Tac-Toe'), findsOneWidget);
    await tester.tap(_navigation('Rewards'));
    await tester.pumpAndSettle();
    expect(find.text('No stars yet'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('database failure stays parent readable', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          bootstrapStateProvider.overrideWithValue(
            const BootstrapFailed(DatabaseFailure()),
          ),
        ],
        child: const SproutApp(),
      ),
    );
    expect(find.textContaining('saved progress'), findsOneWidget);
    expect(find.textContaining('Exception'), findsNothing);
  });

  testWidgets('large text and reduced motion stay readable', (tester) async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    await DriftProfileRepository(database)
        .createProfile(avatarId: 'fox', ageBand: AgeBand.c, nickname: 'Asha');
    await DriftSettingsRepository(database)
        .save(LocalSettings.defaults.copyWith(onboardingComplete: true));
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 1.6;
    tester.platformDispatcher.accessibilityFeaturesTestValue =
        const FakeAccessibilityFeatures(disableAnimations: true);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
    await tester.pumpWidget(_app(database));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text('Hello, Asha!'), findsOneWidget);
    await tester.tap(find.text('Explore'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.tap(find.text('Rewards'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('child button meets the large target size', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: SproutTheme.child(),
        home: PrimaryKidButton(label: 'Continue', onPressed: () {}),
      ),
    );
    expect(
      tester.getSize(find.byType(PrimaryKidButton)).height,
      greaterThanOrEqualTo(64),
    );
  });

  testWidgets('feedback and premium badge avoid failure language and price', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: SproutTheme.child(),
        home: const Column(
          children: [
            FeedbackOverlay(kind: FeedbackKind.retry),
            PremiumLockBadge(),
          ],
        ),
      ),
    );
    expect(find.text('Try again.'), findsOneWidget);
    expect(find.text('Wrong!'), findsNothing);
    expect(find.text('Premium'), findsOneWidget);
    expect(find.textContaining('199'), findsNothing);
  });
}

Widget _app(AppDatabase database) {
  return ProviderScope(
    overrides: [
      bootstrapStateProvider.overrideWithValue(const BootstrapReady()),
      databaseProvider.overrideWith((ref) => database),
    ],
    child: const SproutApp(),
  );
}

Finder _navigation(String label) {
  return find.descendant(
    of: find.byType(NavigationBar),
    matching: find.text(label),
  );
}

Future<void> _tapContinue(WidgetTester tester) async {
  await tester.ensureVisible(find.text('Next'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Next'));
  await tester.pumpAndSettle();
}
