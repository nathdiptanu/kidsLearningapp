import 'item_progress.dart';

/// Factual lines about stored practice. No scores, diagnoses or rankings.
List<String> factualLearningNotes(List<LearningItemSnapshot> rows) {
  final practisedHindiLetters = _unique(
    rows,
    (row) =>
        row.itemId.startsWith('letter-hi-') &&
        row.correct > 0 &&
        row.mode != PracticeMode.recall,
  );
  final traced = _unique(
    rows,
    (row) => row.mode == PracticeMode.trace && row.correct > 0,
  );
  final listened = _unique(
    rows,
    (row) => row.mode == PracticeMode.listen && row.correct > 0,
  );
  final places = _unique(
    rows,
    (row) =>
        row.itemId.startsWith('in-') &&
        row.correct > 0 &&
        row.mode != PracticeMode.recall,
  );
  final recalledPlaces = _unique(
    rows,
    (row) =>
        row.itemId.startsWith('in-') &&
        row.mode == PracticeMode.recall &&
        row.correct > 0,
  );
  final heritage = _unique(
    rows,
    (row) => row.itemId.startsWith('site-') && row.correct > 0,
  );
  final hinted = rows.where((row) => row.hintsUsed > 0).length;
  final notes = <String>[];
  if (practisedHindiLetters > 0) {
    notes.add(
      'Practised $practisedHindiLetters Hindi ${practisedHindiLetters == 1 ? 'letter' : 'letters'}.',
    );
  }
  if (traced > 0) {
    notes.add('Traced $traced ${traced == 1 ? 'letter' : 'letters'}.');
  }
  if (listened > 0) {
    notes.add(
      'Listened to $listened ${listened == 1 ? 'sound or name' : 'sounds or names'}.',
    );
  }
  if (places > 0) {
    notes.add('Recognised $places ${places == 1 ? 'place' : 'places'}.');
  }
  if (recalledPlaces > 0) {
    notes.add(
      'Recalled $recalledPlaces previously introduced ${recalledPlaces == 1 ? 'state name' : 'state names'}.',
    );
  }
  if (heritage > 0) {
    notes.add(
      'Looked at $heritage heritage ${heritage == 1 ? 'place' : 'places'}.',
    );
  }
  if (hinted > 0) {
    notes.add(
      'Used hints on $hinted ${hinted == 1 ? 'activity' : 'activities'}.',
    );
  }
  return notes;
}

int _unique(
  List<LearningItemSnapshot> rows,
  bool Function(LearningItemSnapshot row) keep,
) {
  return {for (final row in rows) if (keep(row)) row.itemId}.length;
}

bool notesAreFactual(Iterable<String> notes) {
  const banned = [
    'iq',
    'mastery',
    'mastered',
    'diagnosis',
    'diagnostic',
    'gifted',
    'behind',
    'ahead of',
    'compared with other',
    'other children',
    'percentile',
  ];
  for (final note in notes) {
    final lower = note.toLowerCase();
    for (final word in banned) {
      if (lower.contains(word)) {
        return false;
      }
    }
  }
  return true;
}
