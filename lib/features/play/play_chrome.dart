import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/session_providers.dart';
import '../../core/design_system/sprout_tokens.dart';
import '../../core/design_system/widgets/fox_mascot.dart';
import '../../core/design_system/widgets/primary_kid_button.dart';
import '../../core/design_system/widgets/sprout_card.dart';
import '../../domain/rewards/reward_catalog.dart';

Future<void> confirmLeaveActivity(
  BuildContext context, {
  required bool finished,
}) async {
  if (finished) {
    Navigator.of(context).pop();
    return;
  }
  final leave = await showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Leave this activity?'),
        content: const Text(
          'You can come back later. Leaving does not finish it.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Stay'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Leave'),
          ),
        ],
      );
    },
  );
  if (leave == true && context.mounted) {
    Navigator.of(context).pop();
  }
}

/// What to do in a game, on a white card under the header.
class PlayInstruction extends StatelessWidget {
  const PlayInstruction({required this.text, this.detail, super.key});

  final String text;
  final String? detail;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(top: SproutSpace.md),
      child: SproutCard(
        padding: const EdgeInsets.all(SproutSpace.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(text, style: theme.titleMedium?.copyWith(fontSize: 20)),
            if (detail != null) ...[
              const SizedBox(height: SproutSpace.xs),
              Text(detail!, style: theme.bodyMedium),
            ],
          ],
        ),
      ),
    );
  }
}

/// Completion summary. Shows the saved score; it does not award anything.
class FinishedBanner extends ConsumerWidget {
  const FinishedBanner({
    required this.stars,
    required this.points,
    required this.badgeLabel,
    required this.onDone,
    this.headline = 'You finished!',
    this.onNext,
    this.onReplay,
    super.key,
  });

  static const maxStars = 3;

  final String headline;
  final int stars;
  final int points;
  final String badgeLabel;
  final VoidCallback onDone;
  final VoidCallback? onNext;
  final VoidCallback? onReplay;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fresh = ref.watch(freshRewardIdsProvider);
    final rewardName = fresh.isEmpty ? null : rewardById(fresh.first)?.title;
    final text = Theme.of(context).textTheme;
    final shown = stars.clamp(0, maxStars);
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: SproutSize.pageMaxWidth),
        child: ListView(
          padding: const EdgeInsets.all(SproutSpace.page),
          children: [
            const Center(child: FoxMascot(size: 150)),
            const SizedBox(height: SproutSpace.sm),
            Semantics(
              header: true,
              liveRegion: true,
              child: Text(
                headline,
                textAlign: TextAlign.center,
                style: text.headlineMedium,
              ),
            ),
            const SizedBox(height: SproutSpace.md),
            SproutCard(
              child: Column(
                children: [
                  Semantics(
                    label: '$shown of $maxStars stars',
                    excludeSemantics: true,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (var index = 0; index < maxStars; index++)
                          Icon(
                            index < shown
                                ? Icons.star_rounded
                                : Icons.star_outline_rounded,
                            size: 52,
                            color: index < shown
                                ? SproutColors.accent
                                : SproutColors.line,
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: SproutSpace.xs),
                  Text(
                    '${shown == 1 ? '1 star' : '$shown stars'} · '
                    '${points == 1 ? '1 point' : '$points points'}',
                    style: text.titleMedium,
                  ),
                  const SizedBox(height: SproutSpace.md),
                  _LevelBadge(label: badgeLabel),
                  if (rewardName != null) ...[
                    const SizedBox(height: 12),
                    Semantics(
                      liveRegion: true,
                      child: DecoratedBox(
                        decoration: const BoxDecoration(
                          color: SproutColors.successSoft,
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              const ExcludeSemantics(
                                child: Icon(
                                  Icons.card_giftcard_rounded,
                                  color: SproutColors.success,
                                ),
                              ),
                              const SizedBox(width: SproutSpace.sm),
                              Expanded(
                                child: Text(
                                  'New reward saved: $rewardName',
                                  style: text.bodyLarge,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: SproutSpace.lg),
            _FinishActions(onReplay: onReplay, onNext: onNext, onDone: onDone),
          ],
        ),
      ),
    );
  }
}

class _LevelBadge extends StatelessWidget {
  const _LevelBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      excludeSemantics: true,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: SproutColors.primarySoft,
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              const Icon(
                Icons.workspace_premium,
                color: SproutColors.primary,
                size: 32,
              ),
              const SizedBox(width: SproutSpace.sm),
              Expanded(
                child: Text(label, style: Theme.of(context).textTheme.bodyLarge),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FinishActions extends StatefulWidget {
  const _FinishActions({required this.onDone, this.onNext, this.onReplay});

  final VoidCallback onDone;
  final VoidCallback? onNext;
  final VoidCallback? onReplay;

  @override
  State<_FinishActions> createState() => _FinishActionsState();
}

class _FinishActionsState extends State<_FinishActions> {
  var _busy = false;

  void _run(VoidCallback action) {
    if (_busy) {
      return;
    }
    setState(() => _busy = true);
    action();
  }

  @override
  Widget build(BuildContext context) {
    final next = widget.onNext;
    final replay = widget.onReplay;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (next != null) ...[
          PrimaryKidButton(
            label: 'Next activity',
            trailingIcon: Icons.chevron_right,
            onPressed: _busy ? null : () => _run(next),
          ),
          const SizedBox(height: 12),
        ],
        if (next == null)
          PrimaryKidButton(
            label: 'Home',
            onPressed: _busy ? null : () => _run(widget.onDone),
          )
        else
          SecondaryKidButton(
            label: 'Home',
            onPressed: _busy ? null : () => _run(widget.onDone),
          ),
        if (replay != null) ...[
          const SizedBox(height: 12),
          SecondaryKidButton(
            label: 'Play again',
            onPressed: _busy ? null : () => _run(replay),
          ),
        ],
      ],
    );
  }
}
