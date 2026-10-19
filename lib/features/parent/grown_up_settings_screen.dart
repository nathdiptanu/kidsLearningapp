import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/session_providers.dart';
import '../../core/design_system/avatars/avatar_badge.dart';
import '../../core/design_system/sprout_tokens.dart';
import '../../core/design_system/widgets/primary_kid_button.dart';
import '../../core/design_system/widgets/sprout_card.dart';
import '../../core/design_system/widgets/status_chip.dart';
import '../../domain/models/age_band.dart';
import '../../domain/models/child_profile.dart';
import '../../domain/models/readiness.dart';
import '../../domain/repositories/profile_repository.dart';
import 'credits_screen.dart';
import 'learning_preferences_screen.dart';
import 'parent_dashboard_screen.dart';
import 'parent_hold_gate.dart';
import 'premium_screen.dart';
import 'privacy_screen.dart';
import 'speech_settings_card.dart';

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
  late Readiness _readiness;
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
    _readiness = profile?.readiness ?? Readiness.steady;
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
      readiness: _readiness,
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
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (context) => screen));
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
          icon: Icons.public_rounded,
          title: 'Learning preferences',
          subtitle: 'Region, languages, Hindi and Discover India',
          onTap: () => _push(const LearningPreferencesScreen()),
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
          icon: Icons.shield_rounded,
          title: 'About and privacy',
          subtitle: 'What stays on this device',
          onTap: () => _push(const PrivacyScreen()),
        ),
        const SizedBox(height: 12),
        _NavRow(
          icon: Icons.menu_book_rounded,
          title: 'Sources and credits',
          subtitle: 'Where pictures and facts come from',
          onTap: () => _push(const CreditsScreen()),
        ),
        const _ChildrenGroup(),
        _Group(
          title: 'This child',
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
                for (final band in AgeBand.ordered)
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
              'Ages 2–3 is for playing together with a grown-up. At age 3, choose the band that suits your child. Changing the band keeps finished activities. The band never changes on its own.',
              style: text.bodySmall,
            ),
            const SizedBox(height: SproutSpace.md),
            Text('Readiness', style: text.titleSmall),
            const SizedBox(height: SproutSpace.sm),
            ReadinessChips(
              selected: _readiness,
              onSelected: (value) => setState(() => _readiness = value),
            ),
            const SizedBox(height: SproutSpace.sm),
            Text(
              'Changes how close a tracing path needs to be. Other games already adjust from play.',
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
                'Hindi and India use device speech with an installed offline voice. Reviewed recordings are not bundled yet.',
              ),
              value: _narration,
              onChanged: (value) => setState(() => _narration = value),
            ),
            const SpeechSettingsCard(),
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
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Text(
            'SproutLab 0.1.7 (9) · India learning 1\nDevice speech is an interim pronunciation option.',
          ),
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
            const Icon(
              Icons.chevron_right_rounded,
              color: SproutColors.primary,
            ),
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

String childName(ChildProfile profile, int index) {
  return profile.nickname ?? 'Child ${index + 1}';
}

class _ChildrenGroup extends ConsumerWidget {
  const _ChildrenGroup();

  Future<void> _switch(BuildContext context, WidgetRef ref, int id) async {
    final navigator = Navigator.of(context);
    await ref.read(sessionProvider.notifier).switchProfile(id);
    navigator.popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profiles = ref.watch(profilesProvider).value ?? const [];
    final text = Theme.of(context).textTheme;
    return _Group(
      title: 'Children on this device',
      children: [
        Text(
          'Each child has their own band, progress and rewards. Switching does not delete anything.',
          style: text.bodyMedium,
        ),
        const SizedBox(height: 12),
        for (var index = 0; index < profiles.length; index++)
          Padding(
            padding: const EdgeInsets.only(bottom: SproutSpace.sm),
            child: _ChildRow(
              name: childName(profiles[index], index),
              profile: profiles[index],
              onSwitch: profiles[index].active
                  ? null
                  : () => _switch(context, ref, profiles[index].id),
            ),
          ),
        if (profiles.length < ProfileRepository.maxProfiles)
          SecondaryKidButton(
            label: 'Add a child',
            trailingIcon: Icons.person_add_alt_1_rounded,
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (context) => const AddChildScreen(),
              ),
            ),
          ),
      ],
    );
  }
}

