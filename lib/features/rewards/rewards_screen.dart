import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/session_providers.dart';
import '../../core/design_system/sprout_tokens.dart';
import '../../core/design_system/widgets/app_page_scaffold.dart';
import '../../core/design_system/widgets/brand_header.dart';
import '../../core/design_system/widgets/fox_mascot.dart';
import '../../core/design_system/widgets/sprout_card.dart';
import '../../core/design_system/widgets/status_chip.dart';
import '../../domain/rewards/reward_catalog.dart';
import '../home/home_screen.dart';
import 'sticker_glyph.dart';

class RewardsScreen extends ConsumerWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shelf = ref.watch(rewardShelfProvider);
    final text = Theme.of(context).textTheme;
    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
          SproutSpace.page,
          SproutSpace.md,
          SproutSpace.page,
          SproutSpace.lg,
        ),
        children: [
          BrandHeader(onParents: () => openGrownUpArea(context)),
          const SizedBox(height: SproutSpace.md),
          ...shelf.when(
            loading: () => const [
              Padding(
                padding: EdgeInsets.all(SproutSpace.xl),
                child: Center(child: CircularProgressIndicator()),
              ),
            ],
            error: (error, stack) => const [
              EmptyState(
                title: 'Rewards could not be opened',
                message: 'Finished activities are still saved on this device.',
              ),
            ],
            data: (data) {
              final badges = [
                for (final reward in rewardCatalog)
                  if (reward.kind == RewardKind.badge) reward,
              ];
              final stickers = [
                for (final reward in rewardCatalog)
                  if (reward.kind == RewardKind.sticker) reward,
              ];
              final earnedBadges = badges.where((b) => data.isUnlocked(b.id));
              final earnedStickers = stickers
                  .where((item) => data.isUnlocked(item.id))
                  .toList();
              final upcoming = stickers
                  .where((item) => !data.isUnlocked(item.id))
                  .toList();
              final stars = data.snapshot.totalStars;
              return [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Semantics(
                            header: true,
                            child: Text('Rewards', style: text.headlineLarge),
                          ),
                          const SizedBox(height: SproutSpace.xs),
                          Text(
                            'Stars, badges and stickers you earned',
                            style: text.bodyLarge?.copyWith(
                              color: SproutColors.inkMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const FoxMascot(size: 104),
                  ],
                ),
                const SizedBox(height: SproutSpace.md),
                SproutCard(
                  color: SproutColors.primarySoft,
                  accent: SproutColors.cardEdge,
                  child: Row(
                    children: [
                      const ExcludeSemantics(
                        child: Icon(
                          Icons.star_rounded,
                          size: 56,
                          color: SproutColors.accent,
                        ),
                      ),
                      const SizedBox(width: SproutSpace.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              stars == 0
                                  ? 'No stars yet'
                                  : stars == 1
                                  ? '1 star saved'
                                  : '$stars stars saved',
                              style: text.titleLarge,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              stars == 0
                                  ? 'Stars are saved when an activity is finished.'
                                  : '${earnedBadges.length} of ${badges.length} badges · '
                                        '${earnedStickers.length} of ${stickers.length} stickers',
                              style: text.bodyMedium?.copyWith(
                                color: SproutColors.ink,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SectionHeading(
                  title: 'Badges',
                  detail: 'Earned badges have a purple edge.',
                ),
                _TwoColumn(
                  children: [
                    for (final badge in badges)
                      _RewardCard(
                        reward: badge,
                        unlocked: data.isUnlocked(badge.id),
                        progress: badge.progress(data.snapshot),
                      ),
                  ],
                ),
                const SectionHeading(
                  title: 'Stickers',
                  detail: 'Simple drawings made for this app.',
                ),
                if (earnedStickers.isEmpty)
                  SproutCard(
                    child: Text(
                      'No stickers yet. The next ones are shown below.',
                      style: text.bodyLarge,
                    ),
                  )
                else
                  _TwoColumn(
                    children: [
                      for (final sticker in earnedStickers)
                        _RewardCard(
                          reward: sticker,
                          unlocked: true,
                          progress: sticker.target,
                        ),
                    ],
                  ),
                if (upcoming.isNotEmpty) ...[
                  const SectionHeading(title: 'Coming up'),
                  _TwoColumn(
                    children: [
                      for (final sticker in upcoming)
                        _RewardCard(
                          reward: sticker,
                          unlocked: false,
                          progress: sticker.progress(data.snapshot),
                        ),
                    ],
                  ),
                ],
              ];
            },
          ),
        ],
      ),
    );
  }
}

class _TwoColumn extends StatelessWidget {
  const _TwoColumn({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final scale = MediaQuery.textScalerOf(context).scale(1);
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 600
            ? 3
            : constraints.maxWidth >= 320 && scale <= 1.3
            ? 2
            : 1;
        return Column(
          children: [
            for (var start = 0; start < children.length; start += columns) ...[
              if (start > 0) const SizedBox(height: 12),
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (var offset = 0; offset < columns; offset++) ...[
                      if (offset > 0) const SizedBox(width: 12),
                      Expanded(
                        child: start + offset < children.length
                            ? children[start + offset]
                            : const SizedBox.shrink(),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

class _RewardCard extends StatelessWidget {
  const _RewardCard({
    required this.reward,
    required this.unlocked,
    required this.progress,
  });

  final RewardDefinition reward;
  final bool unlocked;
  final int progress;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final shown = progress.clamp(0, reward.target);
    final label = unlocked
        ? '${reward.title}. Earned. ${reward.detail}.'
        : '${reward.title}. Not earned yet. $shown of ${reward.target}. ${reward.detail}.';
    final sticker = reward.kind == RewardKind.sticker;
    return Semantics(
      label: label,
      excludeSemantics: true,
      child: SproutCard(
        accent: unlocked ? SproutColors.primary : null,
        padding: const EdgeInsets.all(SproutSpace.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (sticker)
                  Opacity(
                    opacity: unlocked ? 1 : 0.55,
                    child: StickerGlyph(rewardId: reward.id, earned: unlocked),
                  )
                else
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: unlocked
                          ? SproutColors.primary
                          : SproutColors.disabledFill,
                    ),
                    child: Icon(
                      unlocked ? Icons.workspace_premium : Icons.lock_outline,
                      color: unlocked ? SproutColors.surface : SproutColors.lock,
                      size: 30,
                    ),
                  ),
                const Spacer(),
                if (unlocked)
                  const StatusChip(label: 'Earned', tone: StatusTone.done),
              ],
            ),
            const SizedBox(height: 12),
            Text(reward.title, style: text.titleMedium),
            const SizedBox(height: 2),
            Text('${reward.detail}.', style: text.bodySmall),
            if (!unlocked) ...[
              const Spacer(),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(SproutRadius.pill),
                ),
                child: LinearProgressIndicator(
                  value: reward.target == 0 ? 0 : shown / reward.target,
                  minHeight: 8,
                ),
              ),
              const SizedBox(height: SproutSpace.xs),
              Text(
                '$shown of ${reward.target}',
                style: text.labelMedium,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
