import 'package:flutter_test/flutter_test.dart';
import 'package:sproutlab/domain/learning/item_progress.dart';
import 'package:sproutlab/domain/learning/learning_notes.dart';
import 'package:sproutlab/domain/parent/parent_report.dart';

void main() {
  test('parent notes count unique items and stay factual', () {
    final notes = factualLearningNotes([
      LearningItemSnapshot(
        itemId: 'letter-hi-a',
        mode: PracticeMode.listen,
        contentVersion: 1,
        attempts: 1,
        correct: 1,
        unaidedCorrect: 1,
        hintsUsed: 0,
        assisted: 0,
        recalledCount: 0,
        status: ItemPracticeStatus.introduced,
      ),
      LearningItemSnapshot(
        itemId: 'letter-hi-a',
        mode: PracticeMode.recognize,
        contentVersion: 1,
        attempts: 2,
        correct: 2,
        unaidedCorrect: 1,
        hintsUsed: 1,
        assisted: 1,
        recalledCount: 0,
        status: ItemPracticeStatus.practising,
      ),
      LearningItemSnapshot(
        itemId: 'in-rajasthan',
        mode: PracticeMode.recall,
        contentVersion: 1,
        attempts: 1,
        correct: 1,
        unaidedCorrect: 1,
        hintsUsed: 0,
        assisted: 0,
        recalledCount: 1,
        status: ItemPracticeStatus.introduced,
      ),
    ]);
    expect(notes, contains('Practised 1 Hindi letter.'));
    expect(notes, contains('Recalled 1 previously introduced state name.'));
    expect(notes, contains('Used hints on 1 activity.'));
    expect(notesAreFactual(notes), isTrue);
    expect(ParentReport.disclaimer.toLowerCase(), contains('not an iq score'));
    expect(ParentReport.disclaimer.toLowerCase(), contains('other children'));
    expect(notes.join(' ').toLowerCase(), isNot(contains('iq')));
    expect(notes.join(' ').toLowerCase(), isNot(contains('master')));
    expect(notes.join(' ').toLowerCase(), isNot(contains('other children')));
  });
}
