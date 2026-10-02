import '../../domain/models/entitlement_snapshot.dart';
import '../../domain/monetization/store_models.dart';
import 'billing_gateway.dart';

/// Used until a Play subscription id is configured, and on non-Android builds.
///
/// It never calls Google Play and never writes an active entitlement.
class InactiveBillingGateway implements BillingGateway {
  const InactiveBillingGateway({
    required this.readCache,
    required this.configured,
  });

  final Future<EntitlementSnapshot> Function() readCache;
  final bool configured;

  @override
  Future<CatalogLoad> loadAnnualOffer() async {
    if (!configured) {
      return CatalogLoad.notConfigured;
    }
    return const CatalogLoad(
      status: CatalogStatus.unavailable,
      message: 'Google Play billing is unavailable on this device. No price is shown.',
    );
  }

  @override
  Future<bool> openSubscriptionManagement() async {
    return false;
  }

  @override
  Future<BillingFlowResult> purchaseAnnual() async {
    final snapshot = await readCache();
    final catalog = await loadAnnualOffer();
    return BillingFlowResult(
      snapshot: snapshot,
      outcome: configured
          ? BillingFlowOutcome.unavailable
          : BillingFlowOutcome.notConfigured,
      message: catalog.message,
    );
  }

  @override
  Future<EntitlementSnapshot> refresh() {
    return readCache();
  }

  @override
  Future<BillingFlowResult> restore() {
    return purchaseAnnual();
  }
}
