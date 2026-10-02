import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sproutlab/app/bootstrap_state.dart';
import 'package:sproutlab/app/session_providers.dart';
import 'package:sproutlab/core/design_system/sprout_theme.dart';
import 'package:sproutlab/core/errors/app_failure.dart';
import 'package:sproutlab/data/local/database/app_database.dart';
import 'package:sproutlab/data/repositories/drift_profile_repository.dart';
import 'package:sproutlab/data/repositories/drift_progress_repository.dart';
import 'package:sproutlab/data/repositories/drift_settings_repository.dart';
import 'package:sproutlab/domain/models/age_band.dart';
import 'package:sproutlab/domain/models/game_category.dart';
import 'package:sproutlab/domain/models/readiness.dart';
import 'package:sproutlab/domain/regional/learning_preferences.dart';
import 'package:sproutlab/domain/regional/regional_availability.dart';
import 'package:sproutlab/domain/repositories/profile_repository.dart';
import 'package:sproutlab/domain/settings/local_settings.dart';
import 'package:sproutlab/features/explore/explore_screen.dart';
import 'package:sproutlab/features/regional/regional_module_screen.dart';

const _done = LocalSettings(
  soundEffectsEnabled: true,
  musicEnabled: false,
  narrationEnabled: true,
  onboardingComplete: true,
  onboardingStep: 6,
  draftAgeBand: null,
  draftAvatarId: null,
  draftNickname: null,
);

