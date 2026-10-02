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
import 'package:sproutlab/domain/heritage/heritage_catalog.dart';
import 'package:sproutlab/domain/heritage/heritage_pack.dart';
import 'package:sproutlab/domain/models/age_band.dart';
import 'package:sproutlab/domain/models/game_category.dart';
import 'package:sproutlab/domain/regional/learning_preferences.dart';
import 'package:sproutlab/domain/regional/regional_availability.dart';
import 'package:sproutlab/domain/settings/local_settings.dart';
import 'package:sproutlab/features/heritage/heritage_activity_screen.dart';
import 'package:sproutlab/features/parent/credits_screen.dart';
import 'package:sproutlab/features/regional/regional_module_screen.dart';

void main() {
  Future<AppDatabase> seeded({AgeBand band = AgeBand.d}) async {
    final database = AppDatabase(NativeDatabase.memory());
    await DriftProfileRepository(database)
        .createProfile(avatarId: 'fox', ageBand: band);
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

  Future<ProviderContainer> pumpActivity(
    WidgetTester tester,
    AppDatabase database,
    String activityId,
  ) async {
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
    final activity = HeritageCatalog().byId(activityId)!;
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          theme: SproutTheme.child(),
          home: HeritageActivityScreen(activity: activity),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await container.read(sessionProvider.future);
    return container;
  }

  testWidgets('identify Sanchi persists one Discover India badge', (
    tester,
  ) async {
    final database = await seeded();
    addTearDown(database.close);
    await pumpActivity(tester, database, 'heritage:india:identify:sanchi');
    expect(find.text('Which picture is Sanchi?'), findsOneWidget);
    expect(find.text('Development sample'), findsOneWidget);
    await tester.tap(find.text('Sanchi'));
    await tester.pump();
    await tester.tap(find.byKey(const Key('heritage-next')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    final progress = DriftProgressRepository(database);
    final rows = await progress.listForProfile(1);
    expect(rows.single.activityId, 'heritage:india:identify:sanchi');
    expect(rows.single.engineType, GameCategory.discoverIndia.storageKey);
    expect(rows.single.countedAsFree, isFalse);
    expect(await progress.levelBadgeCount(1), 1);
    await progress.saveCompletion(
      profileId: 1,
      activityId: 'heritage:india:identify:sanchi',
      category: GameCategory.discoverIndia,
      hintsUsed: 0,
      firstAttemptCorrect: true,
      stars: 3,
      premiumActive: false,
    );
    expect(await progress.levelBadgeCount(1), 1);
  });

  testWidgets('a story labels history and a traditional story', (tester) async {
    final database = await seeded();
    addTearDown(database.close);
    await pumpActivity(tester, database, 'heritage:india:story:konark');
    expect(find.text('History'), findsWidgets);
    expect(find.text('A traditional story'), findsOneWidget);
    expect(find.textContaining('legend'), findsWidgets);
    expect(find.textContaining('https://'), findsNothing);
    await tester.tap(find.byKey(const Key('heritage-next')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    final rows = await DriftProgressRepository(database).listForProfile(1);
    expect(rows.single.activityId, 'heritage:india:story:konark');
  });

  testWidgets('Discover India lists heritage samples when the region is India', (
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
          home: const RegionalModuleScreen(
            module: RegionalModule.discoverIndia,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await container.read(sessionProvider.future);
    await tester.pumpAndSettle();
    expect(find.text('Heritage', skipOffstage: false), findsWidgets);
    expect(find.text('Find Sanchi', skipOffstage: false), findsWidgets);
    expect(find.text('A marble tomb', skipOffstage: false), findsWidgets);
    expect(find.text('Remember a place', skipOffstage: false), findsNothing);
  });

  testWidgets('parent credits show sources as text and not as child links', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(411, 900) * 3;
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        theme: SproutTheme.child(),
        home: Scaffold(
          body: CreditsBody(
            records: [
              heritageIllustrationCredits.first,
              heritageResearchCredits.first,
            ],
          ),
        ),
      ),
    );
    expect(find.text('Sources and credits'), findsOneWidget);
    expect(find.text('Sanchi drawing'), findsOneWidget);
    expect(find.text(unescoSanchi), findsOneWidget);
    expect(find.textContaining('do not open websites'), findsOneWidget);
    expect(find.textContaining('Google image'), findsOneWidget);
  });
}
