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

enum VocabMode { pictureToWord, wordToPicture, firstLetter }

class VocabularyGenerator {
  const VocabularyGenerator();

  static const generatorVersion = 'vocabulary:v1';

  List<PlayQuestion> generate({
    required AgeBand band,
    required int seed,
    required int variant,
    int count = 3,
  }) {
    final mode = _mode(band, variant);
    final choiceCount = band == AgeBand.a || band == AgeBand.b ? 3 : 4;
    return List.generate(count, (index) {
      final random = Random(seed + index * 13);
      final question = switch (mode) {
        VocabMode.pictureToWord => _pictureToWord(random, choiceCount),
        VocabMode.wordToPicture => _wordToPicture(random, choiceCount),
        VocabMode.firstLetter => _firstLetter(random, choiceCount),
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