void main() {
  group('availability rule', () {
    test('no region chosen shows no regional module', () {
      expect(RegionalAvailability.available(_done), isEmpty);
    });

    test('another country hides both modules even when switched on', () {
      final settings = _done.copyWith(learningRegion: LearningRegion.other);
      expect(RegionalAvailability.available(settings), isEmpty);
      for (final module in RegionalModule.values) {
        expect(RegionalAvailability.isAvailable(settings, module), isFalse);
      }
    });

    test('India shows both modules by default', () {
      final settings = _done.copyWith(learningRegion: LearningRegion.india);
      expect(RegionalAvailability.available(settings), RegionalModule.values);
    });

    test('grown-up switches hide each module separately', () {
      final india = _done.copyWith(learningRegion: LearningRegion.india);
      expect(
        RegionalAvailability.available(india.copyWith(hindiEnabled: false)),
        [RegionalModule.discoverIndia],
      );
      expect(
        RegionalAvailability.available(
          india.copyWith(discoverIndiaEnabled: false),
        ),
        [RegionalModule.hindi],
      );
    });

    test('teaching language does not change availability', () {
      for (final teaching in TeachingLanguage.values) {
        final other = _done.copyWith(
          learningRegion: LearningRegion.other,
          teachingLanguage: teaching,
        );
        expect(RegionalAvailability.available(other), isEmpty);
      }
    });

    test('unknown stored values fall back safely', () {
      expect(LearningRegion.fromStorage('XX'), isNull);
      expect(LearningRegion.fromStorage(null), isNull);
      expect(TeachingLanguage.fromStorage('fr'), TeachingLanguage.english);
      expect(Readiness.fromStorage('fast'), Readiness.steady);
      expect(
        InterfaceLanguage.fromStorage('hi'),
        InterfaceLanguage.english,
        reason: 'Hindi interface is not translated yet',
      );
    });
  });

  group('saved on this device', () {
    late AppDatabase database;

    setUp(() => database = AppDatabase(NativeDatabase.memory()));
    tearDown(() => database.close());

    test('region, languages and switches survive a reload', () async {
      await DriftSettingsRepository(database).save(
        _done.copyWith(
          learningRegion: LearningRegion.india,
          teachingLanguage: TeachingLanguage.bilingual,
          hindiEnabled: false,
          musicEnabled: true,
          narrationEnabled: false,
        ),
      );
      final loaded = await DriftSettingsRepository(database).load();
      expect(loaded.learningRegion, LearningRegion.india);
      expect(loaded.teachingLanguage, TeachingLanguage.bilingual);
      expect(loaded.interfaceLanguage, InterfaceLanguage.english);
      expect(loaded.hindiEnabled, isFalse);
      expect(loaded.discoverIndiaEnabled, isTrue);
      expect(loaded.musicEnabled, isTrue);
      expect(loaded.narrationEnabled, isFalse);
      expect(loaded.onboardingComplete, isTrue);
    });

    test(
      'changing region and back keeps progress, badges and rewards',
      () async {
        final profile = await DriftProfileRepository(database)
            .createProfile(avatarId: 'fox', ageBand: AgeBand.c);
        final progress = DriftProgressRepository(database);
        await progress.saveCompletion(
          profileId: profile.id,
          activityId: 'maths:v1:C:0',
          category: GameCategory.maths,
          hintsUsed: 0,
          firstAttemptCorrect: true,
          stars: 3,
          premiumActive: false,
        );
        Future<(int, int, int)> counts() async => (
          (await progress.listForProfile(profile.id)).length,
          await progress.levelBadgeCount(profile.id),
          (await database.select(database.rewards).get()).length,
        );
        final before = await counts();
        expect(before.$1, 1);
        expect(before.$3, greaterThan(0));
        final settings = DriftSettingsRepository(database);
        for (final region in [
          LearningRegion.india,
          LearningRegion.other,
          LearningRegion.india,
        ]) {
          await settings.save(_done.copyWith(learningRegion: region));
          expect(await counts(), before);
        }
        final record = (await progress.listForProfile(profile.id)).single;
        expect(record.bestStars, 3);
      },
    );

    test('each child keeps their own band, readiness and progress', () async {
      final profiles = DriftProfileRepository(database);
      final first = await profiles.createProfile(
        avatarId: 'fox',
        ageBand: AgeBand.a,
        nickname: 'Asha',
      );
      await DriftProgressRepository(database).saveCompletion(
        profileId: first.id,
        activityId: 'maths:v1:A:0',
        category: GameCategory.maths,
        hintsUsed: 0,
        firstAttemptCorrect: true,
        stars: 2,
        premiumActive: false,
      );
      final second = await profiles.addProfile(
        avatarId: 'owl',
        ageBand: AgeBand.d,
        nickname: 'Ravi',
        readiness: Readiness.more,
      );
      expect((await profiles.getActiveProfile())?.id, second.id);
      expect(second.readiness, Readiness.more);
      final progress = DriftProgressRepository(database);
      expect(await progress.listForProfile(second.id), isEmpty);
      expect(await progress.listForProfile(first.id), hasLength(1));

      final back = await profiles.switchTo(first.id);
      expect(back.nickname, 'Asha');
      expect(back.ageBand, AgeBand.a);
      expect(back.readiness, Readiness.steady);
      final updated = await profiles.updateActiveProfile(
        avatarId: 'fox',
        ageBand: AgeBand.b,
        nickname: 'Asha',
        readiness: Readiness.gentle,
      );
      expect(updated.ageBand, AgeBand.b);
      expect(updated.readiness, Readiness.gentle);
      expect(await progress.listForProfile(first.id), hasLength(1));
      final all = await profiles.listProfiles();
      expect(all.map((profile) => profile.nickname), ['Asha', 'Ravi']);
      expect(all.where((profile) => profile.active), hasLength(1));
    });

    test(
      'profile count has an upper bound and switching needs a real id',
      () async {
        final profiles = DriftProfileRepository(database);
        for (var index = 0; index < ProfileRepository.maxProfiles; index++) {
          await profiles.addProfile(avatarId: 'fox', ageBand: AgeBand.a);
        }
        expect(
          profiles.addProfile(avatarId: 'fox', ageBand: AgeBand.a),
          throwsA(isA<ProfileLimitFailure>()),
        );
        expect(
          profiles.switchTo(999),
          throwsA(isA<InvalidProfileInputFailure>()),
        );
        expect(
          (await profiles.listProfiles()).where((profile) => profile.active),
          hasLength(1),
        );
      },
    );
  });

  group('child navigation', () {
    Future<AppDatabase> seeded(LearningRegion? region) async {
      final database = AppDatabase(NativeDatabase.memory());
      await DriftProfileRepository(database)
          .createProfile(avatarId: 'fox', ageBand: AgeBand.c);
      await DriftSettingsRepository(database)
          .save(_done.copyWith(learningRegion: region));
      return database;
    }

    Future<ProviderContainer> pump(
      WidgetTester tester,
      AppDatabase database,
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
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            theme: SproutTheme.child(),
            home: const Scaffold(body: ExploreScreen()),
          ),
        ),
      );
      await tester.pumpAndSettle();
      return container;
    }

    for (final region in [null, LearningRegion.other]) {
      testWidgets(
        'Explore has no regional cards for ${region?.label ?? 'no region'}',
        (tester) async {
          final database = await seeded(region);
          addTearDown(database.close);
          final container = await pump(tester, database);
          expect(find.text('Hindi', skipOffstage: false), findsNothing);
          expect(
            find.text('Discover India', skipOffstage: false),
            findsNothing,
          );
          expect(find.text('English', skipOffstage: false), findsOneWidget);
          expect(container.read(regionalModulesProvider), isEmpty);
        },
      );
    }

    testWidgets('India shows two labelled cards and the module opens', (
      tester,
    ) async {
      final database = await seeded(LearningRegion.india);
      addTearDown(database.close);
      final semantics = tester.ensureSemantics();
      await pump(tester, database);
      await tester.ensureVisible(find.text('Discover India'));
      await tester.pumpAndSettle();
      expect(find.text('Hindi'), findsOneWidget);
      expect(find.text('Discover India'), findsOneWidget);
      expect(find.text('English'), findsOneWidget);
      expect(
        find.bySemanticsLabel(RegExp(r'^Hindi\. Letters and words')),
        findsOneWidget,
      );
      await tester.tap(find.text('Discover India'));
      await tester.pumpAndSettle();
      expect(find.byType(RegionalModuleScreen), findsOneWidget);
      expect(find.text('Development samples'), findsWidgets);
      expect(find.text('Places'), findsOneWidget);
      expect(tester.takeException(), isNull);
      semantics.dispose();
    });

    testWidgets(
      'an open module closes when the region changes, and history stays',
      (tester) async {
        final database = await seeded(LearningRegion.india);
        addTearDown(database.close);
        final container = await pump(tester, database);
        await tester.ensureVisible(find.text('Hindi'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Hindi'));
        await tester.pumpAndSettle();
        expect(find.byType(RegionalModuleScreen), findsOneWidget);

        final settings = container.read(sessionProvider).value!.settings;
        await container
            .read(sessionProvider.notifier)
            .saveSettings(
              settings.copyWith(learningRegion: LearningRegion.other),
            );
        await tester.pumpAndSettle();
        expect(find.byType(RegionalModuleScreen), findsNothing);
        expect(find.text('Hindi'), findsNothing);

        await container
            .read(sessionProvider.notifier)
            .saveSettings(
              settings.copyWith(learningRegion: LearningRegion.india),
            );
        await tester.pumpAndSettle();
        expect(find.text('Hindi', skipOffstage: false), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets('a hidden module cannot be opened from any entry point', (
      tester,
    ) async {
      final database = await seeded(LearningRegion.other);
      addTearDown(database.close);
      await pump(tester, database);
      final element = tester.element(find.byType(ExploreScreen));
      final ref = ProviderScope.containerOf(element);
      expect(ref.read(regionalModulesProvider), isEmpty);
      var opened = true;
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: ref,
          child: MaterialApp(
            theme: SproutTheme.child(),
            home: Consumer(
              builder: (context, widgetRef, _) => TextButton(
                onPressed: () => opened = openRegionalModule(
                  context,
                  widgetRef,
                  RegionalModule.hindi,
                ),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      expect(opened, isFalse);
      expect(find.byType(RegionalModuleScreen), findsNothing);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: ref,
          child: MaterialApp(
            theme: SproutTheme.child(),
            home: const RegionalModuleScreen(
              module: RegionalModule.discoverIndia,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('States and places'), findsNothing);
    });
  });
}
