/// Play Console subscription identity. Empty until the owner sets it.
///
/// Do not put a guessed product id, base plan, or offer here. The strings
/// must match a subscription created in Play Console for the approved
/// application ID. Price and offers still come from Google Play at runtime.
abstract final class BillingProductConfig {
  static const annualSubscriptionId = '';

  /// Optional. When set, only this base plan is shown and purchased.
  static const basePlanId = '';

  /// Optional. When set, the purchase uses this Play offer id.
  static const offerId = '';

  static bool get isConfigured => annualSubscriptionId.trim().isNotEmpty;
}