class _ChildRow extends StatelessWidget {
  const _ChildRow({
    required this.name,
    required this.profile,
    required this.onSwitch,
  });

  final String name;
  final ChildProfile profile;
  final VoidCallback? onSwitch;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final detail = 'Ages ${profile.ageBand.label} · ${profile.readiness.label}';
    return Row(
      children: [
        ExcludeSemantics(
          child: AvatarBadge(avatarId: profile.avatarId, size: 48),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Semantics(
            label: '$name. $detail${onSwitch == null ? '. Playing now' : ''}',
            excludeSemantics: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: text.titleMedium),
                Text(detail, style: text.bodySmall),
              ],
            ),
          ),
        ),
        const SizedBox(width: SproutSpace.sm),
        if (onSwitch == null)
          const StatusChip(label: 'Playing now', tone: StatusTone.done)
        else
          OutlinedButton(
            onPressed: onSwitch,
            child: Semantics(
              label: 'Switch to $name',
              excludeSemantics: true,
              child: const Text('Switch'),
            ),
          ),
      ],
    );
  }
}

/// Readiness choice. A preference set by a grown-up, not an assessment.
class ReadinessChips extends StatelessWidget {
  const ReadinessChips({
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final Readiness selected;
  final ValueChanged<Readiness> onSelected;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Wrap(
      spacing: SproutSpace.sm,
      runSpacing: SproutSpace.sm,
      children: [
        for (final readiness in Readiness.values)
          Tooltip(
            message: readiness.detail,
            child: ChoiceChip(
              label: Text(readiness.label),
              selected: selected == readiness,
              showCheckmark: true,
              labelStyle: text.labelLarge,
              materialTapTargetSize: MaterialTapTargetSize.padded,
              onSelected: (_) => onSelected(readiness),
            ),
          ),
      ],
    );
  }
}

class AddChildScreen extends StatelessWidget {
  const AddChildScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ParentHoldGate(
      revokeOnDispose: false,
      title: 'Add a child',
      child: _AddChildForm(),
    );
  }
}

class _AddChildForm extends ConsumerStatefulWidget {
  const _AddChildForm();

  @override
  ConsumerState<_AddChildForm> createState() => _AddChildFormState();
}

class _AddChildFormState extends ConsumerState<_AddChildForm> {
  AgeBand? _band;
  var _readiness = Readiness.steady;
  var _avatarId = avatarIds.first;
  final _nickname = TextEditingController();
  var _saving = false;

  @override
  void dispose() {
    _nickname.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final band = _band;
    if (_saving || band == null) {
      return;
    }
    setState(() => _saving = true);
    final navigator = Navigator.of(context);
    await ref
        .read(sessionProvider.notifier)
        .addProfile(
          avatarId: _avatarId,
          ageBand: band,
          nickname: _nickname.text,
          readiness: _readiness,
        );
    navigator.popUntil((route) => route.isFirst);
  }

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
        _Group(
          title: 'New child',
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
                for (final band in AgeBand.ordered)
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
            const SizedBox(height: SproutSpace.md),
            Text('Readiness', style: text.titleSmall),
            const SizedBox(height: SproutSpace.sm),
            ReadinessChips(
              selected: _readiness,
              onSelected: (value) => setState(() => _readiness = value),
            ),
          ],
        ),
        const SizedBox(height: SproutSpace.lg),
        PrimaryKidButton(
          label: 'Add child',
          onPressed: _band == null || _saving ? null : _save,
        ),
      ],
    );
  }
}

