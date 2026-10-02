import 'dart:async';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sproutlab/core/platform/store_billing_port.dart';
import 'package:sproutlab/data/billing/billing_coordinator.dart';
import 'package:sproutlab/data/local/database/app_database.dart';
import 'package:sproutlab/data/repositories/drift_entitlement_repository.dart';
import 'package:sproutlab/data/repositories/drift_profile_repository.dart';
import 'package:sproutlab/data/repositories/drift_progress_repository.dart';
import 'package:sproutlab/domain/models/age_band.dart';
import 'package:sproutlab/domain/models/entitlement_snapshot.dart';
import 'package:sproutlab/domain/models/game_category.dart';
import 'package:sproutlab/domain/monetization/entitlement_reconciler.dart';
import 'package:sproutlab/domain/monetization/store_models.dart';
import 'package:sproutlab/domain/monetization/subscription_verifier.dart';

const _productId = 'configured-in-test';

class _FakePort implements StoreBillingPort {
  StoreConnection connection = StoreConnection.ready;
  bool buyOpens = true;
  bool ackSucceeds = true;
  bool acked = false;
  int buys = 0;
  int acks = 0;
  int queries = 0;
  List<StorePurchaseFact> owned = const [];
  final StreamController<List<StorePurchaseFact>> _updates =
      StreamController<List<StorePurchaseFact>>.broadcast();

  @override
  Stream<List<StorePurchaseFact>> get purchaseUpdates => _updates.stream;

  @override
  Future<bool> acknowledge(String purchaseKey) async {
    acks += 1;
    if (!ackSucceeds) {
      return false;
    }
    acked = true;
    return true;
  }

  @override
  Future<bool> buy(StoreOffer offer) async {
    buys += 1;
    _updates.add(owned);
    return buyOpens;
  }

  var _closed = false;

  @override
  Future<void> dispose() async {
    if (_closed) {
      return;
    }
    _closed = true;
    await _updates.close();
  }

  @override
  Future<CatalogLoad> loadOffer({
    required String productId,
    String basePlanId = '',
    String offerId = '',
  }) async {
    return CatalogLoad(
      status: CatalogStatus.ready,
      message: 'The price and period below come from Google Play.',
      purchaseOffer: StoreOffer(
        productId: productId,
        title: 'Premium',
        description: 'From the store',
        formattedPrice: '€12.00',
        billingPeriod: 'P1Y',
        offerToken: 'offer-token',
      ),
    );
  }

  @override
  Future<bool> openManagement(String productId) async {
    return true;
  }

  @override
  Future<StorePurchaseQuery> queryPurchases(String productId) async {
    queries += 1;
    if (connection != StoreConnection.ready) {
      return StorePurchaseQuery(connection: connection);
    }
    return StorePurchaseQuery(
      connection: StoreConnection.ready,
      purchases: [
        for (final fact in owned)
          StorePurchaseFact(
            productId: fact.productId,
            purchaseKey: fact.purchaseKey,
            phase: fact.phase,
            acknowledged: fact.acknowledged || acked,
            autoRenewing: fact.autoRenewing,
            expiryMillis: fact.expiryMillis,
            verifiedStatus: fact.verifiedStatus,
          ),
      ],
    );
  }
}

StorePurchaseFact _owned({bool acknowledged = false}) {
  return StorePurchaseFact(
    productId: _productId,
    purchaseKey: 'purchase-key',
    phase: StorePurchasePhase.purchased,
    acknowledged: acknowledged,
    autoRenewing: true,
  );
}

Future<BillingCoordinator> _coordinator(
  AppDatabase database, {
  required _FakePort port,
  SubscriptionVerifier? verifier,
  bool parent = true,
  int clock = 1_000_000,
}) async {
  return BillingCoordinator(
    productId: _productId,
    port: port,
    repository: DriftEntitlementRepository(database),
    reconciler: const EntitlementReconciler(),
    verifier: verifier ?? const UnavailableSubscriptionVerifier(),
    parentAuthorized: () => parent,
    nowMillis: () => clock,
  );
}

