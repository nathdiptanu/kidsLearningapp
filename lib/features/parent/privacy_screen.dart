import 'package:flutter/material.dart';

import '../../app/app_identity.dart';
import '../../core/design_system/sprout_tokens.dart';
import '../../core/design_system/widgets/brand_mark.dart';
import '../../core/design_system/widgets/sprout_card.dart';
import 'parent_hold_gate.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ParentHoldGate(
      revokeOnDispose: false,
      title: 'About and privacy',
      child: PrivacyBody(),
    );
  }
}

class PrivacyBody extends StatelessWidget {
  const PrivacyBody({super.key});

  static const supportEmail = 'ask.artha.support@gmail.com';

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        SproutSpace.page,
        SproutSpace.sm,
        SproutSpace.page,
        SproutSpace.xl,
      ),
      children: [
        SproutCard(
          child: Row(
            children: [
              const BrandMark(size: 72),
              const SizedBox(width: SproutSpace.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppIdentity.visibleName, style: text.headlineSmall),
                    Text(
                      'Version ${AppIdentity.appVersion}',
                      style: text.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const _Section(
          icon: Icons.phone_android_rounded,
          title: 'What stays on this device',
          body:
              'Learning, rewards, sound choices, an optional nickname, an avatar, and an age band are stored in a private database on this device. There is no child account and no sign-in. The nickname is optional and is not sent by this app.',
        ),
        const _Section(
          icon: Icons.wifi_off_rounded,
          title: 'What can leave this device',
          body:
              'Everyday learning does not need a network. This build does not include ads, analytics, or a crash-reporting service. Store purchases are not connected, so this build does not contact Google Play Billing. If a subscription is added later, a grown-up purchase, restore, or subscription-settings action talks to Google Play. That request does not include the nickname or learning history.',
        ),
        const _Section(
          icon: Icons.block_rounded,
          title: 'What the app does not ask for',
          body:
              'The app does not ask for location, contacts, SMS, camera, microphone, or an advertising identifier. This version does not send notifications. Android backup and device transfer of the app database are turned off.',
        ),
        const _Section(
          icon: Icons.schedule_rounded,
          title: 'How long it is kept',
          body:
              'Progress stays until the app is uninstalled or the device storage is cleared. A subscription status cache, when one exists, stores the status and check time only. It does not store a purchase token or a price.',
        ),
        const _Section(
          icon: Icons.help_outline_rounded,
          title: 'Help',
          body:
              'The grown-up area opens after a 3-second hold. Each game has five free new levels; finished levels can always be played again. To remove all saved progress, uninstall the app or clear its storage in Android settings.',
        ),
        Padding(
          padding: const EdgeInsets.only(top: SproutSpace.md),
          child: SproutCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Contact', style: text.titleMedium),
                const SizedBox(height: SproutSpace.xs),
                Text(
                  'Questions about SproutLab or this privacy notice:',
                  style: text.bodyMedium,
                ),
                const SizedBox(height: SproutSpace.xs),
                SelectableText(
                  supportEmail,
                  style: text.bodyLarge?.copyWith(color: SproutColors.primary),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.icon, required this.title, required this.body});

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(top: SproutSpace.md),
      child: SproutCard(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ExcludeSemantics(
              child: Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: SproutColors.primarySoft,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: SproutColors.primary, size: 24),
              ),
            ),
            const SizedBox(width: SproutSpace.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Semantics(
                    header: true,
                    child: Text(title, style: text.titleMedium),
                  ),
                  const SizedBox(height: SproutSpace.xs),
                  Text(body, style: text.bodyMedium),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
