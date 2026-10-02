import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:sproutlab/core/design_system/sprout_theme.dart';
import 'package:sproutlab/core/design_system/sprout_tokens.dart';

void main() {
  test('Devanagari font files and licence are bundled and declared', () {
    final pubspec = File('pubspec.yaml').readAsStringSync();
    expect(pubspec, contains('family: ${SproutType.devanagari}'));
    for (final weight in [400, 700]) {
      final path = 'assets/fonts/NotoSansDevanagari-$weight.ttf';
      expect(pubspec, contains(path));
      expect(File(path).lengthSync(), greaterThan(100000));
    }
    final licence = File('assets/fonts/NotoSansDevanagari-OFL.txt')
        .readAsStringSync();
    expect(licence, contains('SIL Open Font License, Version 1.1'));
  });

  test('themes fall back to the Devanagari font', () {
    for (final theme in [SproutTheme.child(), SproutTheme.parent()]) {
      for (final style in [
        theme.textTheme.headlineMedium,
        theme.textTheme.bodyLarge,
        theme.textTheme.labelLarge,
      ]) {
        expect(style?.fontFamilyFallback, contains(SproutType.devanagari));
      }
    }
  });
}
