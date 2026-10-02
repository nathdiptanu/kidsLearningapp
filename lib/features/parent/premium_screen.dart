import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/session_providers.dart';
import '../../core/design_system/sprout_theme.dart';
import '../../core/design_system/sprout_tokens.dart';
import '../../core/design_system/widgets/fox_mascot.dart';
import '../../core/design_system/widgets/sprout_card.dart';
import '../../core/design_system/widgets/status_chip.dart';
import '../../domain/models/entitlement_snapshot.dart';
import '../../domain/monetization/offline_entitlement_policy.dart';
import '../../domain/monetization/store_models.dart';
import 'parent_hold_gate.dart';

class PremiumScreen extends StatelessWidget {
  const PremiumScreen({this.revokeOnDispose = true, super.key});

  final bool revokeOnDispose;

  @override
  Widget build(BuildContext context) {
    return ParentHoldGate(
      revokeOnDispose: revokeOnDispose,
      title: 'More activities',
      child: const PremiumOffer(),
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({required this.title, required this.lines, this.note});

  final String title;
  final List<String> lines;
  final String? note;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return SproutCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: text.titleMedium),
          const SizedBox(height: SproutSpace.sm),
          for (final line in lines)
            Padding(
              padding: const EdgeInsets.only(bottom: SproutSpace.xs),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ExcludeSemantics(
                    child: Icon(
                      Icons.check_circle_rounded,
                      color: SproutColors.success,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: SproutSpace.sm),
                  Expanded(child: Text(line, style: text.bodyMedium)),
                ],
              ),
            ),
          if (note != null) ...[
            const SizedBox(height: SproutSpace.xs),
            Text(note!, style: text.bodySmall),
          ],
        ],
      ),
    );
  }
}

class PremiumOffer extends ConsumerStatefulWidget {
  const PremiumOffer({super.key});

  @override
  ConsumerState<PremiumOffer> createState() => _PremiumOfferState();
}

class _PremiumOfferState extends ConsumerState<PremiumOffer> {
  String? _notice;

  Future<void> _purchase() async {
    if (!ref.read(parentGateProvider)) {
      return;
    }
    final result = await ref.read(billingGatewayProvider).purchaseAnnual();
    ref.invalidate(entitlementProvider);
    if (mounted) {
      setState(() => _notice = result.message);
    }
  }

  Future<void> _restore() async {
    if (!ref.read(parentGateProvider)) {
      return;
    }
    final result = await ref.read(billingGatewayProvider).restore();
    ref.invalidate(entitlementProvider);
    if (mounted) {
      setState(() => _notice = result.message);
    }
  }

