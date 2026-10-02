import '../models/entitlement_snapshot.dart';
import 'offline_entitlement_policy.dart';
import 'store_models.dart';

/// Decides the cached entitlement from a Play query or a verification result.
///
/// A purchase callback is not an input. The caller must query the store
/// first. Failed queries leave the cache unchanged. Progress is never touched.
class EntitlementReconciler {
  const EntitlementReconciler();

  Reconciliation reconcile({
    required EntitlementSnapshot cached,
    required StorePurchaseQuery query,
    required String productId,
    required int nowMillis,
    bool restore = false,
  }) {
    if (!query.succeeded) {
      return Reconciliation(
        snapshot: cached,
        outcome: _connectionOutcome(query.connection),
        message: _connectionMessage(query.connection),
        changed: false,
      );
    }

    final matching = <String, StorePurchaseFact>{};
    for (final fact in query.purchases) {
      if (fact.productId != productId) {
        continue;
      }
      if (fact.phase == StorePurchasePhase.canceled ||
          fact.phase == StorePurchasePhase.error) {
        continue;
      }
      matching[fact.purchaseKey] = fact;
    }
    final facts = matching.values.toList();
    if (facts.isEmpty) {
      return _absent(
        cached: cached,
        productId: productId,
        nowMillis: nowMillis,
      );
    }

    final purchased = facts
        .where((fact) => fact.phase == StorePurchasePhase.purchased)
        .toList();
    final acknowledged = purchased.where((fact) => fact.acknowledged).toList();
    if (acknowledged.isEmpty) {
      final paymentPending = purchased.isEmpty;
      return Reconciliation(
        snapshot: EntitlementSnapshot(
          status: EntitlementStatus.pending,
          productId: productId,
          lastReconciledAtMillis: nowMillis,
        ),
        outcome: paymentPending
            ? BillingFlowOutcome.pending
            : BillingFlowOutcome.unverified,
        message: paymentPending
            ? 'A payment is still pending. Premium stays off until Google Play confirms it.'
            : 'The subscription is not confirmed yet. Premium stays off.',
        changed: true,
      );
    }

    final chosen = _prefer(acknowledged);
    final verified = chosen.verifiedStatus;
    if (verified != null) {
      return _verified(
        chosen: chosen,
        status: verified,
        productId: productId,
        nowMillis: nowMillis,
        restore: restore,
      );
    }
    if (chosen.autoRenewing == false) {
      return _granted(
        status: EntitlementStatus.cancelledButValid,
        productId: productId,
        expiryMillis: chosen.expiryMillis,
        nowMillis: nowMillis,
        restore: restore,
        message: 'The subscription is cancelled. Premium stays available only while the cached grant is still inside its time limit. Google Play did not send an expiry time.',
      );
    }
    return _granted(
      status: EntitlementStatus.active,
      productId: productId,
      expiryMillis: chosen.expiryMillis,
      nowMillis: nowMillis,
      restore: restore,
      message: chosen.expiryMillis == null
          ? 'Premium is active on this device. Google Play did not send an expiry time, so an offline device keeps Premium for ${OfflineEntitlementPolicy.window.inDays} days after this check.'
          : 'Premium is active on this device.',
    );
  }

  Reconciliation _absent({
    required EntitlementSnapshot cached,
    required String productId,
    required int nowMillis,
  }) {
    final previouslySubscribed = switch (cached.status) {
      EntitlementStatus.active ||
      EntitlementStatus.gracePeriod ||
      EntitlementStatus.cancelledButValid ||
      EntitlementStatus.pending ||
      EntitlementStatus.onHold ||
      EntitlementStatus.paused ||
      EntitlementStatus.expired => true,
      _ => false,
    };
    if (!previouslySubscribed) {
      return Reconciliation(
        snapshot: EntitlementSnapshot(
          status: EntitlementStatus.inactive,
          lastReconciledAtMillis: nowMillis,
        ),
        outcome: BillingFlowOutcome.noPurchase,
        message: 'Google Play did not return a subscription for this account.',
        changed: true,
      );
    }
    return Reconciliation(
      snapshot: EntitlementSnapshot(
        status: EntitlementStatus.expired,
        productId: cached.productId ?? productId,
        lastReconciledAtMillis: nowMillis,
      ),
      outcome: BillingFlowOutcome.expired,
      message: 'Google Play no longer reports a subscription. Premium is off. Saved learning stays on this device.',
      changed: true,
    );
  }

  Reconciliation _verified({
    required StorePurchaseFact chosen,
    required EntitlementStatus status,
    required String productId,
    required int nowMillis,
    required bool restore,
  }) {
    final entitled =
        status == EntitlementStatus.active ||
        status == EntitlementStatus.gracePeriod ||
        status == EntitlementStatus.cancelledButValid;
    return Reconciliation(
      snapshot: EntitlementSnapshot(
        status: status,
        productId: productId,
        expiryMillis: chosen.expiryMillis,
        lastReconciledAtMillis: nowMillis,
      ),
      outcome: entitled
          ? (restore
                ? BillingFlowOutcome.restored
                : BillingFlowOutcome.purchased)
          : BillingFlowOutcome.expired,
      message: switch (status) {
        EntitlementStatus.gracePeriod => 'Premium is active while the verification service reports a grace period.',
        EntitlementStatus.cancelledButValid => 'The subscription is cancelled and remains available until its expiry.',
        EntitlementStatus.onHold =>
          'The subscription is on hold. Premium stays off.',
        EntitlementStatus.paused =>
          'The subscription is paused. Premium stays off.',
        EntitlementStatus.expired => 'The verification service reports that the subscription has ended. Premium stays off. Saved learning stays on this device.',
        EntitlementStatus.pending => 'The verification service has not confirmed the subscription. Premium stays off.',
        _ =>
          entitled
              ? 'Premium is active on this device.'
              : 'Premium is not active.',
      },
      changed: true,
    );
  }

  Reconciliation _granted({
    required EntitlementStatus status,
    required String productId,
    required int? expiryMillis,
    required int nowMillis,
    required bool restore,
    required String message,
  }) {
    return Reconciliation(
      snapshot: EntitlementSnapshot(
        status: status,
        productId: productId,
        expiryMillis: expiryMillis,
        lastReconciledAtMillis: nowMillis,
      ),
      outcome: restore
          ? BillingFlowOutcome.restored
          : BillingFlowOutcome.purchased,
      message: restore ? 'Premium is restored on this device.' : message,
      changed: true,
    );
  }

  StorePurchaseFact _prefer(List<StorePurchaseFact> facts) {
    for (final fact in facts) {
      if (fact.autoRenewing != false) {
        return fact;
      }
    }
    return facts.first;
  }

  BillingFlowOutcome _connectionOutcome(StoreConnection connection) {
    return switch (connection) {
      StoreConnection.offline => BillingFlowOutcome.offline,
      StoreConnection.unavailable => BillingFlowOutcome.unavailable,
      StoreConnection.error ||
      StoreConnection.ready => BillingFlowOutcome.error,
    };
  }

  String _connectionMessage(StoreConnection connection) {
    return switch (connection) {
      StoreConnection.offline => 'Google Play could not be reached. Saved Premium stays as last confirmed.',
      StoreConnection.unavailable =>
        'Google Play billing is unavailable on this device.',
      StoreConnection.error || StoreConnection.ready => 'Google Play could not confirm the subscription. Premium was not changed.',
    };
  }
}