void main() {
  test('purchase waits for a confirming query and acknowledgement', () async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final port = _FakePort()..owned = [_owned()];
    final gateway = await _coordinator(database, port: port);
    addTearDown(gateway.dispose);
    final result = await gateway.purchaseAnnual();
    await gateway.settled;
    expect(port.buys, 1);
    expect(port.acks, 1);
    expect(result.snapshot.status, EntitlementStatus.active);
    expect(result.snapshot.premiumActiveAt(1_000_000), isTrue);
    expect(result.message.contains('199'), isFalse);

    final again = await gateway.restore();
    expect(port.acks, 1);
    expect(again.outcome, BillingFlowOutcome.restored);
    expect(again.snapshot.status, EntitlementStatus.active);
  });

  test(
    'a purchase callback without a store query does not grant Premium',
    () async {
      final database = AppDatabase(NativeDatabase.memory());
      addTearDown(database.close);
      final port = _FakePort()..owned = const [];
      final gateway = await _coordinator(database, port: port);
      addTearDown(gateway.dispose);
      final result = await gateway.purchaseAnnual();
      expect(port.acks, 0);
      expect(result.snapshot.premiumActiveAt(1_000_000), isFalse);
      expect(result.outcome, BillingFlowOutcome.noPurchase);
    },
  );

  test('acknowledgement failure and verifier failure stay free', () async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final port = _FakePort()
      ..owned = [_owned()]
      ..ackSucceeds = false;
    final gateway = await _coordinator(database, port: port);
    addTearDown(gateway.dispose);
    final unacked = await gateway.purchaseAnnual();
    expect(unacked.snapshot.status, EntitlementStatus.pending);
    expect(unacked.snapshot.premiumActiveAt(1_000_000), isFalse);
    await gateway.settled;
    await gateway.dispose();

    final verifiedPort = _FakePort()..owned = [_owned()];
    final verified = await _coordinator(
      database,
      port: verifiedPort,
      verifier: _ThrowingVerifier(),
    );
    addTearDown(verified.dispose);
    final rejected = await verified.purchaseAnnual();
    expect(rejected.outcome, BillingFlowOutcome.unverified);
    expect(
      (await DriftEntitlementRepository(database).read()).status,
      isNot(EntitlementStatus.active),
    );
  });

  test('a parent hold is required before purchase or restore', () async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final port = _FakePort()..owned = [_owned()];
    final gateway = await _coordinator(database, port: port, parent: false);
    addTearDown(gateway.dispose);
    final purchase = await gateway.purchaseAnnual();
    final restore = await gateway.restore();
    final managed = await gateway.openSubscriptionManagement();
    expect(port.buys, 0);
    expect(port.queries, 0);
    expect(managed, isFalse);
    expect(purchase.snapshot.premiumActiveAt(1_000_000), isFalse);
    expect(restore.message, contains('grown-up'));
  });

  test(
    'offline refresh keeps the cache and an empty query expires it',
    () async {
      final database = AppDatabase(NativeDatabase.memory());
      addTearDown(database.close);
      final repository = DriftEntitlementRepository(database);
      await repository.save(
        const EntitlementSnapshot(
          status: EntitlementStatus.active,
          productId: _productId,
          lastReconciledAtMillis: 1_000_000,
        ),
      );
      final port = _FakePort()..connection = StoreConnection.offline;
      final gateway = await _coordinator(database, port: port);
      addTearDown(gateway.dispose);
      final cached = await gateway.refresh();
      expect(cached.status, EntitlementStatus.active);
      expect(cached.premiumActiveAt(1_000_000), isTrue);
      expect(
        cached.premiumActiveAt(
          1_000_000 + const Duration(days: 8).inMilliseconds,
        ),
        isFalse,
      );

      port.connection = StoreConnection.ready;
      port.owned = const [];
      final restored = await gateway.restore();
      expect(restored.snapshot.status, EntitlementStatus.expired);
      expect(restored.snapshot.premiumActiveAt(1_000_000), isFalse);
    },
  );

  test('expiry does not delete learning progress', () async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final profile = await DriftProfileRepository(database)
        .createProfile(avatarId: 'fox', ageBand: AgeBand.a);
    final progress = DriftProgressRepository(database);
    await progress.saveCompletion(
      profileId: profile.id,
      activityId: 'maths:v1:A:0',
      category: GameCategory.maths,
      hintsUsed: 0,
      firstAttemptCorrect: true,
      stars: 2,
      premiumActive: true,
      nowMillis: 10,
    );
    await DriftEntitlementRepository(database).save(
      const EntitlementSnapshot(
        status: EntitlementStatus.active,
        productId: _productId,
        lastReconciledAtMillis: 10,
      ),
    );
    final port = _FakePort()..owned = const [];
    final gateway = await _coordinator(database, port: port);
    addTearDown(gateway.dispose);
    await gateway.restore();
    final records = await progress.listForProfile(profile.id);
    expect(records, hasLength(1));
    expect(records.single.completions, 1);
    expect(records.single.bestStars, 2);
  });

  test('a verifier grace grant is stored and hold does not unlock', () async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final port = _FakePort()..owned = [_owned(acknowledged: true)];
    final gateway = await _coordinator(
      database,
      port: port,
      verifier: _FixedVerifier(
        const VerifiedSubscription(
          status: EntitlementStatus.gracePeriod,
          expiryMillis: 2_000_000,
        ),
      ),
    );
    addTearDown(gateway.dispose);
    final grace = await gateway.restore();
    expect(grace.snapshot.status, EntitlementStatus.gracePeriod);
    expect(grace.snapshot.premiumActiveAt(1_000_000), isTrue);
    expect(grace.snapshot.premiumActiveAt(2_000_000), isFalse);
    await gateway.dispose();

    final heldPort = _FakePort()..owned = [_owned(acknowledged: true)];
    final held = await _coordinator(
      database,
      port: heldPort,
      verifier: _FixedVerifier(
        const VerifiedSubscription(status: EntitlementStatus.onHold),
      ),
    );
    addTearDown(held.dispose);
    final result = await held.restore();
    expect(result.snapshot.status, EntitlementStatus.onHold);
    expect(result.snapshot.premiumActiveAt(1_000_000), isFalse);
  });
}

class _ThrowingVerifier implements SubscriptionVerifier {
  @override
  Future<VerifiedSubscription?> verify(StorePurchaseFact fact) async {
    throw StateError('verification service unavailable');
  }
}

class _FixedVerifier implements SubscriptionVerifier {
  _FixedVerifier(this.result);

  final VerifiedSubscription result;

  @override
  Future<VerifiedSubscription?> verify(StorePurchaseFact fact) async {
    return result;
  }
}
