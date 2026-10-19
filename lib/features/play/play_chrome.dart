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
    final adventure = onNext == null
        ? null
        : ref.watch(dailyJourneyProvider).value;
    final adventureFinished = onNext != null && adventure?.isComplete == true;
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: SproutSize.pageMaxWidth),
        child: ListView(
          padding: const EdgeInsets.all(SproutSpace.page),
          children: [
            Center(
              child: FoxMascot(
                size: MediaQuery.sizeOf(context).width < 360 ? 96.0 : 128.0,
              ),
            ),
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
            if (adventureFinished) ...[
              Text(
                'Adventure finished! Choose another adventure or take a break.',
                style: text.titleMedium,
              ),
              const SizedBox(height: 12),
              PrimaryKidButton(
                label: 'Next adventure',
                onPressed: () async {
                  final session = ref.read(sessionProvider).value;
                  final profile = session?.profile;
                  if (profile == null || adventure == null) return;
                  await ref
                      .read(journeyRepositoryProvider)
                      .ensure(
                        profile: profile,
                        records: await ref.read(progressListProvider.future),
                        now: DateTime.now(),
                        premiumActive: ref.read(premiumActiveProvider),
                        settings: session!.settings,
                        itemProgress: await ref.read(
                          itemProgressProvider.future,
                        ),
                        afterCompletedJourneyId: adventure.id,
                      );
                  ref.invalidate(dailyJourneyProvider);
                  if (context.mounted) onDone();
                },
              ),
              const SizedBox(height: 12),
              SecondaryKidButton(label: 'Take a break', onPressed: onDone),
              const SizedBox(height: 12),
            ],
            _FinishActions(
              onReplay: onReplay,
              onNext: adventureFinished ? null : onNext,
              onDone: onDone,
            ),
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
                Icons.workspace_premium_rounded,
                color: SproutColors.primary,
                size: 32,
              ),
              const SizedBox(width: SproutSpace.sm),
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
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

/// Hear again, Next/Skip, and Done/Next activity. Same words on every game.
class PinnedActivityActions extends StatelessWidget {
  const PinnedActivityActions({
    required this.finished,
    required this.primaryKey,
    required this.onPrimary,
    this.onHearAgain,
    this.audioUnavailable = false,
    this.onSkip,
    this.fromJourney = false,
    this.onHome,
    super.key,
  });

  final bool finished;
  final Key primaryKey;
  final VoidCallback onPrimary;
  final VoidCallback? onHearAgain;
  final bool audioUnavailable;
  final VoidCallback? onSkip;
  final bool fromJourney;
  final VoidCallback? onHome;

  @override
  Widget build(BuildContext context) {
    final hear = onHearAgain;
    final skip = onSkip;
    final home = onHome;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (hear != null || audioUnavailable) ...[
          SecondaryKidButton(
            label: audioUnavailable ? 'Audio unavailable' : 'Hear again',
            trailingIcon: Icons.replay_rounded,
            onPressed: audioUnavailable ? null : hear,
          ),
          const SizedBox(height: 12),
        ],
        PrimaryKidButton(
          key: primaryKey,
          label: finished
              ? fromJourney
                    ? 'Next activity'
                    : 'Done'
              : 'Next',
          trailingIcon: Icons.chevron_right_rounded,
          onPressed: onPrimary,
        ),
        if (!finished && skip != null) ...[
          const SizedBox(height: 12),
          SecondaryKidButton(label: 'Skip', onPressed: skip),
        ],
        if (finished && fromJourney && home != null) ...[
          const SizedBox(height: 12),
          SecondaryKidButton(label: 'Home', onPressed: home),
        ],
      ],
    );
  }
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
            trailingIcon: Icons.chevron_right_rounded,
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
