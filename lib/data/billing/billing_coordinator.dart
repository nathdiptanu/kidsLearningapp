import 'dart:async';

import '../../core/platform/billing_gateway.dart';
import '../../core/platform/store_billing_port.dart';
import '../../domain/models/entitlement_snapshot.dart';
import '../../domain/monetization/entitlement_reconciler.dart';
import '../../domain/monetization/store_models.dart';
import '../../domain/monetization/subscription_verifier.dart';
import '../repositories/drift_entitlement_repository.dart';

class _VerificationFailed implements Exception {
  const _VerificationFailed();
}

/// Connects a store port to the local entitlement cache.
///
/// Trust boundary: a purchase callback never grants Premium. The store must
/// return the subscription from a fresh query, acknowledgement must succeed,
/// and a second query must still show it as acknowledged. There is no
/// Play Developer API call in this build. When [SubscriptionVerifier.verify]
/// returns null, only the client query is used, and grace, hold, pause, and
/// expiry time are not invented. If a verifier is configured and it throws,
/// Premium is not granted.
class BillingCoordinator implements BillingGateway {
  BillingCoordinator({
    required this.productId,
    required this.port,
    required this.repository,
    required this.reconciler,
    required this.verifier,
    required this.parentAuthorized,
    required this.nowMillis,
    this.basePlanId = '',
    this.offerId = '',
    this.purchaseTimeout = const Duration(minutes: 2),
  }) {
    _updates = port.purchaseUpdates.listen((_) {
      _serialized(() => _confirm(restore: false));
    });
  }

  final String productId;
  final String basePlanId;
  final String offerId;
  final Duration purchaseTimeout;
  final StoreBillingPort port;
  final DriftEntitlementRepository repository;
  final EntitlementReconciler reconciler;
  final SubscriptionVerifier verifier;
  final bool Function() parentAuthorized;
  final int Function() nowMillis;
  late final StreamSubscription<List<StorePurchaseFact>> _updates;
  Future<void> _tail = Future<void>.value();
  var _closed = false;

  /// Completes after the current purchase, restore, or update has been saved.
  Future<void> get settled => _tail;

  Future<T> _serialized<T>(Future<T> Function() action) {
    final result = _tail.then((_) => action());
    _tail = result.then((_) {}, onError: (Object _, StackTrace _) {});
    return result;
  }

  @override
  Future<CatalogLoad> loadAnnualOffer() {
    return port.loadOffer(
      productId: productId,
      basePlanId: basePlanId,
      offerId: offerId,
    );
  }

  @override
  Future<EntitlementSnapshot> refresh() async {
    final result = await _serialized(() => _confirm(restore: false));
    return result.snapshot;
  }

  @override
  Future<BillingFlowResult> purchaseAnnual() {
    return _serialized(() async {
      if (!parentAuthorized()) {
        return _refused();
      }
      final catalog = await loadAnnualOffer();
      final offer = catalog.purchaseOffer;
      if (offer == null) {
        return BillingFlowResult(
          snapshot: await repository.read(),
          outcome: _catalogOutcome(catalog.status),
          message: catalog.message,
        );
      }
      final next = port.purchaseUpdates.first.timeout(purchaseTimeout);
      final opened = await port.buy(offer);
      if (opened) {
        try {
          await next;
        } catch (_) {
          // The query below is the confirmation, not this callback.
        }
      }
      final confirmed = await _confirm(restore: false);
      final premium = confirmed.snapshot.premiumActiveAt(nowMillis());
      if (!opened && !premium) {
        return BillingFlowResult(
          snapshot: confirmed.snapshot,
          outcome: BillingFlowOutcome.canceled,
          message: 'The store purchase did not start. Premium stays off.',
        );
      }
      return confirmed;
    });
  }

  @override
  Future<BillingFlowResult> restore() {
    return _serialized(() async {
      if (!parentAuthorized()) {
        return _refused();
      }
      return _confirm(restore: true);
    });
  }

  @override
  Future<bool> openSubscriptionManagement() async {
    if (!parentAuthorized()) {
      return false;
    }
    return port.openManagement(productId);
  }

  Future<void> dispose() async {
    if (_closed) {
      return;
    }
    _closed = true;
    await _updates.cancel();
    await port.dispose();
  }

  Future<BillingFlowResult> _refused() async {
    return BillingFlowResult(
      snapshot: await repository.read(),
      outcome: BillingFlowOutcome.error,
      message: 'A grown-up hold is required before a purchase.',
    );
  }

  Future<BillingFlowResult> _confirm({required bool restore}) async {
    final first = await port.queryPurchases(productId);
    if (first.succeeded) {
      for (final fact in first.purchases) {
        if (fact.productId == productId &&
            fact.phase == StorePurchasePhase.purchased &&
            !fact.acknowledged) {
          await port.acknowledge(fact.purchaseKey);
        }
      }
    }
    final confirmed = first.succeeded
        ? await port.queryPurchases(productId)
        : first;
    if (!confirmed.succeeded) {
      final cached = await repository.read();
      final reconciliation = reconciler.reconcile(
        cached: cached,
        query: confirmed,
        productId: productId,
        nowMillis: nowMillis(),
        restore: restore,
      );
      return BillingFlowResult(
        snapshot: cached,
        outcome: reconciliation.outcome,
        message: reconciliation.message,
      );
    }
    List<StorePurchaseFact> purchases;
    try {
      purchases = await _applyVerifier(confirmed.purchases);
    } on _VerificationFailed {
      return BillingFlowResult(
        snapshot: await repository.read(),
        outcome: BillingFlowOutcome.unverified,
        message: 'The subscription could not be verified. Premium stays off.',
      );
    }
    final reconciliation = reconciler.reconcile(
      cached: await repository.read(),
      query: StorePurchaseQuery(
        connection: StoreConnection.ready,
        purchases: purchases,
      ),
      productId: productId,
      nowMillis: nowMillis(),
      restore: restore,
    );
    if (reconciliation.changed) {
      await repository.save(reconciliation.snapshot);
    }
    return BillingFlowResult(
      snapshot: reconciliation.snapshot,
      outcome: reconciliation.outcome,
      message: reconciliation.message,
    );
  }

  Future<List<StorePurchaseFact>> _applyVerifier(
    List<StorePurchaseFact> facts,
  ) async {
    final next = <StorePurchaseFact>[];
    for (final fact in facts) {
      if (fact.phase != StorePurchasePhase.purchased || !fact.acknowledged) {
        next.add(fact);
        continue;
      }
      try {
        final verified = await verifier.verify(fact);
        if (verified == null) {
          next.add(fact);
        } else {
          next.add(
            StorePurchaseFact(
              productId: fact.productId,
              purchaseKey: fact.purchaseKey,
              phase: fact.phase,
              acknowledged: fact.acknowledged,
              autoRenewing: fact.autoRenewing,
              expiryMillis: verified.expiryMillis,
              verifiedStatus: verified.status,
            ),
          );
        }
      } catch (_) {
        throw const _VerificationFailed();
      }
    }
    return next;
  }

  BillingFlowOutcome _catalogOutcome(CatalogStatus status) {
    return switch (status) {
      CatalogStatus.notConfigured => BillingFlowOutcome.notConfigured,
      CatalogStatus.unavailable => BillingFlowOutcome.unavailable,
      CatalogStatus.missingProduct => BillingFlowOutcome.missingProduct,
      CatalogStatus.offline => BillingFlowOutcome.offline,
      CatalogStatus.ready || CatalogStatus.error => BillingFlowOutcome.error,
    };
  }
}
