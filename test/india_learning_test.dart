import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/native.dart';
import 'package:sproutlab/app/bootstrap_state.dart';
import 'package:sproutlab/app/session_providers.dart';
import 'package:sproutlab/core/audio/silent_audio_controller.dart';
import 'package:sproutlab/core/audio/audio_controller.dart';
import 'package:sproutlab/core/design_system/sprout_theme.dart';
import 'package:sproutlab/data/local/database/app_database.dart';
import 'package:sproutlab/data/repositories/drift_profile_repository.dart';
import 'package:sproutlab/domain/models/age_band.dart';
import 'package:sproutlab/domain/regional/explorer_content.dart';
import 'package:sproutlab/domain/regional/india_learning_content.dart';
import 'package:sproutlab/domain/games/play/activity_catalog.dart';
import 'package:sproutlab/features/play/open_activity.dart';
import 'package:sproutlab/features/regional/india_interactive_map.dart';
import 'package:sproutlab/features/regional/india_learning_screen.dart';

void main() {
  test('every state and territory has a capital; questions replay and suit the age', () {
    expect(
      indiaCapitals.keys.toSet(),
      explorerPlaces.map((p) => p.name).toSet(),
    );
    expect(
      indiaQuestions(AgeBand.d)
          .where((q) => q.kind == IndiaQuestionKind.locate),
      hasLength(28),
    );
    expect(
      indiaQuestions(AgeBand.d)
          .where((q) => q.kind == IndiaQuestionKind.capital),
      hasLength(36),
    );
    expect(
      indiaQuestions(AgeBand.toddler).where(
        (q) =>
            q.kind == IndiaQuestionKind.capital ||
            q.kind == IndiaQuestionKind.locate,
      ),
      isEmpty,
    );
    expect(
      indiaQuestions(AgeBand.a)
          .where((q) => q.kind == IndiaQuestionKind.capital),
      isEmpty,
    );
    final bank = indiaQuestions(AgeBand.d);
    expect(bank.map((q) => q.id).toSet(), hasLength(bank.length));
    for (final q in bank) {
      if (q.options.isNotEmpty) {
        expect(q.options, contains(q.answer));
        expect(q.options.toSet(), hasLength(q.options.length));
      }
      final activity = const ActivityCatalog().byId(
        'india-learning:v1:${q.id}',
      );
      expect(activity, isNotNull);
      expect(screenFor(activity!), isA<IndiaLearningScreen>());
    }
  });
  test(
    'source geometry preserves all 28 state hit regions and uniform fit',
    () {
      final map = IndiaSourceMap.fromJson(
        jsonDecode(
          File('assets/content/geography/india_source_interaction.json')
              .readAsStringSync(),
        ),
      );
      expect(map.regions, hasLength(31));
      for (final state in explorerPlaces.where((p) => p.type == 'State')) {
        expect(map.regions.map((r) => r.name), contains(state.name));
      }
      for (final region in map.regions) {
        expect(map.hit(region.anchor), region.name);
        for (final size in [const Size(320, 600), const Size(800, 400)]) {
          final fit = IndiaMapFit(size);
          final p = fit.toSource(fit.toLocal(region.anchor));
          expect((p - region.anchor).distance, lessThan(.0001));
        }
      }
      expect(map.hit(const Offset(0, 0)), isNull);
    },
  );
  testWidgets(
    'teach before map recall, wrong answer then saved correct state; rendered map',
    (tester) async {
      for (final entry in {
        'Nunito': 'assets/fonts/Nunito-700.ttf',
        'MaterialIcons': 'fonts/MaterialIcons-Regular.otf',
      }.entries) {
        await (FontLoader(
          entry.key,
        )..addFont(rootBundle.load(entry.value))).load();
      }
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);
      await DriftProfileRepository(db)
          .createProfile(avatarId: 'fox', ageBand: AgeBand.c);
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final q = indiaQuestions(AgeBand.c)
          .firstWhere((q) => q.id == 'locate:Rajasthan');
      final audio = _SpeechRecorder();
      await tester.runAsync(() => IndiaSourceMap.load());
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            bootstrapStateProvider.overrideWithValue(const BootstrapReady()),
            databaseProvider.overrideWith((ref) => db),
            audioControllerProvider.overrideWithValue(audio),
          ],
          child: MaterialApp(
            theme: SproutTheme.child(),
            home: RepaintBoundary(child: IndiaLearningScreen(question: q)),
          ),
        ),
      );
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 100)),
      );
      await tester.pumpAndSettle();
      expect(find.text(q.teaching), findsOneWidget);
      expect(audio.texts, contains(q.teaching));
      var widget = tester.widget<IndiaInteractiveMap>(
        find.byType(IndiaInteractiveMap),
      );
      expect(widget.highlight, 'Rajasthan');
      widget.onSelect!('Rajasthan');
      await tester.pumpAndSettle();
      expect(await db.select(db.activityProgress).get(), isEmpty);
      final boundary = tester.renderObject<RenderRepaintBoundary>(
        find.byType(RepaintBoundary).first,
      );
      final image = await tester.runAsync(() => boundary.toImage());
      final bytes = await tester.runAsync(
        () => image!.toByteData(format: ui.ImageByteFormat.png),
      );
      final file = File('build/india-review/teach-rajasthan.png');
      file.parent.createSync(recursive: true);
      file.writeAsBytesSync(bytes!.buffer.asUint8List());
      image!.dispose();
      await tester.ensureVisible(find.text('Let’s try'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Let’s try'));
      await tester.pumpAndSettle();
      widget = tester.widget<IndiaInteractiveMap>(
        find.byType(IndiaInteractiveMap),
      );
      expect(widget.highlight, isNull);
      expect(audio.texts, contains(q.prompt));
      await tester.ensureVisible(find.byType(IndiaInteractiveMap));
      await tester.pumpAndSettle();
      final map = await tester.runAsync(() => IndiaSourceMap.load());
      final fit = IndiaMapFit(tester.getSize(find.byType(IndiaInteractiveMap)));
      Offset tapPoint(String name) =>
          tester.getTopLeft(find.byType(IndiaInteractiveMap)) +
          fit.toLocal(map!.regions.firstWhere((r) => r.name == name).anchor);
      await tester.tapAt(tapPoint('Gujarat'));
      await tester.pumpAndSettle();
      expect(await db.select(db.activityProgress).get(), isEmpty);
      await tester.tapAt(tapPoint('Rajasthan'));
      await tester.pumpAndSettle();
      final rows = await db.select(db.activityProgress).get();
      expect(rows, hasLength(1));
      expect(rows.single.activityId, 'india-learning:v1:locate:Rajasthan');
      expect(tester.takeException(), isNull);
      tester.view.physicalSize = const Size(320, 700);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            bootstrapStateProvider.overrideWithValue(const BootstrapReady()),
            databaseProvider.overrideWith((ref) => db),
            audioControllerProvider.overrideWithValue(audio),
          ],
          child: MaterialApp(
            theme: SproutTheme.child(),
            home: MediaQuery(
              data: const MediaQueryData(
                size: Size(320, 700),
                textScaler: TextScaler.linear(2),
              ),
              child: IndiaLearningScreen(question: q),
            ),
          ),
        ),
      );
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 100)),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    },
  );
}

class _SpeechRecorder extends SilentAudioController {
  final texts = <String>[];
  @override
  Future<NarrationPlayResult> playNarration(
    String clipId, {
    String? assetPath,
  }) async {
    final uri = Uri.parse(assetPath!);
    expectSync(uri.queryParameters['language'], 'en-IN');
    texts.add(uri.queryParameters['text']!);
    return NarrationPlayResult.played;
  }
}
