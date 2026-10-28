import 'dart:math';

import '../../models/age_band.dart';
import '../play/play_question.dart';

class VocabWord {
  const VocabWord({
    required this.id,
    required this.label,
    required this.firstLetter,
  });

  final String id;
  final String label;
  final String firstLetter;
}

/// Reviewed English labels for en-IN. IDs stay locale-neutral.
const vocabWords = <VocabWord>[
  VocabWord(id: 'apple', label: 'Apple', firstLetter: 'A'),
  VocabWord(id: 'banana', label: 'Banana', firstLetter: 'B'),
  VocabWord(id: 'mango', label: 'Mango', firstLetter: 'M'),
  VocabWord(id: 'cat', label: 'Cat', firstLetter: 'C'),
  VocabWord(id: 'dog', label: 'Dog', firstLetter: 'D'),
  VocabWord(id: 'bird', label: 'Bird', firstLetter: 'B'),
  VocabWord(id: 'bus', label: 'Bus', firstLetter: 'B'),
  VocabWord(id: 'car', label: 'Car', firstLetter: 'C'),
  VocabWord(id: 'sun', label: 'Sun', firstLetter: 'S'),
  VocabWord(id: 'moon', label: 'Moon', firstLetter: 'M'),
  VocabWord(id: 'shoe', label: 'Shoe', firstLetter: 'S'),
  VocabWord(id: 'hat', label: 'Hat', firstLetter: 'H'),
  VocabWord(id: 'flower', label: 'Flower', firstLetter: 'F'),
  VocabWord(id: 'fish', label: 'Fish', firstLetter: 'F'),
  VocabWord(id: 'tree', label: 'Tree', firstLetter: 'T'),
  VocabWord(id: 'book', label: 'Book', firstLetter: 'B'),
  VocabWord(id: 'ball', label: 'Ball', firstLetter: 'B'),
  VocabWord(id: 'cup', label: 'Cup', firstLetter: 'C'),
];

enum VocabMode { pictureToWord, wordToPicture, firstLetter, grammar }

class VocabularyGenerator {
  const VocabularyGenerator();

  static const generatorVersion = 'vocabulary:v1';

  List<PlayQuestion> generate({
    required AgeBand band,
    required int seed,
    required int variant,
    int count = 3,
  }) {
    if (variant >= 38 && band != AgeBand.a && band != AgeBand.toddler) {
      return [_grammar(variant, seed)];
    }
    final mode = _mode(band, variant);
    final choiceCount = band == AgeBand.a || band == AgeBand.b ? 3 : 4;
    return List.generate(count, (index) {
      final random = Random(seed + index * 13);
      final question = switch (mode) {
        VocabMode.pictureToWord => _pictureToWord(random, choiceCount),
        VocabMode.wordToPicture => _wordToPicture(random, choiceCount),
        VocabMode.firstLetter => _firstLetter(random, choiceCount),
        VocabMode.grammar => _grammar(variant, seed + index),
      };
      if (question.isValid && _lettersAreUnique(question, mode)) {
        return question;
      }
      return _pictureToWord(Random(1), 3);
    });
  }

  VocabMode _mode(AgeBand band, int variant) {
    if (band == AgeBand.a) {
      return variant.isEven ? VocabMode.pictureToWord : VocabMode.wordToPicture;
    }
    return switch (variant % 3) {
      0 => VocabMode.pictureToWord,
      1 => VocabMode.wordToPicture,
      _ => VocabMode.firstLetter,
    };
  }

  PlayQuestion _pictureToWord(Random random, int choiceCount) {
    final words = _pick(random, choiceCount);
    final answer = words.first;
    final choices = [
      for (final word in words)
        PlayChoice(
          id: word.id,
          label: word.label,
          visual: WordPictureVisual(word.id),
        ),
    ]..shuffle(random);
    return PlayQuestion(
      prompt: 'Which word matches the picture?',
      choices: choices,
      correctId: answer.id,
      firstHint: 'Look at the picture, then read the words.',
      strongerHint: 'The highlighted word matches the picture.',
      explanation: 'picture-to-word ${answer.id}',
      promptVisuals: [WordPictureVisual(answer.id)],
    );
  }

  PlayQuestion _wordToPicture(Random random, int choiceCount) {
    final words = _pick(random, choiceCount);
    final answer = words.first;
    final choices = [
      for (final word in words)
        PlayChoice(
          id: word.id,
          label: word.label,
          visual: WordPictureVisual(word.id),
          showText: false,
        ),
    ]..shuffle(random);
    return PlayQuestion(
      prompt: 'Find the ${answer.label.toLowerCase()}.',
      choices: choices,
      correctId: answer.id,
      firstHint: 'The word tells you which picture to find.',
      strongerHint: 'The highlighted picture matches the word.',
      explanation: 'word-to-picture ${answer.id}',
    );
  }

