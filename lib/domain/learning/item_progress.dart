/// How a learning item was practised. These stay separate so a listen
/// success is never treated as unaided recall or as handwriting.
enum PracticeMode { listen, recognize, trace, build, locate, recall }

/// Practice labels only. A single correct tap is never mastery.
enum ItemPracticeStatus { introduced, practising, readyToReview }

class LearningItemKey {
  const LearningItemKey({required this.itemId, required this.mode});

  final String itemId;
  final PracticeMode mode;

  @override
  bool operator ==(Object other) {
    return other is LearningItemKey &&
        other.itemId == itemId &&
        other.mode == mode;
  }

  @override
  int get hashCode => Object.hash(itemId, mode);
}

class LearningItemSnapshot {
  const LearningItemSnapshot({
    required this.itemId,
    required this.mode,
    required this.contentVersion,
    required this.attempts,
    required this.correct,
    required this.unaidedCorrect,
    required this.hintsUsed,
    required this.assisted,
    required this.recalledCount,
    required this.status,
    this.firstCompletedAt,
    this.lastCompletedAt,
    this.lastSeenAt = 0,
  });

  final String itemId;
  final PracticeMode mode;
  final int contentVersion;
  final int attempts;
  final int correct;
  final int unaidedCorrect;
  final int hintsUsed;
  final int assisted;
  final int recalledCount;
  final ItemPracticeStatus status;
  final int? firstCompletedAt;
  final int? lastCompletedAt;
  final int lastSeenAt;

  LearningItemKey get key => LearningItemKey(itemId: itemId, mode: mode);

  bool get hasBeenIntroduced => correct > 0 || attempts > 0;
}

class ItemAttempt {
  const ItemAttempt({
    required this.completed,
    required this.unaided,
    required this.hinted,
    required this.assisted,
    required this.recalled,
    required this.nowMillis,
    this.contentVersion = 1,
  });

  final bool completed;
  final bool unaided;
  final bool hinted;
  final bool assisted;
  final bool recalled;
  final int nowMillis;
  final int contentVersion;
}

/// Explainable status rules. They describe app practice, not ability.
class ItemPracticeRules {
  const ItemPracticeRules();

  ItemPracticeStatus statusFor({
    required int correct,
    required int unaidedCorrect,
    required int recalledCount,
    required PracticeMode mode,
  }) {
    if (correct <= 1) {
      return ItemPracticeStatus.introduced;
    }
    final ready = unaidedCorrect >= 2 &&
        (mode != PracticeMode.recall || recalledCount >= 2) &&
        (mode == PracticeMode.recall || unaidedCorrect >= 2);
    if (ready && !(correct == 1 && unaidedCorrect == 1)) {
      return ItemPracticeStatus.readyToReview;
    }
    return ItemPracticeStatus.practising;
  }

  LearningItemSnapshot apply({
    required LearningItemSnapshot current,
    required ItemAttempt attempt,
  }) {
    final attempts = current.attempts + 1;
    final correct = current.correct + (attempt.completed ? 1 : 0);
    final unaided =
        current.unaidedCorrect + (attempt.completed && attempt.unaided ? 1 : 0);
    final hints = current.hintsUsed + (attempt.hinted ? 1 : 0);
    final assisted = current.assisted + (attempt.assisted ? 1 : 0);
    final recalled =
        current.recalledCount +
        (attempt.completed && attempt.recalled && attempt.unaided ? 1 : 0);
    return LearningItemSnapshot(
      itemId: current.itemId,
      mode: current.mode,
      contentVersion: attempt.contentVersion,
      attempts: attempts,
      correct: correct,
      unaidedCorrect: unaided,
      hintsUsed: hints,
      assisted: assisted,
      recalledCount: recalled,
      firstCompletedAt: current.firstCompletedAt ??
          (attempt.completed ? attempt.nowMillis : null),
      lastCompletedAt: attempt.completed
          ? attempt.nowMillis
          : current.lastCompletedAt,
      lastSeenAt: attempt.nowMillis,
      status: statusFor(
        correct: correct,
        unaidedCorrect: unaided,
        recalledCount: recalled,
        mode: current.mode,
      ),
    );
  }

  LearningItemSnapshot empty(String itemId, PracticeMode mode) {
    return LearningItemSnapshot(
      itemId: itemId,
      mode: mode,
      contentVersion: 1,
      attempts: 0,
      correct: 0,
      unaidedCorrect: 0,
      hintsUsed: 0,
      assisted: 0,
      recalledCount: 0,
      status: ItemPracticeStatus.introduced,
    );
  }
}

String practiceModeLabel(PracticeMode mode) {
  return switch (mode) {
    PracticeMode.listen => 'Listening',
    PracticeMode.recognize => 'Recognition',
    PracticeMode.trace => 'Tracing',
    PracticeMode.build => 'Word building',
    PracticeMode.locate => 'Location',
    PracticeMode.recall => 'Unaided recall',
  };
}

String itemStatusLabel(ItemPracticeStatus status) {
  return switch (status) {
    ItemPracticeStatus.introduced => 'Introduced',
    ItemPracticeStatus.practising => 'Practising',
    ItemPracticeStatus.readyToReview => 'Ready to Review',
  };
}
