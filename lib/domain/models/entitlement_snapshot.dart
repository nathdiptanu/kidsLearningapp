import '../monetization/offline_entitlement_policy.dart';

enum EntitlementStatus {
  unknown,
  inactive,
  active,
  pending,
  gracePeriod,
  onHold,
  paused,
  expired,
  cancelledButValid,
}

/// Cached entitlement. Price is never stored here.
class EntitlementSnapshot {
  const EntitlementSnapshot({
    required this.status,
    this.productId,
    this.expiryMillis,
    this.lastReconciledAtMillis,
  });

  final EntitlementStatus status;
  final String? productId;
  final int? expiryMillis;
  final int? lastReconciledAtMillis;

  static const inactive = EntitlementSnapshot(
    status: EntitlementStatus.inactive,
  );

  /// Premium is on only for a verified grant that is still inside its bound.
  ///
  /// A known expiry wins. When Play does not send an expiry, a cached grant
  /// lasts only for [OfflineEntitlementPolicy.window] after the last
  /// successful reconciliation. A missing expiry is not permanent Premium.
  /// Pending, hold, pause, expired and unknown states do not unlock content.
  bool premiumActiveAt(int nowMillis) {
    final entitled =
        status == EntitlementStatus.active ||
        status == EntitlementStatus.gracePeriod ||
        status == EntitlementStatus.cancelledButValid;
    if (!entitled) {
      return false;
    }
    final expiry = expiryMillis;
    if (expiry != null) {
      return expiry > nowMillis;
    }
    final reconciled = lastReconciledAtMillis;
    if (reconciled == null) {
      return false;
    }
    final age = nowMillis - reconciled;
    return age >= 0 && age <= OfflineEntitlementPolicy.window.inMilliseconds;
  }
}
