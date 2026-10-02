import '../models/entitlement_snapshot.dart';
import 'store_models.dart';

/// Authoritative subscription classification from a future verification service.
///
/// This build has no backend. [UnavailableSubscriptionVerifier] always
/// returns null. Grace, account hold, pause, refund, and expiry time are
/// stored only when a verifier supplies them. The Play Billing client cannot
/// distinguish those states, and this app does not invent them.
class VerifiedSubscription {
  const VerifiedSubscription({required this.status, this.expiryMillis});

  final EntitlementStatus status;
  final int? expiryMillis;
}

abstract interface class SubscriptionVerifier {
  /// Returns null when no verification service is configured.
  /// Throws when a configured service cannot confirm the purchase.
  Future<VerifiedSubscription?> verify(StorePurchaseFact fact);
}

class UnavailableSubscriptionVerifier implements SubscriptionVerifier {
  const UnavailableSubscriptionVerifier();

  @override
  Future<VerifiedSubscription?> verify(StorePurchaseFact fact) async {
    return null;
  }
}
