import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../core/audio/asset_audio_controller.dart';
import '../core/audio/audio_controller.dart';
import '../core/audio/plugin_audio_playback.dart';
import '../core/platform/billing_gateway.dart';
import '../core/platform/learning_reminder_port.dart';
import '../core/platform/unavailable_billing_gateway.dart';
import '../data/billing/billing_coordinator.dart';
import '../data/billing/play_store_billing_port.dart';
import '../data/repositories/drift_entitlement_repository.dart';
import '../data/repositories/drift_journey_repository.dart';
import '../data/repositories/drift_profile_repository.dart';
import '../data/repositories/drift_reward_repository.dart';
import '../data/repositories/drift_progress_repository.dart';
import '../data/repositories/drift_settings_repository.dart';
import '../domain/models/age_band.dart';
import '../domain/models/child_profile.dart';
import '../domain/models/entitlement_snapshot.dart';
import '../domain/monetization/billing_product_config.dart';
import '../domain/monetization/entitlement_reconciler.dart';
import '../domain/monetization/store_models.dart';
import '../domain/monetization/subscription_verifier.dart';
import '../domain/progress/activity_record.dart';
import '../domain/rewards/reward_shelf.dart';
import '../domain/repositories/profile_repository.dart';
import '../domain/repositories/settings_repository.dart';
import '../domain/settings/local_settings.dart';
import 'bootstrap_state.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return DriftSettingsRepository(ref.watch(databaseProvider));
});

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return DriftProfileRepository(ref.watch(databaseProvider));
});

final progressRepositoryProvider = Provider<DriftProgressRepository>((ref) {
  return DriftProgressRepository(ref.watch(databaseProvider));
});

class AppSession {
  const AppSession({required this.settings, required this.profile});

  final LocalSettings settings;
  final ChildProfile? profile;

  bool get readyForPlay => settings.onboardingComplete && profile != null;
}

class SessionController extends AsyncNotifier<AppSession> {
  @override
  Future<AppSession> build() async {
    final settings = await ref.watch(settingsRepositoryProvider).load();
    final profile = await ref
        .watch(profileRepositoryProvider)
        .getActiveProfile();
    return AppSession(settings: settings, profile: profile);
  }

  Future<void> saveSettings(LocalSettings settings) async {
    await ref.read(settingsRepositoryProvider).save(settings);
    final current = state.value;
    if (current != null) {
      state = AsyncData(
        AppSession(settings: settings, profile: current.profile),
      );
    }
  }

  Future<void> finishOnboarding({
    required String avatarId,
    required AgeBand ageBand,
    required String? nickname,
    required LocalSettings settings,
  }) async {
    final profiles = ref.read(profileRepositoryProvider);
    var profile = await profiles.getActiveProfile();
    profile ??= await profiles.createProfile(
      avatarId: avatarId,
      ageBand: ageBand,
      nickname: nickname,
    );
    final done = settings.copyWith(onboardingComplete: true, onboardingStep: 5);
    await ref.read(settingsRepositoryProvider).save(done);
    state = AsyncData(AppSession(settings: done, profile: profile));
  }
}

final sessionProvider = AsyncNotifierProvider<SessionController, AppSession>(
  SessionController.new,
);

final progressListProvider = FutureProvider<List<ActivityRecord>>((ref) async {
  final session = await ref.watch(sessionProvider.future);
  final profile = session.profile;
  if (profile == null) {
    return const [];
  }
  return ref.watch(progressRepositoryProvider).listForProfile(profile.id);
});

final journeyRepositoryProvider = Provider<DriftJourneyRepository>((ref) {
  return DriftJourneyRepository(ref.watch(databaseProvider));
});

final dailyJourneyProvider = FutureProvider((ref) async {
  final session = await ref.watch(sessionProvider.future);
  final profile = session.profile;
  if (profile == null) {
    throw StateError('A profile is required before today\'s adventure.');
  }
  final records = await ref.watch(progressListProvider.future);
  return ref
      .watch(journeyRepositoryProvider)
      .ensure(
        profile: profile,
        records: records,
        now: DateTime.now(),
        premiumActive: ref.watch(premiumActiveProvider),
      );
});

final rewardRepositoryProvider = Provider<DriftRewardRepository>((ref) {
  return DriftRewardRepository(ref.watch(databaseProvider));
});

