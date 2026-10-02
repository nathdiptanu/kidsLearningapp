import 'package:flutter_test/flutter_test.dart';
import 'package:sproutlab/core/errors/app_failure.dart';
import 'package:sproutlab/domain/adaptive/adaptive_config.dart';

void main() {
  test('user facing failures stay non-technical', () {
    const failures = <AppFailure>[
      DatabaseFailure(),
      ContentFailure(),
      BillingUnavailableFailure(),
      AudioUnavailableFailure(),
      ProfileAlreadyExistsFailure(),
      InvalidProfileInputFailure(),
    ];
    for (final failure in failures) {
      expect(failure.userMessage, isNot(contains('Exception')));
      expect(failure.userMessage, isNot(contains('SQL')));
      expect(failure.userMessage, isNot(contains('stack')));
      expect(failure.userMessage.toLowerCase(), isNot(contains('199')));
      expect(failure.userMessage, isNot(contains('₹')));
    }
  });

  test('daily mix shares stay within one', () {
    const total =
        AdaptiveConfig.dailyCurrentShare +
        AdaptiveConfig.dailyReviewShare +
        AdaptiveConfig.dailyStretchShare;
    expect(total, closeTo(1, 0.001));
    expect(AdaptiveConfig.recentWindow, 8);
  });
}