  Future<void> _manage() async {
    if (!ref.read(parentGateProvider)) {
      return;
    }
    final opened = await ref
        .read(billingGatewayProvider)
        .openSubscriptionManagement();
    if (mounted && !opened) {
      setState(() {
        _notice = 'Google Play subscription settings could not be opened.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final snapshot =
        ref.watch(entitlementProvider).value ?? EntitlementSnapshot.inactive;
    final premium = snapshot.premiumActiveAt(
      DateTime.now().millisecondsSinceEpoch,
    );
    final catalog = ref.watch(annualOfferProvider).value;
    final offer = catalog?.purchaseOffer;
    final canPurchase = catalog?.canPurchase ?? false;
    final canContactStore =
        catalog != null && catalog.status != CatalogStatus.notConfigured;
    final text = Theme.of(context).textTheme;
    return Theme(
      data: SproutTheme.parent(),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
          SproutSpace.page,
          SproutSpace.sm,
          SproutSpace.page,
          SproutSpace.xl,
        ),
        children: [
          SproutCard(
            color: SproutColors.primarySoft,
            accent: SproutColors.cardEdge,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'More learning. More practice. One simple plan.',
                        style: text.headlineSmall,
                      ),
                      const SizedBox(height: 12),
                      StatusChip(
                        label: premium ? 'Premium active' : 'Free plan',
                        tone: premium ? StatusTone.done : StatusTone.info,
                      ),
                    ],
                  ),
                ),
                const FoxMascot(size: 96),
              ],
            ),
          ),
          const SizedBox(height: SproutSpace.md),
          SproutCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Semantics(
                  liveRegion: true,
                  child: Text(
                    _status(snapshot, premium, catalog),
                    style: text.bodyLarge,
                  ),
                ),
                if (offer != null) ...[
                  const SizedBox(height: SproutSpace.md),
                  Text(offer.title, style: text.titleMedium),
                  Text(
                    offer.formattedPrice,
                    style: text.headlineMedium?.copyWith(
                      color: SproutColors.primary,
                    ),
                  ),
                  Text(
                    'Billed ${describeBillingPeriod(offer.billingPeriod)}.',
                    style: text.bodyMedium,
                  ),
                  if (offer.renewalFormattedPrice != null)
                    Text(
                      'Then ${offer.renewalFormattedPrice} ${describeBillingPeriod(offer.renewalBillingPeriod ?? offer.billingPeriod)}.',
                      style: text.bodyMedium,
                    ),
                  if (offer.offerId != null)
                    Text(
                      'Eligible offer from Google Play: ${offer.offerId}.',
                      style: text.bodyMedium,
                    ),
                  for (final extra
                      in catalog?.eligibleOffers ?? const <StoreOffer>[])
                    if (extra.offerToken != offer.offerToken)
                      Text(
                        'Also from Google Play: ${extra.formattedPrice} ${describeBillingPeriod(extra.billingPeriod)}.',
                        style: text.bodyMedium,
                      ),
                  const SizedBox(height: SproutSpace.sm),
                  Text(
                    'The subscription renews until it is cancelled in Google Play. The price and period come from Google Play.',
                    style: text.bodySmall,
                  ),
                ],
                if (offer == null) ...[
                  const SizedBox(height: SproutSpace.sm),
                  Text(
                    catalog?.message ?? CatalogLoad.notConfigured.message,
                    style: text.bodyMedium,
                  ),
                ],
                if (_notice != null) ...[
                  const SizedBox(height: SproutSpace.md),
                  Semantics(
                    liveRegion: true,
                    child: Text(_notice!, style: text.bodyLarge),
                  ),
                ],
                const SizedBox(height: SproutSpace.md),
                FilledButton(
                  onPressed: canPurchase && !premium ? _purchase : null,
                  child: Text(
                    canPurchase ? 'Subscribe' : 'Purchase unavailable',
                  ),
                ),
                const SizedBox(height: SproutSpace.sm),
                OutlinedButton(
                  onPressed: canContactStore ? _restore : null,
                  child: Text(
                    canContactStore
                        ? 'Restore purchases'
                        : 'Restore unavailable',
                  ),
                ),
                const SizedBox(height: SproutSpace.sm),
                TextButton(
                  onPressed: canContactStore ? _manage : null,
                  child: const Text('Manage subscription'),
                ),
              ],
            ),
          ),
          const SizedBox(height: SproutSpace.md),
          _PlanCard(
            title: 'Free on this device',
            lines: const [
              'Five new finished activities in each game stay open.',
              'Finished activities can be played again.',
              'Today\'s adventure keeps using those activities.',
            ],
          ),
          const SizedBox(height: SproutSpace.md),
          _PlanCard(
            title: 'Premium, when a store purchase is confirmed',
            lines: const [
              'New activities in maths, words, patterns, mazes, matching and spot-the-difference.',
              'Activities that follow the saved learning band.',
              'No ads.',
            ],
            note:
                'Hindi and Discover India samples do not use a separate purchase and do not use the five free activities of Maths or Words. A store product is not connected in this build.',
          ),
          const SizedBox(height: SproutSpace.md),
          Text(
            offer == null
                ? 'Purchase and restore stay off until Google Play returns a subscription. A privacy policy link is not opened from this build.'
                : 'An offline device keeps a confirmed subscription for ${OfflineEntitlementPolicy.window.inDays} days when Google Play does not send an expiry time. Saved learning stays either way.',
            style: text.bodySmall,
          ),
        ],
      ),
    );
  }

  String _status(
    EntitlementSnapshot snapshot,
    bool premium,
    CatalogLoad? catalog,
  ) {
    if (snapshot.status == EntitlementStatus.pending) {
      return 'A payment or confirmation is still pending. Premium stays off.';
    }
    if (premium && snapshot.status == EntitlementStatus.cancelledButValid) {
      return 'Premium stays on until this cancelled subscription ends.';
    }
    if (premium && snapshot.status == EntitlementStatus.gracePeriod) {
      return 'Premium is active while a grace period is confirmed.';
    }
    if (premium) {
      return 'Premium is active on this device.';
    }
    if (snapshot.status == EntitlementStatus.expired) {
      return 'Premium is not active. Saved learning stays on this device.';
    }
    if (catalog == null || catalog.status == CatalogStatus.notConfigured) {
      return 'Premium is not active. Store purchases are not connected in this build.';
    }
    return 'Premium is not active.';
  }
}
