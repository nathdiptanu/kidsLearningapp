import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/session_providers.dart';
import '../../core/design_system/avatars/avatar_badge.dart';
import '../../core/design_system/sprout_tokens.dart';
import '../../core/design_system/widgets/primary_kid_button.dart';
import '../../core/design_system/widgets/sprout_card.dart';
import '../../core/design_system/widgets/status_chip.dart';
import '../../domain/models/age_band.dart';
import 'parent_dashboard_screen.dart';
import 'parent_hold_gate.dart';
import 'premium_screen.dart';
import 'privacy_screen.dart';

class GrownUpSettingsScreen extends StatelessWidget {
  const GrownUpSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ParentHoldGate(child: _SettingsForm());
  }
}

class _SettingsForm extends ConsumerStatefulWidget {
  const _SettingsForm();

  @override
  ConsumerState<_SettingsForm> createState() => _SettingsFormState();
}

class _SettingsFormState extends ConsumerState<_SettingsForm> {
  late AgeBand _band;
  late String _avatarId;
  late bool _effects;
  late bool _music;
  late bool _narration;
  late bool _reducedMotion;
  late int _sessionLimit;
  late final TextEditingController _nickname;
  var _ready = false;
  var _saving = false;

  @override
  void initState() {
    super.initState();
    final session = ref.read(sessionProvider).value;
    final profile = session?.profile;
    _band = profile?.ageBand ?? AgeBand.a;
    _avatarId = profile?.avatarId ?? avatarIds.first;
    _nickname = TextEditingController(text: profile?.nickname ?? '');
    _effects = session?.settings.soundEffectsEnabled ?? true;
    _music = session?.settings.musicEnabled ?? false;
    _narration = session?.settings.narrationEnabled ?? true;
    _reducedMotion = session?.settings.reducedMotion ?? false;
    _sessionLimit = session?.settings.sessionLimitMinutes ?? 0;
    _ready = profile != null;
  }

