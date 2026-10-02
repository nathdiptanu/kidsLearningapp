import 'package:flutter_test/flutter_test.dart';
import 'package:sproutlab/domain/monetization/free_entitlement_policy.dart';
import 'package:sproutlab/domain/monetization/monetization_config.dart';

void main() {
  const policy = FreeEntitlementPolicy();

  test('free allowance is five completed levels', () {
    expect(MonetizationConfig.freeCompletedLevelsPerGame, 5);
  });

  test('a started level is not locked', () {
    expect(
      policy.decide(
        premiumActive: false,
        alreadyStarted: true,
        alreadyCompleted: false,
        uniqueFreeLevelsCompleted: 5,
      ),
      LevelAccess.continueInProgress,
    );
  });

  test('replay stays available after the allowance is used', () {
    expect(
      policy.decide(
        premiumActive: false,
        alreadyStarted: false,
        alreadyCompleted: true,
        uniqueFreeLevelsCompleted: 5,
      ),
      LevelAccess.replay,
    );
  });

  test('a sixth new level locks for a free profile', () {
    expect(
      policy.decide(
        premiumActive: false,
        alreadyStarted: false,
        alreadyCompleted: false,
        uniqueFreeLevelsCompleted: 5,
      ),
      LevelAccess.locked,
    );
  });

  test('premium can start a new level after the free allowance', () {
    expect(
      policy.decide(
        premiumActive: true,
        alreadyStarted: false,
        alreadyCompleted: false,
        uniqueFreeLevelsCompleted: 5,
      ),
      LevelAccess.playNew,
    );
  });
}
