import 'package:characters/characters.dart';

import 'lesson_models.dart';

/// Assembles curated pedagogical tokens. Tokens may hold several code
/// points (a matra, a conjunct, or a Latin digraph). Comparison uses
/// grapheme clusters, never bytes or UTF-16 code units.
class WordAssembler {
  const WordAssembler();

  String join(Iterable<LessonToken> tokens) {
    final buffer = StringBuffer();
    for (final token in tokens) {
      buffer.write(token.text);
    }
    return buffer.toString();
  }

  List<String> graphemes(String value) {
    return value.characters.toList();
  }

  bool sameText(String left, String right) {
    return left.characters.toString() == right.characters.toString();
  }

  WordBuildResult evaluate({
    required List<LessonToken> placed,
    required CuratedWord target,
    required Map<String, LessonToken> catalog,
  }) {
    final expected = [
      for (final id in target.tokenIds)
        if (catalog[id] != null) catalog[id]!,
    ];
    if (expected.length != target.tokenIds.length) {
      return const WordBuildResult(
        state: WordBuildState.invalid,
        assembled: '',
        prompt: 'This word is not ready yet.',
      );
    }
    final assembled = join(placed);
    if (placed.length < expected.length) {
      return WordBuildResult(
        state: WordBuildState.incomplete,
        assembled: assembled,
      );
    }
    final idsMatch = _idsEqual(placed, expected);
    final textMatch = sameText(assembled, target.text);
    if (idsMatch && textMatch) {
      return WordBuildResult(
        state: WordBuildState.correct,
        assembled: assembled,
        playWordAudio: true,
      );
    }
    return WordBuildResult(
      state: WordBuildState.invalid,
      assembled: assembled,
      prompt: 'Those pieces do not make a word we know. Try another order.',
    );
  }

  bool looksLikeKnownWord({
    required String assembled,
    required Iterable<CuratedWord> words,
  }) {
    for (final word in words) {
      if (sameText(assembled, word.text)) {
        return true;
      }
    }
    return false;
  }

  bool _idsEqual(List<LessonToken> placed, List<LessonToken> expected) {
    if (placed.length != expected.length) {
      return false;
    }
    for (var index = 0; index < placed.length; index++) {
      if (placed[index].id != expected[index].id) {
        return false;
      }
    }
    return true;
  }
}

enum WordBuildState { incomplete, correct, invalid }

class WordBuildResult {
  const WordBuildResult({
    required this.state,
    required this.assembled,
    this.prompt,
    this.playWordAudio = false,
  });

  final WordBuildState state;
  final String assembled;
  final String? prompt;
  final bool playWordAudio;
}

/// Q is an English letter. A Hindi meaning may sit beside the English
/// word. It is never treated as a Hindi letter that "equals" Q.
const englishQNote =
    'Q is the English letter. Queen is an English word. '
    'रानी can mean queen in Hindi, but it does not start with a Hindi letter that matches Q.';