  @override
  void dispose() {
    _nickname.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_saving) {
      return;
    }
    setState(() => _saving = true);
    final profiles = ref.read(profileRepositoryProvider);
    await profiles.updateActiveProfile(
      avatarId: _avatarId,
      ageBand: _band,
      nickname: _nickname.text,
    );
    final settings = ref.read(sessionProvider).value?.settings;
    if (settings != null) {
      await ref
          .read(sessionProvider.notifier)
          .saveSettings(
            settings.copyWith(
              soundEffectsEnabled: _effects,
              musicEnabled: _music,
              narrationEnabled: _narration,
              reducedMotion: _reducedMotion,
              sessionLimitMinutes: _sessionLimit,
            ),
          );
    }
    ref.invalidate(sessionProvider);
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  void _push(Widget screen) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (context) => screen));
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) {
      return const SizedBox.shrink();
    }
    final text = Theme.of(context).textTheme;
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        SproutSpace.page,
        SproutSpace.sm,
        SproutSpace.page,
        SproutSpace.xl,
      ),
      children: [
        _NavRow(
          icon: Icons.insights_rounded,
          title: 'Learning summary',
          subtitle: 'What was practised on this device',
          onTap: () =>
              _push(const ParentDashboardScreen(revokeOnDispose: false)),
        ),
        const SizedBox(height: 12),
        _NavRow(
          icon: Icons.auto_awesome_rounded,
          title: 'More activities',
          subtitle: 'Premium status, restore and the free plan',
          onTap: () => _push(const PremiumScreen(revokeOnDispose: false)),
        ),
        const SizedBox(height: 12),
        _NavRow(
          icon: Icons.shield_outlined,
          title: 'About and privacy',
          subtitle: 'What stays on this device',
          onTap: () => _push(const PrivacyScreen()),
        ),
        _Group(
          title: 'Child',
          children: [
            Text('Avatar', style: text.titleSmall),
            const SizedBox(height: SproutSpace.sm),
            Wrap(
              spacing: SproutSpace.sm,
              runSpacing: SproutSpace.sm,
              children: [
                for (final id in avatarIds)
                  _AvatarChoice(
                    id: id,
                    selected: _avatarId == id,
                    onTap: () => setState(() => _avatarId = id),
                  ),
              ],
            ),
            const SizedBox(height: SproutSpace.md),
            TextField(
              controller: _nickname,
              maxLength: 24,
              decoration: const InputDecoration(
                labelText: 'Nickname (optional)',
              ),
            ),
            const SizedBox(height: SproutSpace.sm),
            Text('Learning band', style: text.titleSmall),
            const SizedBox(height: SproutSpace.sm),
            Wrap(
              spacing: SproutSpace.sm,
              runSpacing: SproutSpace.sm,
              children: [
                for (final band in AgeBand.values)
                  ChoiceChip(
                    label: Text('Ages ${band.label}'),
                    selected: _band == band,
                    showCheckmark: true,
                    labelStyle: text.labelLarge,
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    onSelected: (_) => setState(() => _band = band),
                  ),
              ],
            ),
            const SizedBox(height: SproutSpace.sm),
            Text(
              'Changing the band keeps finished activities.',
              style: text.bodySmall,
            ),
          ],
        ),
        _Group(
          title: 'Sound and comfort',
          children: [
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Sound effects'),
              subtitle: const Text(
                'Correct, retry, finish, and reward sounds.',
              ),
              value: _effects,
              onChanged: (value) => setState(() => _effects = value),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Background music'),
              subtitle: const Text(
                'Quiet music. It stays off until you turn it on.',
              ),
              value: _music,
              onChanged: (value) => setState(() => _music = value),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Reduced motion'),
              subtitle: const Text('Turns off short animations in the app.'),
              value: _reducedMotion,
              onChanged: (value) => setState(() => _reducedMotion = value),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Spoken instructions'),
              subtitle: const Text(
                'Saved for later. This build has no spoken clips, so pictures and words stay on screen.',
              ),
              value: _narration,
              onChanged: (value) => setState(() => _narration = value),
            ),
            const ListTile(
              contentPadding: EdgeInsets.zero,
              enabled: false,
              title: Text('Daily reminder'),
              subtitle: Text(
                'Not available in this version. The app does not send notifications.',
              ),
              trailing: StatusChip(label: 'Not available'),
            ),
          ],
        ),
        _Group(
          title: 'Gentle stop',
          children: [
            Text(
              _sessionLimit == 0
                  ? 'Off. This does not control other apps or device screen time.'
                  : 'After $_sessionLimit minutes in SproutLab, suggest a break. An activity is not interrupted.',
              style: text.bodyMedium,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: SproutSpace.sm,
              runSpacing: SproutSpace.sm,
              children: [
                for (final minutes in const [0, 10, 15, 20])
                  ChoiceChip(
                    label: Text(minutes == 0 ? 'Off' : '$minutes min'),
                    selected: _sessionLimit == minutes,
                    labelStyle: text.labelLarge,
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    onSelected: (_) => setState(() => _sessionLimit = minutes),
                  ),
              ],
            ),
          ],
        ),
        const SizedBox(height: SproutSpace.lg),
        PrimaryKidButton(label: 'Save', onPressed: _saving ? null : _save),
      ],
    );
  }
}

class _Group extends StatelessWidget {
  const _Group({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: SproutSpace.lg),
      child: SproutCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Semantics(
              header: true,
              child: Text(title, style: Theme.of(context).textTheme.titleLarge),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _NavRow extends StatelessWidget {
  const _NavRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Semantics(
      button: true,
      label: '$title. $subtitle',
      onTap: onTap,
      excludeSemantics: true,
      child: TappableCard(
        onTap: onTap,
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: SproutColors.primarySoft,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: SproutColors.primary),
            ),
            const SizedBox(width: SproutSpace.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: text.titleMedium),
                  Text(subtitle, style: text.bodySmall),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: SproutColors.primary),
          ],
        ),
      ),
    );
  }
}

class _AvatarChoice extends StatelessWidget {
  const _AvatarChoice({
    required this.id,
    required this.selected,
    required this.onTap,
  });

  final String id;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: avatarName(id),
      onTap: onTap,
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: SproutSize.childTarget + 8,
          height: SproutSize.childTarget + 8,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: selected ? SproutColors.primarySoft : Colors.transparent,
            border: Border.all(
              color: selected ? SproutColors.primary : Colors.transparent,
              width: 3,
            ),
          ),
          child: AvatarBadge(avatarId: id, size: 56),
        ),
      ),
    );
  }
}
