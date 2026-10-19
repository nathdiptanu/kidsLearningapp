import 'dart:math';

import '../../models/age_band.dart';
import '../common/level_generator.dart';
import '../play/play_question.dart';

enum PatternRule {
  ab,
  aab,
  abb,
  abc,
  abcb,
  numeric,
  alternatingSize,
  alternatingDirection,
  multiAttribute,
}

class PatternGenerator {
  const PatternGenerator();

  static const generatorVersion = 'pattern:v1';
  static const maxAttempts = 3;

  static const _pool = PatternSymbol.values;

  List<PlayQuestion> generate({
    required AgeBand band,
    required int seed,
    required int variant,
    int count = 3,
  }) {
    return List.generate(count, (index) {
      for (var attempt = 0; attempt < maxAttempts; attempt++) {
        final question = _build(
          band: band,
          variant: variant,
          index: index,
          random: Random(seed + index * 19 + attempt),
        );
        if (validate(question, band: band).isValid) {
          return question;
        }
      }
      return _fallback();
    });
  }

  ValidationResult validate(PlayQuestion question, {required AgeBand band}) {
    if (!question.isValid || question.explanation.startsWith('fallback')) {
      return const ValidationResult.invalid('choices');
    }
    final rule = _ruleFrom(question.explanation);
    if (rule == null || !rulesFor(band).contains(rule)) {
      return const ValidationResult.invalid('rule');
    }
    if (rule == PatternRule.numeric) {
      return _validateNumeric(question);
    }
    final sequence = [
      for (final visual in question.promptVisuals)
        if (visual is SymbolVisual) visual,
    ];
    if (sequence.length < 4) {
      return const ValidationResult.invalid('sequence');
    }
    final expected = _nextVisual(rule, sequence);
    if (expected == null) {
      return const ValidationResult.invalid('continuation');
    }
    final matches = question.choices.where((choice) {
      final visual = choice.visual;
      return visual is SymbolVisual && _sameVisual(visual, expected);
    }).length;
    if (matches != 1 || question.correctId != _choiceId(rule, expected)) {
      return const ValidationResult.invalid('answer');
    }
    if (!_stepsAreVisible(rule, sequence)) {
      return const ValidationResult.invalid('attributes');
    }
    return const ValidationResult.valid();
  }

  List<PatternRule> rulesFor(AgeBand band) {
    return switch (band) {
      AgeBand.a || AgeBand.toddler => const [PatternRule.ab],
      AgeBand.b => const [PatternRule.ab, PatternRule.aab, PatternRule.abb],
      AgeBand.c => const [
        PatternRule.abc,
        PatternRule.abcb,
        PatternRule.abb,
        PatternRule.alternatingSize,
      ],
      AgeBand.d => const [
        PatternRule.numeric,
        PatternRule.abcb,
        PatternRule.alternatingSize,
        PatternRule.alternatingDirection,
        PatternRule.multiAttribute,
        PatternRule.abc,
      ],
    };
  }

  PlayQuestion _build({
    required AgeBand band,
    required int variant,
    required int index,
    required Random random,
  }) {
    final rules = rulesFor(band);
    final rule = rules[(variant + index) % rules.length];
    if (rule == PatternRule.numeric) {
      return _numeric(random);
    }
    final first = _pool[random.nextInt(_pool.length)];
    var second =
        _pool[(first.index + 1 + random.nextInt(_pool.length - 1)) %
            _pool.length];
    var third = _pool[(second.index + 1) % _pool.length];
    if (third == first || third == second) {
      third = _pool.firstWhere((symbol) => symbol != first && symbol != second);
    }
    final sequence = switch (rule) {
      PatternRule.ab => [
        _plain(first),
        _plain(second),
        _plain(first),
        _plain(second),
      ],
      PatternRule.aab => [
        _plain(first),
        _plain(first),
        _plain(second),
        _plain(first),
        _plain(first),
        _plain(second),
      ],
      PatternRule.abb => [
        _plain(first),
        _plain(second),
        _plain(second),
        _plain(first),
        _plain(second),
      ],
      PatternRule.abc => [
        _plain(first),
        _plain(second),
        _plain(third),
        _plain(first),
        _plain(second),
      ],
      PatternRule.abcb => [
        _plain(first),
        _plain(second),
        _plain(third),
        _plain(second),
        _plain(first),
      ],
      PatternRule.alternatingSize => [
        SymbolVisual(first, scale: PatternScale.large),
        SymbolVisual(first, scale: PatternScale.small),
        SymbolVisual(first, scale: PatternScale.large),
        SymbolVisual(first, scale: PatternScale.small),
      ],
      PatternRule.alternatingDirection => [
        for (final heading in const [
          PatternHeading.up,
          PatternHeading.down,
          PatternHeading.up,
          PatternHeading.down,
        ])
          SymbolVisual(PatternSymbol.triangle, heading: heading),
      ],
      PatternRule.multiAttribute => [
        SymbolVisual(first, scale: PatternScale.large),
        SymbolVisual(second, scale: PatternScale.small),
        SymbolVisual(first, scale: PatternScale.large),
        SymbolVisual(second, scale: PatternScale.small),
      ],
      PatternRule.numeric => const <SymbolVisual>[],
    };
    final answer = _nextVisual(rule, sequence)!;
    return _symbolChoices(
      rule: rule,
      sequence: sequence,
      answer: answer,
      alternate: second == first ? third : second,
      random: random,
      choiceCount: band == AgeBand.a || band == AgeBand.b ? 3 : 4,
    );
  }

