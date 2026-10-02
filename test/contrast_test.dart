import 'package:flutter_test/flutter_test.dart';
import 'package:sproutlab/core/design_system/contrast.dart';
import 'package:sproutlab/core/design_system/sprout_tokens.dart';

void main() {
  test('palette pairs meet the contrast floors', () {
    final pairs = <ContrastPair>[
      const ContrastPair(
        name: 'body on canvas',
        foreground: SproutColors.ink,
        background: SproutColors.background,
        minimum: 4.5,
      ),
      const ContrastPair(
        name: 'body on surface',
        foreground: SproutColors.ink,
        background: SproutColors.surface,
        minimum: 4.5,
      ),
      const ContrastPair(
        name: 'secondary on canvas',
        foreground: SproutColors.inkMuted,
        background: SproutColors.background,
        minimum: 4.5,
      ),
      const ContrastPair(
        name: 'secondary on surface',
        foreground: SproutColors.inkMuted,
        background: SproutColors.surface,
        minimum: 4.5,
      ),
      const ContrastPair(
        name: 'primary label',
        foreground: SproutColors.surface,
        background: SproutColors.primary,
        minimum: 4.5,
      ),
      const ContrastPair(
        name: 'pressed primary label',
        foreground: SproutColors.surface,
        background: SproutColors.primaryPressed,
        minimum: 4.5,
      ),
      const ContrastPair(
        name: 'selected card text',
        foreground: SproutColors.ink,
        background: SproutColors.primarySoft,
        minimum: 4.5,
      ),
      const ContrastPair(
        name: 'disabled label',
        foreground: SproutColors.disabledInk,
        background: SproutColors.disabledFill,
        minimum: 4.5,
      ),
      const ContrastPair(
        name: 'correct on surface',
        foreground: SproutColors.success,
        background: SproutColors.surface,
        minimum: 4.5,
      ),
      const ContrastPair(
        name: 'retry on surface',
        foreground: SproutColors.retry,
        background: SproutColors.surface,
        minimum: 4.5,
      ),
      const ContrastPair(
        name: 'star on surface',
        foreground: SproutColors.accent,
        background: SproutColors.surface,
        minimum: 4.5,
      ),
      const ContrastPair(
        name: 'maths label on tint',
        foreground: SproutColors.ink,
        background: SproutColors.mathsSurface,
        minimum: 4.5,
      ),
      const ContrastPair(
        name: 'english label on tint',
        foreground: SproutColors.ink,
        background: SproutColors.englishSurface,
        minimum: 4.5,
      ),
      const ContrastPair(
        name: 'logic label on tint',
        foreground: SproutColors.ink,
        background: SproutColors.logicSurface,
        minimum: 4.5,
      ),
      const ContrastPair(
        name: 'observation label on tint',
        foreground: SproutColors.ink,
        background: SproutColors.observationSurface,
        minimum: 4.5,
      ),
      const ContrastPair(
        name: 'knowledge label on tint',
        foreground: SproutColors.ink,
        background: SproutColors.knowledgeSurface,
        minimum: 4.5,
      ),
      const ContrastPair(
        name: 'primary icon on canvas',
        foreground: SproutColors.primary,
        background: SproutColors.background,
        minimum: 3,
      ),
      const ContrastPair(
        name: 'border on canvas',
        foreground: SproutColors.line,
        background: SproutColors.background,
        minimum: 3,
      ),
      const ContrastPair(
        name: 'maths mark on tint',
        foreground: SproutColors.maths,
        background: SproutColors.mathsSurface,
        minimum: 3,
      ),
      const ContrastPair(
        name: 'english mark on tint',
        foreground: SproutColors.english,
        background: SproutColors.englishSurface,
        minimum: 3,
      ),
      const ContrastPair(
        name: 'logic mark on tint',
        foreground: SproutColors.logic,
        background: SproutColors.logicSurface,
        minimum: 3,
      ),
      const ContrastPair(
        name: 'observation mark on tint',
        foreground: SproutColors.observation,
        background: SproutColors.observationSurface,
        minimum: 3,
      ),
      const ContrastPair(
        name: 'knowledge mark on tint',
        foreground: SproutColors.knowledge,
        background: SproutColors.knowledgeSurface,
        minimum: 3,
      ),
      const ContrastPair(
        name: 'ready chip text',
        foreground: SproutColors.primary,
        background: SproutColors.primarySoft,
        minimum: 4.5,
      ),
      const ContrastPair(
        name: 'finished chip text',
        foreground: SproutColors.success,
        background: SproutColors.successSoft,
        minimum: 4.5,
      ),
      const ContrastPair(
        name: 'continue chip text',
        foreground: SproutColors.accent,
        background: SproutColors.englishSurface,
        minimum: 4.5,
      ),
      const ContrastPair(
        name: 'locked chip text',
        foreground: SproutColors.lock,
        background: SproutColors.disabledFill,
        minimum: 4.5,
      ),
      const ContrastPair(
        name: 'wordmark and links on canvas',
        foreground: SproutColors.primary,
        background: SproutColors.background,
        minimum: 4.5,
      ),
      const ContrastPair(
        name: 'secondary text on lavender card',
        foreground: SproutColors.inkMuted,
        background: SproutColors.primarySoft,
        minimum: 4.5,
      ),
      const ContrastPair(
        name: 'body on tic-tac-toe tint',
        foreground: SproutColors.ink,
        background: SproutColors.ticTacToeSurface,
        minimum: 4.5,
      ),
      const ContrastPair(
        name: 'body on maze tint',
        foreground: SproutColors.ink,
        background: SproutColors.mazeSurface,
        minimum: 4.5,
      ),
      const ContrastPair(
        name: 'body on success tint',
        foreground: SproutColors.ink,
        background: SproutColors.successSoft,
        minimum: 4.5,
      ),
      const ContrastPair(
        name: 'cross mark on board cell',
        foreground: SproutColors.maths,
        background: SproutColors.surface,
        minimum: 3,
      ),
      const ContrastPair(
        name: 'circle mark on board cell',
        foreground: SproutColors.retry,
        background: SproutColors.surface,
        minimum: 3,
      ),
      const ContrastPair(
        name: 'control edge on surface',
        foreground: SproutColors.line,
        background: SproutColors.surface,
        minimum: 3,
      ),
      const ContrastPair(
        name: 'progress fill on lavender track',
        foreground: SproutColors.primary,
        background: SproutColors.primarySoft,
        minimum: 3,
      ),
      const ContrastPair(
        name: 'empty star on surface',
        foreground: SproutColors.line,
        background: SproutColors.surface,
        minimum: 3,
      ),
    ];
    for (final pair in pairs) {
      final ratio = contrastRatio(pair.foreground, pair.background);
      expect(
        ratio,
        greaterThanOrEqualTo(pair.minimum),
        reason: '${pair.name} is ${ratio.toStringAsFixed(2)}:1',
      );
    }
  });
}