  PlayQuestion _firstLetter(Random random, int choiceCount) {
    final answer = vocabWords[random.nextInt(vocabWords.length)];
    final letters = <String>{answer.firstLetter};
    final pool = vocabWords.map((word) => word.firstLetter).toList()
      ..shuffle(random);
    for (final letter in pool) {
      letters.add(letter);
      if (letters.length == choiceCount) {
        break;
      }
    }
    var extra = 0;
    while (letters.length < choiceCount) {
      final letter = String.fromCharCode('A'.codeUnitAt(0) + extra);
      extra++;
      if (letter != answer.firstLetter) {
        letters.add(letter);
      }
    }
    final choices =
        letters
            .map(
              (letter) => PlayChoice(
                id: 'letter_$letter',
                label: letter,
                visual: LetterVisual(letter),
              ),
            )
            .toList()
          ..shuffle(random);
    return PlayQuestion(
      prompt: 'What is the first letter?',
      choices: choices,
      correctId: 'letter_${answer.firstLetter}',
      firstHint: 'Say the word, then listen for the first sound.',
      strongerHint: 'The highlighted letter starts the word.',
      explanation: 'first-letter ${answer.id}=${answer.firstLetter}',
      promptVisuals: [WordPictureVisual(answer.id)],
    );
  }

  PlayQuestion _grammar(int variant, int seed) {
    final fact = _grammarFacts[variant % _grammarFacts.length];
    final labels = [fact.$2, fact.$3, fact.$4];
    final ids = const ['answer', 'other1', 'other2'];
    final shift = seed.abs() % labels.length;
    final order = [
      for (var i = 0; i < labels.length; i++) (i + shift) % labels.length,
    ];
    return PlayQuestion(
      prompt: fact.$1,
      choices: [
        for (final index in order)
          PlayChoice(
            id: ids[index],
            label: labels[index],
            visual: LetterVisual(labels[index][0]),
          ),
      ],
      correctId: 'answer',
      firstHint: fact.$5,
      strongerHint: 'The answer is ${fact.$2}.',
      explanation: 'grammar=${fact.$2}',
      teaching: fact.$6,
    );
  }

  List<VocabWord> _pick(Random random, int count) {
    final copy = List<VocabWord>.of(vocabWords)..shuffle(random);
    return copy.take(count).toList();
  }

  bool _lettersAreUnique(PlayQuestion question, VocabMode mode) {
    if (mode != VocabMode.firstLetter) {
      return true;
    }
    final labels = question.choices.map((choice) => choice.label).toSet();
    return labels.length == question.choices.length;
  }
}

const _grammarFacts = <(String, String, String, String, String, String)>[
  ('A noun names a person, place or thing. Which word is a noun?', 'Fox', 'Run', 'Quickly', 'A noun is a name.', 'A noun is a naming word. Fox, home and apple are nouns. Run is a doing word.'),
  ('A verb is a doing word. Which word is a verb?', 'Jump', 'Red', 'Soft', 'A verb shows action.', 'A verb tells what someone does. Jump, eat and sleep are verbs.'),
  ('An adjective describes. Which word is an adjective?', 'Soft', 'Ball', 'Go', 'It tells more about a thing.', 'An adjective describes a noun. Soft, red and tall tell us more.'),
  ('A pronoun stands in for a name. Which word is a pronoun?', 'She', 'Riya', 'House', 'It can replace a name.', 'A pronoun can take a name’s place. She, he, we and they are pronouns.'),
  ('An adverb can tell how. Which word is an adverb?', 'Slowly', 'Cat', 'Blue', 'It often ends with -ly.', 'An adverb can tell how we do something. Slowly and gently are adverbs.'),
  ('Finish the sentence: The cat ___ on the mat.', 'sits', 'sitsing', 'sitness', 'Choose the doing word that fits.', 'A sentence needs a doing word. “The cat sits on the mat” is a full sentence.'),
  ('Which word is a noun in “The sun is warm”?', 'sun', 'is', 'warm', 'Find the naming word.', 'Sun is a thing we can name. Warm describes it. Is is a verb.'),
  ('Which word is a verb in “Birds fly high”?', 'fly', 'Birds', 'high', 'Find the doing word.', 'Fly is what the birds do. High tells how or where.'),
  ('Make a sentence: pick the describing word for “A ___ flower”.', 'pink', 'run', 'they', 'Describe the flower.', 'Pink is an adjective. It tells us what the flower looks like.'),
  ('Which pronoun can replace “Aarav and Mina”?', 'They', 'He', 'It', 'More than one person.', 'They stands for more than one person. He is for one boy. It is for a thing.'),
];