  SymbolVisual _plain(PatternSymbol symbol) => SymbolVisual(symbol);

  PlayQuestion _symbolChoices({
    required PatternRule rule,
    required List<SymbolVisual> sequence,
    required SymbolVisual answer,
    required PatternSymbol alternate,
    required Random random,
    required int choiceCount,
  }) {
    final visuals = <SymbolVisual>[answer];
    if (rule == PatternRule.alternatingDirection) {
      for (final heading in PatternHeading.values) {
        final visual = SymbolVisual(PatternSymbol.triangle, heading: heading);
        if (!_containsVisual(visuals, visual)) {
          visuals.add(visual);
        }
      }
    } else if (rule == PatternRule.alternatingSize ||
        rule == PatternRule.multiAttribute) {
      for (final scale in PatternScale.values) {
        for (final symbol in [answer.symbol, alternate]) {
          final visual = SymbolVisual(symbol, scale: scale);
          if (!_containsVisual(visuals, visual)) {
            visuals.add(visual);
          }
          if (visuals.length == choiceCount) {
            break;
          }
        }
        if (visuals.length == choiceCount) {
          break;
        }
      }
    } else {
      for (final symbol in _pool) {
        final visual = _plain(symbol);
        if (!_containsVisual(visuals, visual)) {
          visuals.add(visual);
        }
        if (visuals.length == choiceCount) {
          break;
        }
      }
    }
    final limited = visuals.take(choiceCount).toList()..shuffle(random);
    return PlayQuestion(
      prompt: 'What comes next?',
      choices: [
        for (final visual in limited)
          PlayChoice(
            id: _choiceId(rule, visual),
            label: _label(rule, visual),
            visual: visual,
          ),
      ],
      correctId: _choiceId(rule, answer),
      firstHint: 'Look at what changes each time.',
      strongerHint: 'The highlighted picture comes next.',
      explanation: 'rule=${rule.name} answer=${_choiceId(rule, answer)}',
      promptVisuals: sequence,
    );
  }

  PlayQuestion _numeric(Random random) {
    final step = random.nextBool() ? 2 : 1;
    final start = 1 + random.nextInt(4);
    final shown = [start, start + step, start + step * 2, start + step * 3];
    final answer = start + step * 4;
    final values = <int>[answer];
    for (final candidate in [
      answer + step,
      answer - step,
      answer + 1,
      answer + 2,
      answer + 3,
    ]) {
      if (candidate > 0 && !values.contains(candidate)) {
        values.add(candidate);
      }
      if (values.length == 4) {
        break;
      }
    }
    final limited = List<int>.of(values)..shuffle(random);
    return PlayQuestion(
      prompt: '${shown.join(', ')}, ?',
      choices: [
        for (final value in limited)
          PlayChoice(
            id: 'n$value',
            label: '$value',
            visual: NumeralVisual(value),
          ),
      ],
      correctId: 'n$answer',
      firstHint: 'See how much is added each time.',
      strongerHint: 'The highlighted number comes next.',
      explanation: 'rule=numeric step=$step answer=$answer',
    );
  }

  ValidationResult _validateNumeric(PlayQuestion question) {
    final match = RegExp(r'^rule=numeric step=(\d+) answer=(\d+)$')
        .firstMatch(question.explanation);
    if (match == null) {
      return const ValidationResult.invalid('numeric');
    }
    final step = int.parse(match.group(1)!);
    final answer = int.parse(match.group(2)!);
    final shown = question.prompt
        .replaceAll(', ?', '')
        .split(', ')
        .map(int.parse)
        .toList();
    if (step < 1 || shown.length < 3 || answer <= 0) {
      return const ValidationResult.invalid('numeric range');
    }
    for (var index = 1; index < shown.length; index++) {
      if (shown[index] - shown[index - 1] != step) {
        return const ValidationResult.invalid('numeric step');
      }
    }
    if (shown.last + step != answer) {
      return const ValidationResult.invalid('numeric answer');
    }
    final hits = question.choices.where((choice) => choice.id == 'n$answer');
    if (hits.length != 1) {
      return const ValidationResult.invalid('numeric choice');
    }
    return const ValidationResult.valid();
  }

