import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sproutlab/core/design_system/sprout_theme.dart';
import 'package:sproutlab/core/design_system/sprout_tokens.dart';

void main() {
  testWidgets('Devanagari matras and conjuncts render at 1x and 2x text', (
    tester,
  ) async {
    const sample = 'कि की कु कू के कै को कौ अं अँ क्ष त्र ज्ञ श्र';
    for (final scale in [1.0, 2.0]) {
      await tester.pumpWidget(
        MaterialApp(
          theme: SproutTheme.child(),
          home: MediaQuery(
            data: MediaQueryData(textScaler: TextScaler.linear(scale)),
            child: const Scaffold(
              body: Center(
                child: Text(
                  sample,
                  style: TextStyle(
                    fontFamily: SproutType.family,
                    fontFamilyFallback: SproutType.fallback,
                    height: SproutType.devanagariHeight,
                    fontSize: 28,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text(sample), findsOneWidget);
      expect(tester.takeException(), isNull);
    }
  });
}
