import 'dart:convert';
import 'dart:io';

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
import 'package:sproutlab/domain/geography/geography_catalog.dart';
import 'package:sproutlab/domain/geography/map_geometry.dart';
import 'package:sproutlab/domain/models/age_band.dart';
import 'package:sproutlab/domain/models/game_category.dart';
import 'package:sproutlab/domain/regional/learning_preferences.dart';
import 'package:sproutlab/domain/regional/regional_availability.dart';
import 'package:sproutlab/domain/settings/local_settings.dart';
import 'package:sproutlab/features/geography/geography_activity_screen.dart';
import 'package:sproutlab/features/regional/regional_module_screen.dart';

void main() {
  final atlas = atlasFromJson(
    jsonDecode(
      File('assets/content/geography/slice_geometry.json').readAsStringSync(),
    ) as Map<String, dynamic>,
  );

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

  Future<void> pumpActivity(
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
    final activity = GeographyCatalog().byId(activityId)!;
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          theme: SproutTheme.child(),
          home: GeographyActivityScreen(activity: activity, atlas: atlas),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await container.read(sessionProvider.future);
  }

  testWidgets('learn Rajasthan persists one Discover India badge', (
    tester,
  ) async {
    final database = await seeded();
    addTearDown(database.close);
    await pumpActivity(tester, database, 'geo:india:learn:rajasthan');
    expect(find.text('Rajasthan is a state in western India.'), findsOneWidget);
    expect(find.text('State'), findsWidgets);
    await tester.tap(find.byKey(const Key('geo-next')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    final progress = DriftProgressRepository(database);
    final rows = await progress.listForProfile(1);
    expect(rows.single.activityId, 'geo:india:learn:rajasthan');
    expect(rows.single.engineType, GameCategory.discoverIndia.storageKey);
    expect(rows.single.countedAsFree, isFalse);
    expect(await progress.levelBadgeCount(1), 1);
    await progress.saveCompletion(
      profileId: 1,
      activityId: 'geo:india:learn:rajasthan',
      category: GameCategory.discoverIndia,
      hintsUsed: 0,
      firstAttemptCorrect: true,
      stars: 3,
      premiumActive: false,
    );
    expect(await progress.levelBadgeCount(1), 1);
  });

  testWidgets('Goa offers a list alternative and Kerala accepts a map answer', (
    tester,
  ) async {
    final database = await seeded();
    addTearDown(database.close);
    await pumpActivity(tester, database, 'geo:india:learn:goa');
    expect(
      find.text('A list is easier for small places.', skipOffstage: false),
      findsOneWidget,
    );
    expect(find.text('Goa', skipOffstage: false), findsWidgets);
    await pumpActivity(tester, database, 'geo:india:locate:kerala');
    expect(find.text('Where is Kerala?'), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Discover India lists the slice when the region is India', (
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
    expect(find.text('Meet Rajasthan', skipOffstage: false), findsOneWidget);
    expect(find.text('My India', skipOffstage: false), findsWidgets);
    expect(find.text('Development samples'), findsWidgets);
  });

  test('match and review stay closed until a place has been introduced', () {
    final catalog = GeographyCatalog();
    const settings = LocalSettings(
      soundEffectsEnabled: true,
      musicEnabled: false,
      narrationEnabled: true,
      onboardingComplete: true,
      onboardingStep: 6,
      draftAgeBand: null,
      draftAvatarId: null,
      draftNickname: null,
      learningRegion: LearningRegion.india,
    );
    final before = catalog.visible(
      settings: settings,
      band: AgeBand.d,
      includeDrafts: true,
    );
    expect(before.any((item) => item.id.contains('match')), isFalse);
    expect(before.any((item) => item.id.contains('review')), isFalse);
    final after = catalog.visible(
      settings: settings,
      band: AgeBand.d,
      includeDrafts: true,
      introducedPlaceIds: const {'in-rajasthan'},
    );
    expect(after.any((item) => item.id == 'geo:india:match:rajasthan'), isTrue);
    expect(after.any((item) => item.id == 'geo:india:review'), isTrue);
    expect(after.any((item) => item.id == 'geo:india:locate:kerala'), isFalse);
  });
}
