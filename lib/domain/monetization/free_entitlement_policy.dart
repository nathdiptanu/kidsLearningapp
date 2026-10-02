import 'monetization_config.dart';

enum LevelAccess { playNew, replay, continueInProgress, locked }

/// Decides access only. It does not open a store purchase sheet.
class FreeEntitlementPolicy {
  const FreeEntitlementPolicy();

  LevelAccess decide({
    required bool premiumActive,
    required bool alreadyStarted,
    required bool alreadyCompleted,
    required int uniqueFreeLevelsCompleted,
  }) {
    if (alreadyCompleted) {
      return LevelAccess.replay;
    }
    if (alreadyStarted) {
      return LevelAccess.continueInProgress;
    }
    if (premiumActive) {
      return LevelAccess.playNew;
    }
    if (uniqueFreeLevelsCompleted <
        MonetizationConfig.freeCompletedLevelsPerGame) {
      return LevelAccess.playNew;
    }
    return LevelAccess.locked;
  }
}
