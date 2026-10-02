import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sproutlab/core/design_system/learning_area.dart';
import 'package:sproutlab/core/design_system/sprout_theme.dart';
import 'package:sproutlab/core/design_system/sprout_tokens.dart';
import 'package:sproutlab/core/design_system/widgets/activity_card.dart';
import 'package:sproutlab/core/design_system/widgets/category_card.dart';
import 'package:sproutlab/domain/games/knowledge/knowledge_bank.dart';
import 'package:sproutlab/domain/games/play/activity_catalog.dart';
import 'package:sproutlab/domain/models/age_band.dart';
import 'package:sproutlab/domain/models/game_category.dart';

Widget _host(Widget child, {double textScale = 1}) {
  return MaterialApp(
    theme: SproutTheme.child(),
    home: MediaQuery(
      data: MediaQueryData(
        size: const Size(390, 844),
        textScaler: TextScaler.linear(textScale),
      ),
      child: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: child,
        ),
      ),
    ),
  );
}

void main() {
  group('catalog names', () {
    const catalog = ActivityCatalog();

    test('ids keep the stored format', () {
      final activity = catalog.forBand(GameCategory.knowledge, AgeBand.b)[17];
      expect(activity.id, 'knowledge:v1:B:17');
    });

    test('byId returns the same activity as the catalog for every id', () {
      for (final activity in catalog.all()) {
        final found = catalog.byId(activity.id);
        expect(found?.id, activity.id);
        expect(found?.title, activity.title);
        expect(found?.seed, activity.seed);
      }
      for (final bad in [
        '',
        'maths:v1:A',
        'maths:v2:A:0',
        'maths:v1:Z:0',
        'maths:v1:A:25',
        'maths:v1:A:-1',
        'maths:v1:A:01',
        'nope:v1:A:0',
      ]) {
        expect(catalog.byId(bad), isNull, reason: bad);
      }
    });

    test('titles do not end with a level number', () {
      for (final activity in catalog.all()) {
        expect(
          RegExp(r' \d+$').hasMatch(activity.title),
          isFalse,
          reason: '${activity.id} is "${activity.title}"',
        );
      }
    });

    test('knowledge titles are the real questions and are distinct', () {
      for (final band in AgeBand.values) {
        final titles = catalog
            .forBand(GameCategory.knowledge, band)
            .map((activity) => activity.title)
            .toList();
        expect(titles.toSet().length, titles.length);
        expect(titles, [
          for (final fact in knowledgeFactsFor(band)) fact.prompt,
        ]);
      }
    });

    test('every engine belongs to one learning area', () {
      for (final category in GameCategory.values) {
        final owners = LearningArea.values
            .where((area) => area.categories.contains(category))
            .toList();
        expect(owners.length, 1, reason: category.name);
      }
    });
  });

  testWidgets('category card is one labelled button', (tester) async {
    final handle = tester.ensureSemantics();
    var taps = 0;
    await tester.pumpWidget(
      _host(
        CategoryCard(
          title: 'Maths',
          subtitle: 'Numbers and counting',
          art: SproutArt.maths,
          tint: SproutColors.mathsSurface,
          footnote: '0 of 25 finished',
          onTap: () => taps++,
        ),
      ),
    );
    final node = find.bySemanticsLabel(
      'Maths. Numbers and counting. 0 of 25 finished',
    );
    expect(node, findsOneWidget);
    expect(
      tester.getSemantics(node),
      matchesSemantics(
        label: 'Maths. Numbers and counting. 0 of 25 finished',
        isButton: true,
        hasTapAction: true,
      ),
    );
    await tester.tap(find.text('Maths'));
    expect(taps, 1);
    tester.semantics.tap(
      find.semantics.byLabel('Maths. Numbers and counting. 0 of 25 finished'),
    );
    expect(taps, 2);
    handle.dispose();
  });

  testWidgets('journey progress reads each step', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      _host(
        const JourneyProgress(
          marks: [
            StepMark.done,
            StepMark.current,
            StepMark.upcoming,
            StepMark.upcoming,
            StepMark.upcoming,
          ],
        ),
      ),
    );
    expect(
      find.bySemanticsLabel(
        'Step 1 finished, Step 2 is next, Step 3 later, Step 4 later, Step 5 later',
      ),
      findsOneWidget,
    );
    handle.dispose();
  });

  testWidgets('activity card fits a narrow phone at large text', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320 * 3, 640 * 3);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      _host(
        ActivityCard(
          step: 3,
          title: 'Which one do we see in the day sky?',
          subtitle: 'Quiz · Level 3',
          art: SproutArt.knowledge,
          tint: SproutColors.knowledgeSurface,
          onTap: () {},
          semanticsLabel: 'Which one do we see in the day sky?',
        ),
        textScale: 2,
      ),
    );
    expect(tester.takeException(), isNull);
  });
}