final freshRewardIdsProvider = NotifierProvider<FreshRewardIds, List<String>>(
  FreshRewardIds.new,
);

class FreshRewardIds extends Notifier<List<String>> {
  @override
  List<String> build() => const [];

  void replace(List<String> ids) {
    state = ids;
  }
}

final rewardShelfProvider = FutureProvider<RewardShelf>((ref) async {
  final session = await ref.watch(sessionProvider.future);
  final profile = session.profile;
  if (profile == null) {
    return RewardShelf.empty;
  }
  final rewards = ref.watch(rewardRepositoryProvider);
  await rewards.reconcile(profile.id);
  final snapshot = await rewards.snapshot(profile.id);
  final rows = await rewards.listRewards(profile.id);
  return RewardShelf(
    snapshot: snapshot,
    unlockedAt: {for (final row in rows) row.rewardId: row.unlockedAt},
  );
});

final parentReportProvider = FutureProvider((ref) async {
  final session = await ref.watch(sessionProvider.future);
  final profile = session.profile;
  if (profile == null) {
    throw StateError('A profile is required before the learning summary.');
  }
  return ref
      .watch(rewardRepositoryProvider)
      .parentReport(profile.id, DateTime.now());
});

final entitlementRepositoryProvider = Provider<DriftEntitlementRepository>((
  ref,
) {
  return DriftEntitlementRepository(ref.watch(databaseProvider));
});

final reminderPortProvider = Provider<LearningReminderPort>((ref) {
  return const NoopLearningReminderPort();
});

final billingGatewayProvider = Provider<BillingGateway>((ref) {
  final repository = ref.watch(entitlementRepositoryProvider);
  final configured = BillingProductConfig.isConfigured;
  if (!configured || !Platform.isAndroid) {
    return InactiveBillingGateway(
      readCache: repository.read,
      configured: configured,
    );
  }
  final gateway = BillingCoordinator(
    productId: BillingProductConfig.annualSubscriptionId,
    basePlanId: BillingProductConfig.basePlanId,
    offerId: BillingProductConfig.offerId,
    port: PlayStoreBillingPort(InAppPurchase.instance),
    repository: repository,
    reconciler: const EntitlementReconciler(),
    verifier: const UnavailableSubscriptionVerifier(),
    parentAuthorized: () => ref.read(parentGateProvider),
    nowMillis: () => DateTime.now().millisecondsSinceEpoch,
  );
  ref.onDispose(gateway.dispose);
  return gateway;
});

final annualOfferProvider = FutureProvider<CatalogLoad>((ref) {
  return ref.watch(billingGatewayProvider).loadAnnualOffer();
});

final parentGateProvider = NotifierProvider<ParentGateSession, bool>(
  ParentGateSession.new,
);

final audioControllerProvider = Provider<AudioController>((ref) {
  final controller = AssetAudioController(PluginAudioPlayback());
  ref.onDispose(controller.dispose);
  void apply(LocalSettings? settings) {
    if (settings == null) {
      return;
    }
    controller.applySettings(
      effectsEnabled: settings.soundEffectsEnabled,
      musicEnabled: settings.musicEnabled,
      narrationEnabled: settings.narrationEnabled,
    );
  }

  apply(ref.read(sessionProvider).value?.settings);
  ref.listen(sessionProvider, (_, next) => apply(next.value?.settings));
  return controller;
});

final entitlementProvider = FutureProvider<EntitlementSnapshot>((ref) async {
  return ref.watch(entitlementRepositoryProvider).read();
});

final premiumActiveProvider = Provider<bool>((ref) {
  final snapshot =
      ref.watch(entitlementProvider).value ?? EntitlementSnapshot.inactive;
  return snapshot.premiumActiveAt(DateTime.now().millisecondsSinceEpoch);
});

final startedActivityIdsProvider = FutureProvider<Set<String>>((ref) async {
  final session = await ref.watch(sessionProvider.future);
  final profile = session.profile;
  if (profile == null) {
    return const {};
  }
  return ref
      .watch(progressRepositoryProvider)
      .checkpointActivityIds(profile.id);
});

class ParentGateSession extends Notifier<bool> {
  @override
  bool build() => false;

  void grant() => state = true;

  void revoke() => state = false;
}
