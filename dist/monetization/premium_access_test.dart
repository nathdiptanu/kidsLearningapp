import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sproutlab/app/bootstrap_state.dart';
import 'package:sproutlab/app/session_providers.dart';
import 'package:sproutlab/core/platform/billing_gateway.dart';
import 'package:sproutlab/data/local/database/app_database.dart';
import 'package:sproutlab/data/repositories/drift_entitlement_repository.dart';
import 'package:sproutlab/data/repositories/drift_profile_repository.dart';
import 'package:sproutlab/data/repositories/drift_progress_repository.dart';
import 'package:sproutlab/domain/adaptive/daily_journey_planner.dart';
import 'package:sproutlab/domain/games/play/activity_catalog.dart';
import 'package:sproutlab/domain/models/age_band.dart';
import 'package:sproutlab/domain/models/entitlement_snapshot.dart';
import 'package:sproutlab/domain/models/game_category.dart';
import 'package:sproutlab/domain/monetization/store_models.dart';
import 'package:sproutlab/domain/monetization/free_entitlement_policy.dart';
import 'package:sproutlab/domain/progress/activity_record.dart';
import 'package:sproutlab/features/parent/premium_screen.dart';
import 'package:sproutlab/features/play/activity_access.dart';

class _PricedGateway extends _CountingGateway {
  @override
  Future<CatalogLoad> loadAnnualOffer() async {
    return const CatalogLoad(
      status: CatalogStatus.ready,
      message: 'The price and period below come from Google Play.',
      purchaseOffer: StoreOffer(
        productId: 'configured-in-test',
        title: 'Premium',
        description: 'From the store',
        formattedPrice: '€12.00',
        billingPeriod: 'P1Y',
        offerToken: 'offer-token',
      ),
    );
  }

  @override
  Future<BillingFlowResult> purchaseAnnual() async {
    purchases += 1;
    return const BillingFlowResult(
      snapshot: EntitlementSnapshot.inactive,
      outcome: BillingFlowOutcome.canceled,
      message: 'The purchase was cancelled. Premium stays off.',
    );
  }
}

class _CountingGateway implements BillingGateway {
  int purchases = 0;
  int restores = 0;
  int manages = 0;

  @override
  Future<CatalogLoad> loadAnnualOffer() async {
    return CatalogLoad.notConfigured;
  }

  @override
  Future<bool> openSubscriptionManagement() async {
    manages += 1;
    return false;
  }

  @override
  Future<BillingFlowResult> purchaseAnnual() async {
    purchases += 1;
    return BillingFlowResult(
      snapshot: EntitlementSnapshot.inactive,
      outcome: BillingFlowOutcome.notConfigured,
      message: CatalogLoad.notConfigured.message,
    );
  }

  @override
  Future<EntitlementSnapshot> refresh() async {
    return EntitlementSnapshot.inactive;
  }

  @override
  Future<BillingFlowResult> restore() async {
    restores += 1;
    return BillingFlowResult(
      snapshot: EntitlementSnapshot.inactive,
      outcome: BillingFlowOutcome.notConfigured,
      message: CatalogLoad.notConfigured.message,
    );
  }
}

