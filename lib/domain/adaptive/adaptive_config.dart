/// Tunable planner inputs from the specification. The planner itself is M5.
abstract final class AdaptiveConfig {
  static const recentWindow = 8;
  static const promoteSuccessRate = 0.80;
  static const demoteSuccessRate = 0.45;
  static const dailyCurrentShare = 0.60;
  static const dailyReviewShare = 0.20;
  static const dailyStretchShare = 0.20;
  static const firstTryCorrectWeight = 3.0;
  static const correctAfterRetryWeight = 1.0;
  static const hintRequiredWeight = 0.5;
  static const wrongWeight = -1.0;
}
