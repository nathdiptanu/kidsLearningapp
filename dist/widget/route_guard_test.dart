import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sproutlab/domain/games/play/activity_definition.dart';
import 'package:sproutlab/domain/models/age_band.dart';
import 'package:sproutlab/domain/models/game_category.dart';
import 'package:sproutlab/domain/monetization/free_entitlement_policy.dart';
import 'package:sproutlab/features/play/activity_access.dart';
import 'package:sproutlab/features/play/open_activity.dart';

void main() {
  testWidgets('a second tap does not open a second activity', (tester) async {
    final decision = ActivityAccess(
      activity: const ActivityDefinition(
        id: 'maths:v1:a:1',
        category: GameCategory.maths,
        band: AgeBand.a,
        variant: 1,
        seed: 1,
        title: 'Addition',
        questionCount: 1,
      ),
      access: LevelAccess.locked,
      record: null,
    );
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return TextButton(
                onPressed: () {
                  openActivity(context, decision);
                  openActivity(context, decision);
                },
                child: const Text('Open'),
              );
            },
          ),
        ),
      ),
    );
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    expect(find.text('This new activity is locked.'), findsOneWidget);
  });
}
