import 'package:characters/characters.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sproutlab/domain/lessons/development_pack.dart';
import 'package:sproutlab/domain/lessons/language_pack_validator.dart';
import 'package:sproutlab/domain/lessons/lesson_models.dart';
import 'package:sproutlab/domain/lessons/word_builder.dart';

void main() {
  const assembler = WordAssembler();
  final pack = developmentLanguagePack();

  test('Devanagari tokens join as grapheme clusters, not code units', () {
    final anar = pack.words['word_anar']!;
    final tokens = [for (final id in anar.tokenIds) pack.tokens[id]!];
    expect(assembler.join(tokens), 'अनार');
    expect(assembler.graphemes('अनार'), ['अ', 'ना', 'र']);
    expect(
      'अनार'.codeUnits.length,
      greaterThan(assembler.graphemes('अनार').length),
    );
    expect(assembler.sameText(assembler.join(tokens), anar.text), isTrue);
  });

  test('matra sits with its consonant and conjuncts stay whole tokens', () {
    final ki = [pack.tokens['tok_k']!, pack.tokens['tok_i_matra']!];
    expect(assembler.join(ki), 'कि');
    expect(assembler.graphemes('कि'), ['कि']);
    expect(pack.tokens['tok_ksha']!.concept, ConceptType.conjunct);
    expect(pack.tokens['tok_ksha']!.text, 'क्ष');
    expect(pack.tokens['tok_ksha']!.text.characters.length, 1);
  });

  test(
    'a correct curated word is accepted and an unknown mix is not spoken',
    () {
      final anar = pack.words['word_anar']!;
      final correct = assembler.evaluate(
        placed: [for (final id in anar.tokenIds) pack.tokens[id]!],
        target: anar,
        catalog: pack.tokens,
      );
      expect(correct.state, WordBuildState.correct);
      expect(correct.playWordAudio, isTrue);

      final wrong = assembler.evaluate(
        placed: [
          pack.tokens['tok_a']!,
          pack.tokens['tok_ksha']!,
          pack.tokens['tok_m']!,
          pack.tokens['tok_r']!,
        ],
        target: anar,
        catalog: pack.tokens,
      );
      expect(wrong.state, WordBuildState.invalid);
      expect(wrong.playWordAudio, isFalse);
      expect(wrong.prompt, contains('do not make a word'));
      expect(
        assembler.looksLikeKnownWord(
          assembled: wrong.assembled,
          words: pack.words.values,
        ),
        isFalse,
      );
    },
  );

  test('Q is English only and is not paired with a Hindi letter', () {
    expect(englishQNote, contains('Q is the English letter'));
    expect(englishQNote, contains('रानी'));
    expect(englishQNote, isNot(contains('Q =')));
    final queen = pack.lessons.firstWhere(
      (lesson) => lesson.id.contains('q_queen'),
    );
    expect(queen.category.name, 'vocabulary');
    expect(queen.bilingualNote, contains('does not start with a Hindi letter'));
    expect(queen.displayText, 'Q');
  });

  test('release loader drops every unreviewed lesson and stroke template', () {
    final validator = const LanguagePackValidator();
    expect(validator.playable(pack, release: true), isEmpty);
    expect(validator.playable(pack, release: false), isNotEmpty);
    final releaseIssues = validator.validate(pack, release: true);
    expect(releaseIssues, isNotEmpty);
    expect(releaseIssues.join(' '), contains('not approved'));
    expect(validator.validate(pack, release: false), isEmpty);
  });
}
