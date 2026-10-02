/// Section 101: the first miss is only a retry. Later misses reveal hints.
enum HintStage { none, retryOnly, firstHint, strongerHint }

HintStage hintStageForWrongCount(int wrongCount) {
  if (wrongCount <= 0) {
    return HintStage.none;
  }
  if (wrongCount == 1) {
    return HintStage.retryOnly;
  }
  if (wrongCount == 2) {
    return HintStage.firstHint;
  }
  return HintStage.strongerHint;
}

/// Foreground inactivity may pulse instructions. It is not a wrong answer.
class InstructionPulse {
  bool pulsed = false;

  void noteInactivity() {
    pulsed = true;
  }

  void noteInteraction() {}
}
