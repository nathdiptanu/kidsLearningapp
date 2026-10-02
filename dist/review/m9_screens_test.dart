import 'dart:io';
import 'dart:ui' as ui;

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sproutlab/app/bootstrap_state.dart';
import 'package:sproutlab/app/sprout_app.dart';
import 'package:sproutlab/core/design_system/sprout_theme.dart';
import 'package:sproutlab/data/local/database/app_database.dart';
import 'package:sproutlab/data/repositories/drift_profile_repository.dart';
import 'package:sproutlab/data/repositories/drift_settings_repository.dart';
import 'package:sproutlab/domain/games/play/activity_catalog.dart';
import 'package:sproutlab/domain/models/age_band.dart';
import 'package:sproutlab/domain/models/game_category.dart';
import 'package:sproutlab/domain/settings/local_settings.dart';
import 'package:sproutlab/features/play/activity_screen.dart';
import 'package:sproutlab/features/play/difference_screen.dart';
import 'package:sproutlab/features/play/maze_screen.dart';

void main() {
  testWidgets('review screenshots of home, explore, rewards and games', (
    tester,
  ) async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    await DriftProfileRepository(database)
        .createProfile(avatarId: 'fox', ageBand: AgeBand.c, nickname: 'Asha');
    await DriftSettingsRepository(database)
        .save(LocalSettings.defaults.copyWith(onboardingComplete: true));
    final catalog = const ActivityCatalog();

    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(_shell(database));
    await tester.pumpAndSettle();
    await _save(tester, 'home_phone');
    await _tab(tester, 'Explore');
    await _save(tester, 'explore_phone');
    await _tab(tester, 'Rewards');
    await _save(tester, 'rewards_phone');

    tester.view.physicalSize = const Size(800, 1200);
    await tester.pumpAndSettle();
    await _tab(tester, 'Home');
    await _save(tester, 'home_tablet');

    tester.view.physicalSize = const Size(390, 844);
    await tester.pumpAndSettle();
    await _game(
      tester,
      database,
      ActivityScreen(
        activity: catalog.forBand(GameCategory.maths, AgeBand.c).first,
      ),
      'maths_phone',
    );
    await _game(
      tester,
      database,
      ActivityScreen(
        activity: catalog.forBand(GameCategory.pattern, AgeBand.c).first,
      ),
      'pattern_phone',
    );
    await _game(
      tester,
      database,
      ActivityScreen(
        activity: catalog.forBand(GameCategory.matching, AgeBand.a).first,
      ),
      'matching_phone',
    );
    await _game(
      tester,
      database,
      ActivityScreen(
        activity: catalog.forBand(GameCategory.vocabulary, AgeBand.a).first,
      ),
      'vocabulary_phone',
    );
    await _game(
      tester,
      database,
      MazeScreen(activity: catalog.forBand(GameCategory.maze, AgeBand.a).first),
      'maze_phone',
    );
    await _game(
      tester,
      database,
      DifferenceScreen(
        activity: catalog.forBand(GameCategory.findDifference, AgeBand.a).first,
      ),
      'difference_phone',
    );

    tester.view.physicalSize = const Size(320, 640);
    await _game(
      tester,
      database,
      MazeScreen(activity: catalog.forBand(GameCategory.maze, AgeBand.d).last),
      'maze_small',
    );
  });
}

Future<void> _tab(WidgetTester tester, String label) async {
  await tester.tap(
    find.descendant(of: find.byType(NavigationBar), matching: find.text(label)),
  );
  await tester.pumpAndSettle();
  expect(tester.takeException(), isNull);
}

Future<void> _game(
  WidgetTester tester,
  AppDatabase database,
  Widget screen,
  String name,
) async {
  await tester.pumpWidget(_page(database, screen));
  await tester.pumpAndSettle();
  expect(tester.takeException(), isNull);
  await _save(tester, name);
}

Future<void> _save(WidgetTester tester, String name) async {
  final boundary = tester.renderObject(
    find.byType(RepaintBoundary).first,
  ) as RenderRepaintBoundary;
  final image = await tester.runAsync(() => boundary.toImage());
  final bytes = await tester.runAsync(
    () => image!.toByteData(format: ui.ImageByteFormat.png),
  );
  var file = File(
    'C:/Users/MSUSERSL123/Documents/kidsApp/build/m9_review/$name.png',
  );
  file.parent.createSync(recursive: true);
  if (file.existsSync()) {
    try {
      file.deleteSync();
    } on FileSystemException {
      file = File('${file.path}.new');
    }
  }
  file.writeAsBytesSync(bytes!.buffer.asUint8List());
  expect(file.lengthSync(), greaterThan(1000));
}

Widget _shell(AppDatabase database) {
  return ProviderScope(
    overrides: [
      bootstrapStateProvider.overrideWithValue(const BootstrapReady()),
      databaseProvider.overrideWith((ref) => database),
    ],
    child: const SproutApp(),
  );
}

Widget _page(AppDatabase database, Widget screen) {
  return ProviderScope(
    overrides: [
      bootstrapStateProvider.overrideWithValue(const BootstrapReady()),
      databaseProvider.overrideWith((ref) => database),
    ],
    child: MaterialApp(theme: SproutTheme.child(), home: screen),
  );
}
