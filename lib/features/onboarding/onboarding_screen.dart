import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_identity.dart';
import '../../app/session_providers.dart';
import '../../core/design_system/avatars/avatar_badge.dart';
import '../../core/design_system/sprout_theme.dart';
import '../../core/design_system/sprout_tokens.dart';
import '../../core/design_system/learning_area.dart';
import '../../core/design_system/widgets/app_page_scaffold.dart';
import '../../core/design_system/widgets/brand_header.dart';
import '../../core/design_system/widgets/brand_mark.dart';
import '../../core/design_system/widgets/fox_mascot.dart';
import '../../core/design_system/widgets/primary_kid_button.dart';
import '../../core/design_system/widgets/progress_pill.dart';
import '../../core/design_system/widgets/sprout_card.dart';
import '../../domain/models/age_band.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../domain/settings/local_settings.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({required this.initial, super.key});

  final LocalSettings initial;

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  late int _step;
  AgeBand? _band;
  String? _avatarId;
  late final TextEditingController _nickname;
  late bool _effects;
  late bool _music;
  late bool _narration;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _step = widget.initial.onboardingStep.clamp(0, 5);
    _band = widget.initial.draftAgeBand;
    _avatarId = widget.initial.draftAvatarId ?? avatarIds.first;
    _nickname = TextEditingController(text: widget.initial.draftNickname ?? '');
    _effects = widget.initial.soundEffectsEnabled;
    _music = widget.initial.musicEnabled;
    _narration = widget.initial.narrationEnabled;
  }

  @override
  void dispose() {
    _nickname.dispose();
    super.dispose();
  }

  LocalSettings _draft(int step) {
    final nickname = normalizeNickname(_nickname.text);
    return LocalSettings(
      soundEffectsEnabled: _effects,
      musicEnabled: _music,
      narrationEnabled: _narration,
      onboardingComplete: false,
      onboardingStep: step,
      draftAgeBand: _band,
      draftAvatarId: _avatarId,
      draftNickname: nickname,
    );
  }

  Future<void> _persist(int step) async {
    await ref.read(sessionProvider.notifier).saveSettings(_draft(step));
  }

  Future<void> _continue() async {
    if (_saving) {
      return;
    }
    if (_step == 2 && _band == null) {
      return;
    }
    if (_step < 5) {
      setState(() => _saving = true);
      final next = _step + 1;
      await _persist(next);
      if (!mounted) {
        return;
      }
      setState(() {
        _step = next;
        _saving = false;
      });
      return;
    }
    final band = _band;
    final avatar = _avatarId;
    if (band == null || avatar == null) {
      setState(() => _step = band == null ? 2 : 3);
      return;
    }
    setState(() => _saving = true);
    await ref
        .read(sessionProvider.notifier)
        .finishOnboarding(
          avatarId: avatar,
          ageBand: band,
          nickname: _nickname.text,
          settings: _draft(5),
        );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _WelcomePage(onContinue: _saving ? null : _continue),
      _LocalPage(onContinue: _saving ? null : _continue),
      _BandPage(
        selected: _band,
        onSelected: (band) => setState(() => _band = band),
        onContinue: _band == null || _saving ? null : _continue,
      ),
      _AvatarPage(
        avatarId: _avatarId ?? avatarIds.first,
        nickname: _nickname,
        onAvatar: (id) => setState(() => _avatarId = id),
        onContinue: _saving ? null : _continue,
      ),
      _SoundPage(
        effects: _effects,
        music: _music,
        narration: _narration,
        onEffects: (value) => setState(() => _effects = value),
        onMusic: (value) => setState(() => _music = value),
        onNarration: (value) => setState(() => _narration = value),
        onContinue: _saving ? null : _continue,
      ),
      _ReadyPage(onContinue: _saving ? null : _continue),
    ];
    return Theme(
      data: SproutTheme.parent(),
      child: PopScope(
        canPop: _step == 0,
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop) {
            _back();
          }
        },
        child: Scaffold(
          body: SafeArea(
            child: PageWidth(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      SproutSpace.sm,
                      SproutSpace.sm,
                      SproutSpace.page,
                      0,
                    ),
                    child: Row(
                      children: [
                        if (_step > 0)
                          IconButton(
                            tooltip: 'Back',
                            onPressed: _saving ? null : _back,
                            icon: const Icon(Icons.arrow_back_rounded),
                          )
                        else
                          const SizedBox(width: SproutSpace.page - 8),
                        const SizedBox(width: SproutSpace.xs),
                        const SproutWordmark(size: 22),
                        const Spacer(),
                        _StepDots(step: _step, count: pages.length),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(
                        SproutSpace.page,
                        SproutSpace.md,
                        SproutSpace.page,
                        SproutSpace.lg,
                      ),
                      child: SproutCard(child: pages[_step]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _back() async {
    if (_saving || _step == 0) {
      return;
    }
    final previous = _step - 1;
    setState(() => _step = previous);
    await _persist(previous);
  }
}

class _StepDots extends StatelessWidget {
  const _StepDots({required this.step, required this.count});

  final int step;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Step ${step + 1} of $count',
      excludeSemantics: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var index = 0; index < count; index++)
            AnimatedContainer(
              duration: SproutMotion.resolve(context, SproutMotion.small),
              margin: const EdgeInsets.only(left: 6),
              width: index == step ? 22 : 10,
              height: 10,
              decoration: BoxDecoration(
                color: index <= step
                    ? SproutColors.primary
                    : SproutColors.disabledFill,
                borderRadius: const BorderRadius.all(
                  Radius.circular(SproutRadius.pill),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _WelcomePage extends StatelessWidget {
  const _WelcomePage({required this.onContinue});

  final VoidCallback? onContinue;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Center(child: BrandMark(size: 160)),
        const SizedBox(height: SproutSpace.lg),
        Text(
          AppIdentity.visibleName,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: SproutSpace.md),
        Text(
          'Learning through short daily activities.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: SproutSpace.sm),
        Text(
          AppIdentity.supportingMessage,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: SproutSpace.lg),
        const ProgressPill(label: 'Saved on this device'),
        const SizedBox(height: SproutSpace.xl),
        PrimaryKidButton(
          label: 'Next',
          trailingIcon: Icons.chevron_right,
          onPressed: onContinue,
        ),
      ],
    );
  }
}

class _LocalPage extends StatelessWidget {
  const _LocalPage({required this.onContinue});

  final VoidCallback? onContinue;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Center(child: FoxMascot(size: 130)),
        const SizedBox(height: SproutSpace.md),
        Text(
          'For a grown-up',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: SproutSpace.md),
        Text(
          'A grown-up sets up this device. The child does not sign in.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: SproutSpace.sm),
        Text(
          'Activity progress stays on this device.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: SproutSpace.xl),
        PrimaryKidButton(
          label: 'Next',
          trailingIcon: Icons.chevron_right,
          onPressed: onContinue,
        ),
      ],
    );
  }
}

class _BandPage extends StatelessWidget {
  const _BandPage({
    required this.selected,
    required this.onSelected,
    required this.onContinue,
  });

  final AgeBand? selected;
  final ValueChanged<AgeBand> onSelected;
  final VoidCallback? onContinue;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            for (final area in const [
              LearningArea.maths,
              LearningArea.english,
              LearningArea.logic,
            ]) ...[
              if (area != LearningArea.maths) const SizedBox(width: 8),
              Expanded(
                child: AspectRatio(
                  aspectRatio: 4 / 3,
                  child: ArtTile(art: area.art, tint: area.tint, radius: 14),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: SproutSpace.md),
        Text(
          'Learning band',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: SproutSpace.sm),
        Text(
          'Choose a starting band. It can be changed later.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: SproutSpace.md),
        for (final band in AgeBand.values) ...[
          _SelectRow(
            label: 'Ages ${band.label}',
            selected: selected == band,
            onPressed: () => onSelected(band),
          ),
          const SizedBox(height: SproutSpace.sm),
        ],
        const SizedBox(height: SproutSpace.md),
        PrimaryKidButton(
          label: 'Next',
          trailingIcon: Icons.chevron_right,
          onPressed: onContinue,
        ),
      ],
    );
  }
}

class _AvatarPage extends StatelessWidget {
  const _AvatarPage({
    required this.avatarId,
    required this.nickname,
    required this.onAvatar,
    required this.onContinue,
  });

  final String avatarId;
  final TextEditingController nickname;
  final ValueChanged<String> onAvatar;
  final VoidCallback? onContinue;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choose an avatar',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: SproutSpace.sm),
        Text(
          'A nickname is optional and stays on this device.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: SproutSpace.md),
        Wrap(
          spacing: SproutSpace.sm,
          runSpacing: SproutSpace.sm,
          children: [
            for (final id in avatarIds)
              Semantics(
                button: true,
                selected: id == avatarId,
                label: 'Avatar $id',
                child: InkWell(
                  onTap: () => onAvatar(id),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(40)),
                      border: Border.all(
                        color: id == avatarId
                            ? SproutColors.seed
                            : Colors.transparent,
                        width: 3,
                      ),
                    ),
                    child: AvatarBadge(avatarId: id, size: 64),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: SproutSpace.md),
        TextField(
          controller: nickname,
          maxLength: 24,
          decoration: const InputDecoration(labelText: 'Nickname (optional)'),
        ),
        const SizedBox(height: SproutSpace.md),
        PrimaryKidButton(
          label: 'Next',
          trailingIcon: Icons.chevron_right,
          onPressed: onContinue,
        ),
      ],
    );
  }
}

class _SoundPage extends StatelessWidget {
  const _SoundPage({
    required this.effects,
    required this.music,
    required this.narration,
    required this.onEffects,
    required this.onMusic,
    required this.onNarration,
    required this.onContinue,
  });

  final bool effects;
  final bool music;
  final bool narration;
  final ValueChanged<bool> onEffects;
  final ValueChanged<bool> onMusic;
  final ValueChanged<bool> onNarration;
  final VoidCallback? onContinue;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Sound', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: SproutSpace.md),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Sound effects'),
          subtitle: const Text('Correct, retry, finish, and reward sounds.'),
          value: effects,
          onChanged: onEffects,
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Background music'),
          subtitle: const Text(
            'Quiet music. It stays off until you turn it on.',
          ),
          value: music,
          onChanged: onMusic,
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Spoken instructions'),
          subtitle: const Text(
            'Saved for later. This build has no spoken clips.',
          ),
          value: narration,
          onChanged: onNarration,
        ),
        const SizedBox(height: SproutSpace.sm),
        Text(
          'These choices are saved on this device. Games stay usable with sound turned off.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: SproutSpace.lg),
        PrimaryKidButton(
          label: 'Next',
          trailingIcon: Icons.chevron_right,
          onPressed: onContinue,
        ),
      ],
    );
  }
}

