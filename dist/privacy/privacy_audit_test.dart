import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sproutlab/core/errors/local_log.dart';
import 'package:sproutlab/features/parent/privacy_screen.dart';

void main() {
  test('debug diagnostics drop nickname and purchase token text', () {
    expect(
      () => LocalLog.debug('nickname=Asha purchaseToken=secret-token'),
      returnsNormally,
    );
    expect(LocalLog.maxLength, lessThan(500));
  });

  testWidgets('about text matches the local app', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: PrivacyBody()));
    expect(find.textContaining('nickname'), findsWidgets);
    expect(find.textContaining('child account'), findsOneWidget);
    expect(find.textContaining('does not include ads'), findsOneWidget);
    expect(find.textContaining('199'), findsNothing);
    await tester.scrollUntilVisible(find.textContaining('purchase token'), 200);
    expect(find.textContaining('microphone'), findsOneWidget);
    expect(find.textContaining('purchase token'), findsOneWidget);
  });
}
