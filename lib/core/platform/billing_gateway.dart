import '../../domain/models/entitlement_snapshot.dart';
import '../../domain/monetization/store_models.dart';

/// Platform billing. Child widgets must not receive this object.
abstract interface class BillingGateway {
  Future<CatalogLoad> loadAnnualOffer();

  /// Reconciles with the store when one is configured. A failed check keeps
  /// the cached snapshot and does not grant Premium.
  Future<EntitlementSnapshot> refresh();

  /// Parent action only. Must not run unless a grown-up hold is current.
  Future<BillingFlowResult> purchaseAnnual();

  /// Parent action only.
  Future<BillingFlowResult> restore();

  /// Parent action only. Opens the store subscription page when supported.
  Future<bool> openSubscriptionManagement();
}
