import 'package:flutter_test/flutter_test.dart';
import 'package:sproutlab/domain/learning/item_progress.dart';

void main() {
  const rules = ItemPracticeRules();

  test('a single unaided correct guess is Introduced, not Ready to Review', () {
    final first = rules.apply(
      current: rules.empty('letter-hi-a', PracticeMode.recognize),
      attempt: const ItemAttempt(
        completed: true,
        unaided: true,
        hinted: false,
        assisted: false,
        recalled: false,
        nowMillis: 10,
      ),
    );
    expect(first.status, ItemPracticeStatus.introduced);
    expect(first.correct, 1);
    expect(first.unaidedCorrect, 1);
    expect(itemStatusLabel(first.status), 'Introduced');
  });

  test('two unaided completions in the same mode become Ready to Review', () {
    var current = rules.empty('letter-hi-a', PracticeMode.recognize);
    for (final now in [10, 20]) {
      current = rules.apply(
        current: current,
        attempt: ItemAttempt(
          completed: true,
          unaided: true,
          hinted: false,
          assisted: false,
          recalled: false,
          nowMillis: now,
        ),
      );
    }
    expect(current.status, ItemPracticeStatus.readyToReview);
    expect(current.correct, 2);
  });

  test('hinted repeats stay Practising and never say mastery', () {
    var current = rules.empty('letter-hi-a', PracticeMode.recognize);
    current = rules.apply(
      current: current,
      attempt: const ItemAttempt(
        completed: true,
        unaided: true,
        hinted: false,
        assisted: false,
        recalled: false,
        nowMillis: 10,
      ),
    );
    current = rules.apply(
      current: current,
      attempt: const ItemAttempt(
        completed: true,
        unaided: false,
        hinted: true,
        assisted: true,
        recalled: false,
        nowMillis: 20,
      ),
    );
    expect(current.status, ItemPracticeStatus.practising);
    expect(itemStatusLabel(current.status), isNot(contains('master')));
  });

  test('listen, trace and recall stay on separate rows', () {
    expect(PracticeMode.listen, isNot(PracticeMode.trace));
    expect(PracticeMode.listen, isNot(PracticeMode.recall));
    expect(PracticeMode.recognize, isNot(PracticeMode.recall));
    final listen = LearningItemKey(
      itemId: 'letter-hi-a',
      mode: PracticeMode.listen,
    );
    final recall = LearningItemKey(
      itemId: 'letter-hi-a',
      mode: PracticeMode.recall,
    );
    expect(listen, isNot(recall));
  });

  test('a later content version keeps earlier counts', () {
    final first = rules.apply(
      current: rules.empty('letter-hi-a', PracticeMode.listen),
      attempt: const ItemAttempt(
        completed: true,
        unaided: true,
        hinted: false,
        assisted: false,
        recalled: false,
        nowMillis: 10,
        contentVersion: 1,
      ),
    );
    final updated = rules.apply(
      current: first,
      attempt: const ItemAttempt(
        completed: true,
        unaided: true,
        hinted: false,
        assisted: false,
        recalled: false,
        nowMillis: 20,
        contentVersion: 2,
      ),
    );
    expect(updated.contentVersion, 2);
    expect(updated.correct, 2);
    expect(updated.firstCompletedAt, 10);
  });
}
