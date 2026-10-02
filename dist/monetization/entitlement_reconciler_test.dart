import 'package:flutter_test/flutter_test.dart';
import 'package:sproutlab/domain/models/entitlement_snapshot.dart';
import 'package:sproutlab/domain/monetization/entitlement_reconciler.dart';
import 'package:sproutlab/domain/monetization/offline_entitlement_policy.dart';
import 'package:sproutlab/domain/monetization/store_models.dart';

void main() {
  const reconciler = EntitlementReconciler();
  const productId = 'configured-in-test';
  const now = 1_000_000;

  StorePurchaseFact owned({
    bool acknowledged = true,
    bool? autoRenewing = true,
    StorePurchasePhase phase = StorePurchasePhase.purchased,
    EntitlementStatus? verifiedStatus,
    int? expiryMillis,
  }) {
    return StorePurchaseFact(
      productId: productId,
      purchaseKey: 'purchase-key',
      phase: phase,
      acknowledged: acknowledged,
      autoRenewing: autoRenewing,
      verifiedStatus: verifiedStatus,
      expiryMillis: expiryMillis,
    );
  }

  Reconciliation run(StorePurchaseQuery query, {EntitlementSnapshot? cached}) {
    return reconciler.reconcile(
      cached: cached ?? EntitlementSnapshot.inactive,
      query: query,
      productId: productId,
      nowMillis: now,
    );
  }

  test('a failed query keeps the cached grant', () {
    const cached = EntitlementSnapshot(
      status: EntitlementStatus.active,
      productId: productId,
      lastReconciledAtMillis: now,
    );
    final result = run(
      const StorePurchaseQuery(connection: StoreConnection.offline),
      cached: cached,
    );
    expect(result.changed, isFalse);
    expect(result.snapshot.status, EntitlementStatus.active);
    expect(result.outcome, BillingFlowOutcome.offline);
    expect(result.snapshot.premiumActiveAt(now), isTrue);
  });

  test('an empty store query ends a previous subscription', () {
    final result = run(
      const StorePurchaseQuery(connection: StoreConnection.ready),
      cached: const EntitlementSnapshot(
        status: EntitlementStatus.active,
        productId: productId,
        lastReconciledAtMillis: 1,
      ),
    );
    expect(result.snapshot.status, EntitlementStatus.expired);
    expect(result.snapshot.premiumActiveAt(now), isFalse);
    expect(result.outcome, BillingFlowOutcome.expired);
  });

  test(
    'pending payment and an unacknowledged purchase do not grant Premium',
    () {
      final pending = run(
        StorePurchaseQuery(
          connection: StoreConnection.ready,
          purchases: [owned(phase: StorePurchasePhase.pending)],
        ),
      );
      expect(pending.snapshot.status, EntitlementStatus.pending);
      expect(pending.snapshot.premiumActiveAt(now), isFalse);

      final unverified = run(
        StorePurchaseQuery(
          connection: StoreConnection.ready,
          purchases: [owned(acknowledged: false)],
        ),
      );
      expect(unverified.outcome, BillingFlowOutcome.unverified);
      expect(unverified.snapshot.premiumActiveAt(now), isFalse);
    },
  );

  test(
    'an acknowledged purchase is active without inventing grace or expiry',
    () {
      final result = run(
        StorePurchaseQuery(
          connection: StoreConnection.ready,
          purchases: [owned()],
        ),
      );
      expect(result.snapshot.status, EntitlementStatus.active);
      expect(result.snapshot.expiryMillis, isNull);
      expect(result.snapshot.premiumActiveAt(now), isTrue);
      final later = now + OfflineEntitlementPolicy.window.inMilliseconds + 1;
      expect(result.snapshot.premiumActiveAt(later), isFalse);
    },
  );

  test('auto-renew off stays cancelled until the offline bound', () {
    final result = run(
      StorePurchaseQuery(
        connection: StoreConnection.ready,
        purchases: [owned(autoRenewing: false)],
      ),
    );
    expect(result.snapshot.status, EntitlementStatus.cancelledButValid);
    expect(result.snapshot.premiumActiveAt(now), isTrue);
  });

  test(
    'a verifier can set grace, hold and expiry without the client guessing',
    () {
      final grace = run(
        StorePurchaseQuery(
          connection: StoreConnection.ready,
          purchases: [
            owned(
              verifiedStatus: EntitlementStatus.gracePeriod,
              expiryMillis: now + const Duration(days: 2).inMilliseconds,
            ),
          ],
        ),
      );
      expect(grace.snapshot.status, EntitlementStatus.gracePeriod);
      expect(grace.snapshot.premiumActiveAt(now), isTrue);

      final hold = run(
        StorePurchaseQuery(
          connection: StoreConnection.ready,
          purchases: [owned(verifiedStatus: EntitlementStatus.onHold)],
        ),
      );
      expect(hold.snapshot.status, EntitlementStatus.onHold);
      expect(hold.snapshot.premiumActiveAt(now), isFalse);
    },
  );

  test('duplicate purchase keys collapse to one decision', () {
    final result = run(
      StorePurchaseQuery(
        connection: StoreConnection.ready,
        purchases: [owned(acknowledged: false), owned()],
      ),
    );
    expect(result.snapshot.status, EntitlementStatus.active);
  });

  test('a null expiry never grants permanent Premium', () {
    const stale = EntitlementSnapshot(
      status: EntitlementStatus.active,
      productId: productId,
    );
    expect(stale.premiumActiveAt(now), isFalse);
    const remembered = EntitlementSnapshot(
      status: EntitlementStatus.active,
      productId: productId,
      expiryMillis: 5_000,
    );
    expect(remembered.premiumActiveAt(4_000), isTrue);
    expect(remembered.premiumActiveAt(5_000), isFalse);
  });
}