void main() {
  const catalog = ActivityCatalog();
  const planner = DailyJourneyPlanner();

  ActivityRecord finished(String id, String engine, {int playedAt = 1}) {
    return ActivityRecord(
      activityId: id,
      engineType: engine,
      attempts: 1,
      completions: 1,
      bestStars: 2,
      hintsUsed: 0,
      lastPlayedAt: playedAt,
      countedAsFree: true,
    );
  }

  test('a new level stays locked after five, including another band', () {
    final records = [
      for (var variant = 0; variant < 5; variant++)
        finished('maths:v1:A:$variant', 'maths', playedAt: variant + 1),
    ];
    final next = catalog.forBand(GameCategory.maths, AgeBand.a)[5];
    final otherBand = catalog.forBand(GameCategory.maths, AgeBand.d).first;
    expect(
      accessFor(activity: next, records: records, premiumActive: false).access,
      LevelAccess.locked,
    );
    expect(
      accessFor(
        activity: otherBand,
        records: records,
        premiumActive: false,
      ).access,
      LevelAccess.locked,
    );
    expect(
      accessFor(
        activity: catalog.forBand(GameCategory.maths, AgeBand.a).first,
        records: records,
        premiumActive: false,
      ).access,
      LevelAccess.replay,
    );
    expect(
      accessFor(
        activity: next,
        records: records,
        premiumActive: false,
        startedActivityIds: {next.id},
      ).access,
      LevelAccess.continueInProgress,
    );
    expect(
      accessFor(activity: next, records: records, premiumActive: true).access,
      LevelAccess.playNew,
    );
  });

  test('an exhausted library still plans five replayable activities', () {
    final records = <ActivityRecord>[];
    for (final category in GameCategory.values) {
      final levels = catalog.forBand(category, AgeBand.a);
      for (var variant = 0; variant < 5; variant++) {
        records.add(
          finished(
            levels[variant].id,
            category.storageKey,
            playedAt: records.length + 1,
          ),
        );
      }
    }
    final plan = planner.plan(
      dateKey: '2026-09-30',
      band: AgeBand.a,
      records: records,
      difficultyBySkill: const {},
    );
    expect(plan, hasLength(5));
    for (final slot in plan) {
      expect(
        accessFor(
          activity: slot.activity,
          records: records,
          premiumActive: false,
        ).access,
        LevelAccess.replay,
      );
    }
  });

  test('premium completion does not use another free level', () async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final profile = await DriftProfileRepository(database)
        .createProfile(avatarId: 'fox', ageBand: AgeBand.a);
    final progress = DriftProgressRepository(database);
    for (var variant = 0; variant < 5; variant++) {
      await progress.saveCompletion(
        profileId: profile.id,
        activityId: 'maths:v1:A:$variant',
        category: GameCategory.maths,
        hintsUsed: 0,
        firstAttemptCorrect: true,
        stars: 2,
        premiumActive: false,
        nowMillis: variant + 1,
      );
    }
    final premium = await progress.saveCompletion(
      profileId: profile.id,
      activityId: 'maths:v1:A:5',
      category: GameCategory.maths,
      hintsUsed: 0,
      firstAttemptCorrect: true,
      stars: 3,
      premiumActive: true,
      nowMillis: 20,
    );
    expect(premium.countedAsFree, isFalse);
    expect(
      await progress.uniqueFreeCompleted(profile.id, GameCategory.maths),
      5,
    );
    await progress.saveCompletion(
      profileId: profile.id,
      activityId: 'maths:v1:A:0',
      category: GameCategory.maths,
      hintsUsed: 0,
      firstAttemptCorrect: true,
      stars: 3,
      premiumActive: false,
      nowMillis: 30,
    );
    expect(
      await progress.uniqueFreeCompleted(profile.id, GameCategory.maths),
      5,
    );
    await DriftEntitlementRepository(database).save(
      EntitlementSnapshot(
        status: EntitlementStatus.active,
        expiryMillis: DateTime(2027).millisecondsSinceEpoch,
        lastReconciledAtMillis: 1,
      ),
    );
    final stored = await DriftEntitlementRepository(database).read();
    expect(
      stored.premiumActiveAt(DateTime(2026, 9, 30).millisecondsSinceEpoch),
      isTrue,
    );
    expect(
      stored.premiumActiveAt(DateTime(2028).millisecondsSinceEpoch),
      isFalse,
    );
  });

  test('unknown, hold and pending snapshots do not unlock', () {
    final now = DateTime(2026, 9, 30).millisecondsSinceEpoch;
    const locked = [
      EntitlementStatus.unknown,
      EntitlementStatus.inactive,
      EntitlementStatus.pending,
      EntitlementStatus.onHold,
      EntitlementStatus.paused,
      EntitlementStatus.expired,
    ];
    for (final status in locked) {
      expect(
        EntitlementSnapshot(
          status: status,
          expiryMillis: DateTime(2027).millisecondsSinceEpoch,
        ).premiumActiveAt(now),
        isFalse,
      );
    }
  });

  testWidgets(
    'an injected premium grant is visible and still cannot purchase',
    (tester) async {
      final gateway = _CountingGateway();
      final database = AppDatabase(NativeDatabase.memory());
      addTearDown(database.close);
      await DriftProfileRepository(database)
          .createProfile(avatarId: 'fox', ageBand: AgeBand.a);
      await DriftEntitlementRepository(database).save(
        EntitlementSnapshot(
          status: EntitlementStatus.active,
          expiryMillis: DateTime(2027).millisecondsSinceEpoch,
          lastReconciledAtMillis: 1,
        ),
      );
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            bootstrapStateProvider.overrideWithValue(const BootstrapReady()),
            databaseProvider.overrideWith((ref) => database),
            billingGatewayProvider.overrideWithValue(gateway),
          ],
          child: const MaterialApp(home: PremiumScreen()),
        ),
      );
      final held = await tester.startGesture(
        tester.getCenter(find.text('Hold')),
      );
      await tester.pump(const Duration(seconds: 4));
      await held.up();
      await tester.pumpAndSettle();
      expect(find.text('Premium is active on this device.'), findsOneWidget);
      expect(find.textContaining('199'), findsNothing);
      final purchase = tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, 'Purchase unavailable'),
      );
      expect(purchase.onPressed, isNull);
      await tester.tap(find.text('Purchase unavailable'));
      await tester.pump();
      expect(gateway.purchases, 0);
      expect(gateway.restores, 0);
    },
  );

  testWidgets('locked content asks a grown-up and does not purchase', (
    tester,
  ) async {
    final gateway = _CountingGateway();
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          bootstrapStateProvider.overrideWithValue(const BootstrapReady()),
          databaseProvider.overrideWith((ref) => database),
          billingGatewayProvider.overrideWithValue(gateway),
        ],
        child: const MaterialApp(home: LockedActivityScreen()),
      ),
    );
    expect(find.textContaining('199'), findsNothing);
    expect(find.textContaining('₹'), findsNothing);
    await tester.tap(find.text('Ask a grown-up'));
    await tester.pumpAndSettle();
    expect(find.text('Parents: press and hold for 3 seconds.'), findsOneWidget);
    expect(find.text('Purchase unavailable'), findsNothing);
    expect(gateway.purchases, 0);
    expect(gateway.restores, 0);
  });

  testWidgets('premium stays behind the hold and purchase stays off', (
    tester,
  ) async {
    final gateway = _CountingGateway();
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    await DriftProfileRepository(database)
        .createProfile(avatarId: 'fox', ageBand: AgeBand.a);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          bootstrapStateProvider.overrideWithValue(const BootstrapReady()),
          databaseProvider.overrideWith((ref) => database),
          billingGatewayProvider.overrideWithValue(gateway),
        ],
        child: const MaterialApp(home: PremiumScreen()),
      ),
    );
    expect(find.text('Purchase unavailable'), findsNothing);
    final gesture = await tester.startGesture(
      tester.getCenter(find.text('Hold')),
    );
    await tester.pump(const Duration(milliseconds: 400));
    await gesture.up();
    await tester.pump();
    expect(find.text('Hold a little longer.'), findsOneWidget);
    final held = await tester.startGesture(tester.getCenter(find.text('Hold')));
    await tester.pump(const Duration(seconds: 4));
    await held.up();
    await tester.pumpAndSettle();
    expect(find.text('Purchase unavailable'), findsOneWidget);
    expect(find.text('Restore unavailable'), findsOneWidget);
    expect(
      find.textContaining('Store purchases are not connected'),
      findsWidgets,
    );
    expect(find.textContaining('199'), findsNothing);
    final purchase = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Purchase unavailable'),
    );
    expect(purchase.onPressed, isNull);
    await tester.tap(find.text('Purchase unavailable'));
    await tester.pump();
    expect(gateway.purchases, 0);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pump();
    expect(find.text('Parents: press and hold for 3 seconds.'), findsOneWidget);
    expect(find.text('Purchase unavailable'), findsNothing);
  });

  testWidgets(
    'a store price is shown only after a grown-up asks to subscribe',
    (tester) async {
      final gateway = _PricedGateway();
      final database = AppDatabase(NativeDatabase.memory());
      addTearDown(database.close);
      await DriftProfileRepository(database)
          .createProfile(avatarId: 'fox', ageBand: AgeBand.a);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            bootstrapStateProvider.overrideWithValue(const BootstrapReady()),
            databaseProvider.overrideWith((ref) => database),
            billingGatewayProvider.overrideWithValue(gateway),
          ],
          child: const MaterialApp(home: PremiumScreen()),
        ),
      );
      expect(find.text('€12.00'), findsNothing);
      expect(gateway.purchases, 0);
      final held = await tester.startGesture(
        tester.getCenter(find.text('Hold')),
      );
      await tester.pump(const Duration(seconds: 4));
      await held.up();
      await tester.pumpAndSettle();
      expect(find.text('€12.00'), findsOneWidget);
      expect(find.text('Billed every year.'), findsOneWidget);
      expect(find.textContaining('199'), findsNothing);
      expect(gateway.purchases, 0);
      await tester.tap(find.text('Subscribe'));
      await tester.pumpAndSettle();
      expect(gateway.purchases, 1);
      expect(
        find.text('The purchase was cancelled. Premium stays off.'),
        findsOneWidget,
      );
      expect(find.text('Premium is active on this device.'), findsNothing);
    },
  );
}
