import 'dart:math';

import '../../models/age_band.dart';
import '../common/level_generator.dart';
import '../play/play_question.dart';

class MathsGenerator {
  const MathsGenerator();

  static const generatorVersion = 'maths:v1';
  static const maxAttempts = 3;

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
          random: Random(seed + index * 17 + attempt),
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
    if ((band == AgeBand.a || band == AgeBand.b) &&
        question.explanation.contains('-')) {
      return const ValidationResult.invalid('negative');
    }
    final expected = _expectedAnswer(question);
    if (expected == null || !_inRange(question, band, expected)) {
      return const ValidationResult.invalid('range');
    }
    final matches = question.choices.where((choice) {
      return choice.id == 'n$expected' && choice.label == '$expected';
    }).length;
    if (matches != 1) {
      return const ValidationResult.invalid('answer');
    }
    if (question.explanation.startsWith('count=')) {
      final groups = [
        for (final visual in question.promptVisuals)
          if (visual is CountGroupVisual) visual,
      ];
      if (groups.length != 1 || groups.first.count != expected) {
        return const ValidationResult.invalid('count visual');
      }
    }
    if (question.explanation.startsWith('numeral=')) {
      final numerals = [
        for (final visual in question.promptVisuals)
          if (visual is NumeralVisual) visual,
      ];
      if (numerals.length != 1 || numerals.first.value != expected) {
        return const ValidationResult.invalid('numeral visual');
      }
    }
    for (final choice in question.choices) {
      final visual = choice.visual;
      if (visual is NumeralVisual && visual.value < 0) {
        return const ValidationResult.invalid('negative choice');
      }
      if (visual is CountGroupVisual && visual.count < 1) {
        return const ValidationResult.invalid('empty group');
      }
    }
    return const ValidationResult.valid();
  }

  PlayQuestion _build({
    required AgeBand band,
    required int variant,
    required Random random,
  }) {
    final mode = _modeFor(band, variant);
    return switch (mode) {
      _MathsMode.count => _count(band, random),
      _MathsMode.bigger => _bigger(band, random),
      _MathsMode.numeral => _numeral(band, random),
      _MathsMode.add => _add(band, random),
      _MathsMode.subtract => _subtract(random),
      _MathsMode.missing => _missing(band, random),
      _MathsMode.groups => _groups(random),
    };
  }

  _MathsMode _modeFor(AgeBand band, int variant) {
    final modes = switch (band) {
      AgeBand.a || AgeBand.toddler => const [
        _MathsMode.count,
        _MathsMode.count,
        _MathsMode.bigger,
        _MathsMode.bigger,
        _MathsMode.numeral,
        _MathsMode.numeral,
      ],
      AgeBand.b => const [
        _MathsMode.count,
        _MathsMode.bigger,
        _MathsMode.add,
        _MathsMode.add,
        _MathsMode.missing,
        _MathsMode.missing,
      ],
      AgeBand.c => const [
        _MathsMode.add,
        _MathsMode.add,
        _MathsMode.subtract,
        _MathsMode.subtract,
        _MathsMode.missing,
        _MathsMode.missing,
      ],
      AgeBand.d => const [
        _MathsMode.add,
        _MathsMode.subtract,
        _MathsMode.groups,
        _MathsMode.groups,
        _MathsMode.missing,
        _MathsMode.add,
      ],
    };
    return modes[variant % modes.length];
  }

  int _choiceCount(AgeBand band) {
    return switch (band) {
      AgeBand.a || AgeBand.toddler || AgeBand.b => 3,
      AgeBand.c || AgeBand.d => 4,
    };
  }

  PlayQuestion _count(AgeBand band, Random random) {
    final max = band == AgeBand.a ? 10 : 20;
    final quantity = 1 + random.nextInt(max);
    return _numericChoices(
      prompt: 'How many leaves?',
      answer: quantity,
      choiceCount: _choiceCount(band),
      random: random,
      allowZero: false,
      explanation: 'count=$quantity',
      firstHint: 'Touch each leaf as you count.',
      strongerHint: 'The highlighted number matches the leaves.',
      promptVisuals: [
        CountGroupVisual(count: quantity, glyph: CountGlyph.leaf),
      ],
    );
  }

  PlayQuestion _numeral(AgeBand band, Random random) {
    final max = band == AgeBand.a ? 5 : 10;
    final answer = 1 + random.nextInt(max);
    return _numericChoices(
      prompt: 'Which number is this?',
      answer: answer,
      choiceCount: _choiceCount(band),
      random: random,
      allowZero: false,
      explanation: 'numeral=$answer',
      firstHint: 'Look at the number shown.',
      strongerHint: 'The highlighted number matches it.',
      promptVisuals: [NumeralVisual(answer)],
    );
  }

  PlayQuestion _bigger(AgeBand band, Random random) {
    final max = band == AgeBand.a ? 8 : 12;
    final counts = <int>{};
    while (counts.length < 3) {
      counts.add(1 + random.nextInt(max));
    }
    final values = counts.toList()..sort();
    final answer = values.last;
    final choices = values
        .map(
          (value) => PlayChoice(
            id: 'n$value',
            label: '$value',
            visual: CountGroupVisual(count: value, glyph: CountGlyph.pebble),
          ),
        )
        .toList();
    choices.shuffle(random);
    return PlayQuestion(
      prompt: 'Which group has more?',
      choices: choices,
      correctId: 'n$answer',
      firstHint: 'Look at the group with the most pebbles.',
      strongerHint: 'The largest group is highlighted.',
      explanation: 'bigger=$answer',
    );
  }

  PlayQuestion _add(AgeBand band, Random random) {
    final limit = switch (band) {
      AgeBand.a || AgeBand.toddler || AgeBand.b => 10,
      AgeBand.c => 20,
      AgeBand.d => 30,
    };
    final addend = band == AgeBand.b
        ? 1 + random.nextInt(2)
        : 1 + random.nextInt(9);
    final startMax = max(1, limit - addend);
    final start = band == AgeBand.b
        ? 1 + random.nextInt(5)
        : 1 + random.nextInt(startMax);
    final answer = start + addend;
    return _numericChoices(
      prompt: '$start + $addend',
      answer: answer,
      choiceCount: _choiceCount(band),
      random: random,
      allowZero: false,
      explanation: '$start+$addend=$answer',
      firstHint: 'Start at $start and count on $addend.',
      strongerHint: 'The highlighted number is the total.',
      promptVisuals: [
        CountGroupVisual(count: start, glyph: CountGlyph.star),
        CountGroupVisual(count: addend, glyph: CountGlyph.star),
      ],
    );
  }

  PlayQuestion _subtract(Random random) {
    final first = 5 + random.nextInt(16);
    final second = 1 + random.nextInt(first);
    final answer = first - second;
    return _numericChoices(
      prompt: '$first - $second',
      answer: answer,
      choiceCount: 4,
      random: random,
      allowZero: true,
      explanation: '$first-$second=$answer',
      firstHint: 'Start at $first and count back $second.',
      strongerHint: 'The highlighted number is left.',
    );
  }

  PlayQuestion _missing(AgeBand band, Random random) {
    final step = band == AgeBand.d && random.nextBool() ? 2 : 1;
    final start = 1 + random.nextInt(band == AgeBand.a ? 4 : 8);
    final shown = [start, start + step, start + (step * 2)];
    final answer = start + (step * 3);
    return _numericChoices(
      prompt: '${shown.join(', ')}, ?',
      answer: answer,
      choiceCount: _choiceCount(band),
      random: random,
      allowZero: false,
      explanation: 'sequence=$answer step=$step',
      firstHint: 'See how much the numbers grow each time.',
      strongerHint: 'The highlighted number comes next.',
    );
  }

  PlayQuestion _groups(Random random) {
    final groups = 2 + random.nextInt(3);
    final each = 2 + random.nextInt(2);
    final answer = groups * each;
    return _numericChoices(
      prompt: '$groups groups of $each. How many altogether?',
      answer: answer,
      choiceCount: 4,
      random: random,
      allowZero: false,
      explanation: 'groups=$groups x $each = $answer',
      firstHint: 'Count one group, then the next.',
      strongerHint: 'The highlighted number is the total.',
      promptVisuals: [
        for (var group = 0; group < groups; group++)
          CountGroupVisual(count: each, glyph: CountGlyph.leaf),
      ],
    );
  }

  PlayQuestion _numericChoices({
    required String prompt,
    required int answer,
    required int choiceCount,
    required Random random,
    required bool allowZero,
    required String explanation,
    required String firstHint,
    required String strongerHint,
    List<ChoiceVisual> promptVisuals = const [],
  }) {
    final values = <int>{answer};
    const deltas = [1, -1, 2, -2, 3, -3, 4, 5];
    for (final delta in deltas) {
      final candidate = answer + delta;
      if (candidate == answer) {
        continue;
      }
      if (!allowZero && candidate <= 0) {
        continue;
      }
      if (allowZero && candidate < 0) {
        continue;
      }
      values.add(candidate);
      if (values.length == choiceCount) {
        break;
      }
    }
    var extra = 1;
    while (values.length < choiceCount) {
      final candidate = answer + 5 + extra;
      extra++;
      if (candidate > 0) {
        values.add(candidate);
      }
    }
    final choices = values
        .map(
          (value) => PlayChoice(
            id: 'n$value',
            label: '$value',
            visual: NumeralVisual(value),
          ),
        )
        .toList();
    choices.shuffle(random);
    return PlayQuestion(
      prompt: prompt,
      choices: choices,
      correctId: 'n$answer',
      firstHint: firstHint,
      strongerHint: strongerHint,
      explanation: explanation,
      promptVisuals: promptVisuals,
    );
  }

  int? _expectedAnswer(PlayQuestion question) {
    final text = question.explanation;
    final direct = RegExp(r'^(?:count|bigger|numeral)=(\d+)$').firstMatch(text);
    if (direct != null) {
      return int.parse(direct.group(1)!);
    }
    final sum = RegExp(r'^(\d+)\+(\d+)=(\d+)$').firstMatch(text);
    if (sum != null) {
      final left = int.parse(sum.group(1)!);
      final right = int.parse(sum.group(2)!);
      final answer = int.parse(sum.group(3)!);
      if (left + right != answer || left < 1 || right < 1) {
        return null;
      }
      return answer;
    }
    final difference = RegExp(r'^(\d+)-(\d+)=(\d+)$').firstMatch(text);
    if (difference != null) {
      final left = int.parse(difference.group(1)!);
      final right = int.parse(difference.group(2)!);
      final answer = int.parse(difference.group(3)!);
      if (left - right != answer || answer < 0 || right < 1) {
        return null;
      }
      return answer;
    }
    final sequence = RegExp(r'^sequence=(\d+) step=(\d+)$').firstMatch(text);
    if (sequence != null) {
      final answer = int.parse(sequence.group(1)!);
      final step = int.parse(sequence.group(2)!);
      final shown = question.prompt
          .replaceAll(', ?', '')
          .split(', ')
          .map(int.tryParse)
          .toList();
      if (shown.any((value) => value == null) || step < 1) {
        return null;
      }
      final numbers = shown.cast<int>();
      for (var index = 1; index < numbers.length; index++) {
        if (numbers[index] - numbers[index - 1] != step) {
          return null;
        }
      }
      if (numbers.last + step != answer) {
        return null;
      }
      return answer;
    }
    final groups = RegExp(r'^groups=(\d+) x (\d+) = (\d+)$').firstMatch(text);
    if (groups != null) {
      final groupCount = int.parse(groups.group(1)!);
      final each = int.parse(groups.group(2)!);
      final answer = int.parse(groups.group(3)!);
      if (groupCount * each != answer) {
        return null;
      }
      return answer;
    }
    return null;
  }

  bool _inRange(PlayQuestion question, AgeBand band, int answer) {
    final text = question.explanation;
    if (text.startsWith('count=')) {
      final max = band == AgeBand.a ? 10 : 20;
      return answer >= 1 && answer <= max;
    }
    if (text.startsWith('bigger=')) {
      final max = band == AgeBand.a ? 8 : 12;
      return answer >= 1 && answer <= max;
    }
    if (text.startsWith('numeral=')) {
      final max = band == AgeBand.a ? 5 : 10;
      return answer >= 1 && answer <= max;
    }
    if (text.contains('+')) {
      final limit = switch (band) {
        AgeBand.a || AgeBand.toddler || AgeBand.b => 10,
        AgeBand.c => 20,
        AgeBand.d => 30,
      };
      return answer >= 2 && answer <= limit;
    }
    if (text.contains('-')) {
      return band != AgeBand.a &&
          band != AgeBand.b &&
          answer >= 0 &&
          answer <= 20;
    }
    if (text.startsWith('sequence=')) {
      return answer >= 2 && answer <= 40;
    }
    if (text.startsWith('groups=')) {
      return band == AgeBand.d && answer >= 4 && answer <= 12;
    }
    return false;
  }

  PlayQuestion _fallback() {
    return PlayQuestion(
      prompt: 'How many leaves?',
      choices: const [
        PlayChoice(id: 'n1', label: '1', visual: NumeralVisual(1)),
        PlayChoice(id: 'n2', label: '2', visual: NumeralVisual(2)),
        PlayChoice(id: 'n3', label: '3', visual: NumeralVisual(3)),
      ],
      correctId: 'n2',
      firstHint: 'Touch each leaf as you count.',
      strongerHint: 'The highlighted number matches the leaves.',
      explanation: 'fallback-count=2',
      promptVisuals: const [CountGroupVisual(count: 2, glyph: CountGlyph.leaf)],
    );
  }
}

enum _MathsMode { count, bigger, numeral, add, subtract, missing, groups }