class _ReadyPage extends StatelessWidget {
  const _ReadyPage({required this.onContinue});

  final VoidCallback? onContinue;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'What you will find',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: SproutSpace.md),
        const _InfoLine(
          icon: Icons.home_rounded,
          title: 'Home',
          detail: 'Five short activities for today.',
        ),
        const _InfoLine(
          icon: Icons.explore,
          title: 'Explore',
          detail: 'Choose an activity for this learning band.',
        ),
        const _InfoLine(
          icon: Icons.star_rounded,
          title: 'Rewards',
          detail: 'Stars, badges and stickers saved on this device.',
        ),
        const _InfoLine(
          icon: Icons.lock_outline,
          title: 'Parents',
          detail:
              'Hold for 3 seconds to see the learning summary and settings.',
        ),
        const SizedBox(height: SproutSpace.sm),
        Text(
          'Today\'s adventure is saved on this device. There is no streak to lose.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: SproutSpace.lg),
        PrimaryKidButton(label: 'Start playing', onPressed: onContinue),
      ],
    );
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({
    required this.icon,
    required this.title,
    required this.detail,
  });

  final IconData icon;
  final String title;
  final String detail;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Semantics(
      label: '$title. $detail',
      excludeSemantics: true,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: SproutColors.primarySoft,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: SproutColors.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: text.titleMedium),
                  Text(detail, style: text.bodyMedium),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SelectRow extends StatelessWidget {
  const _SelectRow({
    required this.label,
    required this.selected,
    required this.onPressed,
  });

  final String label;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: Material(
        color: selected ? SproutColors.primarySoft : SproutColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(SproutRadius.tile),
          ),
          side: BorderSide(
            color: selected ? SproutColors.seed : SproutColors.line,
            width: selected ? 3 : 1.5,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: SproutSize.parentTarget,
            ),
            child: Padding(
              padding: const EdgeInsets.all(SproutSpace.md),
              child: Row(
                children: [
                  Icon(
                    selected ? Icons.check_circle : Icons.circle_outlined,
                    color: selected ? SproutColors.seed : SproutColors.inkMuted,
                  ),
                  const SizedBox(width: SproutSpace.sm),
                  Text(label, style: Theme.of(context).textTheme.bodyLarge),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