  SymbolVisual? _nextVisual(PatternRule rule, List<SymbolVisual> sequence) {
    if (sequence.isEmpty) {
      return null;
    }
    final index = sequence.length;
    return switch (rule) {
      PatternRule.ab => sequence[index % 2],
      PatternRule.aab => sequence[index % 3],
      PatternRule.abb => sequence[index % 3],
      PatternRule.abc => sequence[index % 3],
      PatternRule.abcb => sequence[index % 4],
      PatternRule.alternatingSize => SymbolVisual(
        sequence.first.symbol,
        scale: index.isEven ? PatternScale.large : PatternScale.small,
      ),
      PatternRule.alternatingDirection => SymbolVisual(
        PatternSymbol.triangle,
        heading: index.isEven ? PatternHeading.up : PatternHeading.down,
      ),
      PatternRule.multiAttribute => sequence[index % 2],
      PatternRule.numeric => null,
    };
  }

  bool _stepsAreVisible(PatternRule rule, List<SymbolVisual> sequence) {
    for (var index = 1; index < sequence.length; index++) {
      final previous = sequence[index - 1];
      final current = sequence[index];
      final changed = switch (rule) {
        PatternRule.alternatingSize =>
          previous.symbol == current.symbol && previous.scale != current.scale,
        PatternRule.alternatingDirection =>
          previous.symbol == current.symbol &&
              previous.heading != current.heading,
        PatternRule.multiAttribute =>
          previous.symbol != current.symbol && previous.scale != current.scale,
        _ => previous.symbol != current.symbol,
      };
      if (!changed && rule != PatternRule.aab && rule != PatternRule.abb) {
        return false;
      }
    }
    if (rule == PatternRule.aab || rule == PatternRule.abb) {
      final symbols = sequence.map((item) => item.symbol).toSet();
      return symbols.length >= 2;
    }
    return true;
  }

  bool _sameVisual(SymbolVisual left, SymbolVisual right) {
    return left.symbol == right.symbol &&
        left.scale == right.scale &&
        left.heading == right.heading;
  }

  bool _containsVisual(List<SymbolVisual> visuals, SymbolVisual visual) {
    return visuals.any((item) => _sameVisual(item, visual));
  }

  String _choiceId(PatternRule rule, SymbolVisual visual) {
    return switch (rule) {
      PatternRule.alternatingSize || PatternRule.multiAttribute =>
        '${visual.scale.name}_${visual.symbol.name}',
      PatternRule.alternatingDirection => visual.heading.name,
      _ => visual.symbol.name,
    };
  }

  String _label(PatternRule rule, SymbolVisual visual) {
    final shape = switch (visual.symbol) {
      PatternSymbol.circle => 'Circle',
      PatternSymbol.square => 'Square',
      PatternSymbol.triangle => 'Triangle',
      PatternSymbol.star => 'Star',
    };
    return switch (rule) {
      PatternRule.alternatingSize || PatternRule.multiAttribute =>
        '${visual.scale == PatternScale.large ? 'Big' : 'Small'} $shape',
      PatternRule.alternatingDirection => switch (visual.heading) {
        PatternHeading.up => 'Up',
        PatternHeading.right => 'Right',
        PatternHeading.down => 'Down',
        PatternHeading.left => 'Left',
      },
      _ => shape,
    };
  }

  PatternRule? _ruleFrom(String explanation) {
    final name = RegExp(r'rule=([a-zA-Z]+)').firstMatch(explanation)?.group(1);
    for (final rule in PatternRule.values) {
      if (rule.name == name) {
        return rule;
      }
    }
    return null;
  }

  PlayQuestion _fallback() {
    return const PlayQuestion(
      prompt: 'What comes next?',
      choices: [
        PlayChoice(
          id: 'circle',
          label: 'Circle',
          visual: SymbolVisual(PatternSymbol.circle),
        ),
        PlayChoice(
          id: 'square',
          label: 'Square',
          visual: SymbolVisual(PatternSymbol.square),
        ),
        PlayChoice(
          id: 'triangle',
          label: 'Triangle',
          visual: SymbolVisual(PatternSymbol.triangle),
        ),
      ],
      correctId: 'circle',
      firstHint: 'Look at the repeating shapes.',
      strongerHint: 'The highlighted picture comes next.',
      explanation: 'fallback-ab',
      promptVisuals: [
        SymbolVisual(PatternSymbol.circle),
        SymbolVisual(PatternSymbol.square),
        SymbolVisual(PatternSymbol.circle),
        SymbolVisual(PatternSymbol.square),
      ],
    );
  }
}
