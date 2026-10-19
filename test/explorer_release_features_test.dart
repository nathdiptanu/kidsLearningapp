import 'dart:io';
import 'dart:ui' as ui;

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sproutlab/app/bootstrap_state.dart';
import 'package:sproutlab/core/design_system/sprout_theme.dart';
import 'package:sproutlab/data/local/database/app_database.dart';
import 'package:sproutlab/data/repositories/drift_profile_repository.dart';
import 'package:sproutlab/data/repositories/drift_journey_repository.dart';
import 'package:sproutlab/domain/models/age_band.dart';
import 'package:sproutlab/domain/games/play/activity_catalog.dart';
import 'package:sproutlab/domain/regional/explorer_content.dart';
import 'package:sproutlab/domain/regional/regional_availability.dart';
import 'package:sproutlab/features/regional/explorer_library_screen.dart';
import 'package:sproutlab/features/play/open_activity.dart';

void main() {
  setUpAll(() async {
    for (final entry in {
      'Nunito': 'assets/fonts/Nunito-700.ttf',
      'NotoSansDevanagari': 'assets/fonts/NotoSansDevanagari-700.ttf',
      'MaterialIcons': 'fonts/MaterialIcons-Regular.otf',
    }.entries) {
      await (FontLoader(
        entry.key,
      )..addFont(rootBundle.load(entry.value))).load();
    }
  });
  test(
    'all release explorer activities have stable resolvable replay routes',
    () {
      expect(explorerPlaces.where((p) => p.type == 'State'), hasLength(28));
      expect(
        explorerPlaces.where((p) => p.type == 'Union territory'),
        hasLength(8),
      );
      expect(
        explorerNeighbours.where((p) => p.type == 'Land neighbour'),
        hasLength(7),
      );
      expect(
        explorerNeighbours.where((p) => p.type == 'Nearby island country'),
        hasLength(2),
      );
      final ids = [
        for (final letter in hindiVowels) 'hi:vowel:$letter',
        for (final letter in hindiConsonants) 'hi:consonant:$letter',
        for (final word in hindiPictureWords) 'hi:word:${word.picture}',
        for (var i = 0; i < explorerPlaces.length; i++) 'india:region:$i',
        for (var i = 0; i < explorerNeighbours.length; i++)
          'india:neighbour:$i',
        for (final id in explorerMonuments.keys) 'india:monument:$id',
      ];
      expect(ids.toSet(), hasLength(107));
      for (final id in ids) {
        final item = explorerItemById(id)!;
        expect(item.choices.toSet().length, item.choices.length);
        expect(item.choices, contains(item.title));
        expect(item.choices.length, greaterThan(1));
        final activity = const ActivityCatalog().byId(id)!;
        expect(screenFor(activity), isA<ExplorerActivityScreen>());
        if (item.picture != null) {
          expect(
            File(
              'assets/teaching/${item.picture}.${item.hindi ? 'png' : 'jpg'}',
            ).existsSync(),
            true,
          );
        }
      }
      expect(explorerItemById('india:region:-1'), isNull);
      expect(explorerItemById('india:region:036'), isNull);
      expect(explorerItemById('hi:vowel:Q'), isNull);
    },
  );

  test('skips resolve the session without marking learning complete', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final profile = await DriftProfileRepository(db)
        .createProfile(avatarId: 'fox', ageBand: AgeBand.a);
    final repo = DriftJourneyRepository(db);
    final first = await repo.ensure(
      profile: profile,
      records: [],
      now: DateTime(2026, 10, 3),
    );
    for (final slot in first.slots) {
      await repo.markSkipped(
        profileId: profile.id,
        dateKey: first.dateKey,
        activityId: slot.activityId,
      );
    }
    final resolved = await repo.ensure(
      profile: profile,
      records: [],
      now: DateTime(2026, 10, 4),
    );
    expect(resolved.id, first.id);
    expect(resolved.isComplete, true);
    expect(resolved.finishedCount, 0);
    expect(resolved.skippedCount, 5);
    expect(resolved.current, isNull);
    expect(await db.select(db.activityProgress).get(), isEmpty);
    final advances = await Future.wait(
      List.generate(
        2,
        (_) => repo.ensure(
          profile: profile,
          records: [],
          now: DateTime(2026, 10, 4),
          afterCompletedJourneyId: first.id,
        ),
      ),
    );
    final next = advances.first;
    expect(advances.last.id, next.id);
    expect(next.id, isNot(first.id));
    expect(next.skippedCount, 0);
    final toddler = await DriftProfileRepository(db)
        .addProfile(avatarId: 'fox', ageBand: AgeBand.toddler);
    final short = await repo.ensure(
      profile: toddler,
      records: [],
      now: DateTime(2026, 10, 3),
    );
    expect(short.slots, hasLength(3));
  });

  testWidgets(
    'Hindi tap routes and correct answers persist and replay on a narrow phone',
    (tester) async {
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);
      await DriftProfileRepository(db)
          .createProfile(avatarId: 'fox', ageBand: AgeBand.c);
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        _page(db, const ExplorerLibraryScreen(module: RegionalModule.hindi)),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'अ'));
      await tester.pumpAndSettle();
      expect(find.text('Hear again'), findsOneWidget);
      await tester.tap(find.text('Let’s try a little game'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(OutlinedButton, 'अ'));
      await tester.pumpAndSettle();
      expect(find.text('You found it!'), findsOneWidget);
      final rows = await db.select(db.activityProgress).get();
      expect(rows.where((p) => p.activityId == 'hi:vowel:अ'), hasLength(1));
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('actual-font explorer screenshots and large text fit', (
    tester,
  ) async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    await DriftProfileRepository(db)
        .createProfile(avatarId: 'fox', ageBand: AgeBand.c);
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final screens = <String, Widget>{
      'hindi-library': const ExplorerLibraryScreen(
        module: RegionalModule.hindi,
      ),
      'india-library': const ExplorerLibraryScreen(
        module: RegionalModule.discoverIndia,
      ),
      'india-map': const OfficialIndiaMapScreen(),
      'pomegranate': const ExplorerActivityScreen(
        title: 'अनार',
        detail: 'Pomegranate',
        activityId: 'hi:word:pomegranate',
        spokenText: 'अनार',
        hindi: true,
        picture: 'pomegranate',
        choices: ['अनार', 'आम'],
      ),
      'taj-mahal': const ExplorerActivityScreen(
        title: 'Taj Mahal',
        detail: 'Agra, Uttar Pradesh',
        activityId: 'india:monument:taj-mahal',
        spokenText: 'Taj Mahal',
        picture: 'taj-mahal',
        choices: ['Taj Mahal', 'Sanchi Stupa'],
      ),
    };
    for (final entry in screens.entries) {
      await tester.pumpWidget(_page(db, RepaintBoundary(child: entry.value)));
      await tester.pumpAndSettle();
      for (final img in tester.widgetList<Image>(find.byType(Image))) {
        await tester.runAsync(
          () => precacheImage(
            img.image,
            tester.element(find.byType(Image).first),
          ),
        );
      }
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      final boundary = tester.renderObject<RenderRepaintBoundary>(
        find.byType(RepaintBoundary).first,
      );
      final image = await tester.runAsync(() => boundary.toImage());
      final bytes = await tester.runAsync(
        () => image!.toByteData(format: ui.ImageByteFormat.png),
      );
      final file = File('build/explorer-review/${entry.key}.png');
      file.parent.createSync(recursive: true);
      file.writeAsBytesSync(bytes!.buffer.asUint8List());
      image!.dispose();
      tester.view.physicalSize = const Size(320, 700);
      await tester.pumpWidget(
        _page(
          db,
          MediaQuery(
            data: const MediaQueryData(
              size: Size(320, 700),
              textScaler: TextScaler.linear(2),
            ),
            child: entry.value,
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      tester.view.physicalSize = const Size(390, 844);
    }
  });
}

Widget _page(AppDatabase db, Widget screen) => ProviderScope(
  overrides: [
    bootstrapStateProvider.overrideWithValue(const BootstrapReady()),
    databaseProvider.overrideWith((ref) => db),
  ],
  child: MaterialApp(theme: SproutTheme.child(), home: screen),
);
