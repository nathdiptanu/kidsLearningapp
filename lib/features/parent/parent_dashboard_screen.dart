import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/session_providers.dart';
import '../../core/design_system/sprout_tokens.dart';
import '../../core/design_system/widgets/app_page_scaffold.dart';
import '../../core/design_system/widgets/sprout_card.dart';
import '../../domain/models/game_category.dart';
import '../../domain/parent/parent_report.dart';
import 'parent_hold_gate.dart';

class ParentDashboardScreen extends StatelessWidget {
  const ParentDashboardScreen({this.revokeOnDispose = true, super.key});

  final bool revokeOnDispose;

  @override
  Widget build(BuildContext context) {
    return ParentHoldGate(
      revokeOnDispose: revokeOnDispose,
      title: 'Learning summary',
      child: const ParentDashboardBody(),
    );
  }
}

class ParentDashboardBody extends ConsumerWidget {
  const ParentDashboardBody({super.key});

  static const _skills = ['maths', 'english', 'logic', 'observation', 'knowledge'];

  static const _skillTint = {
    'maths': SproutColors.mathsSurface,
    'english': SproutColors.englishSurface,
    'logic': SproutColors.logicSurface,
    'observation': SproutColors.observationSurface,
    'knowledge': SproutColors.knowledgeSurface,
  };

  static const _skillMark = {
    'maths': SproutColors.maths,
    'english': SproutColors.english,
    'logic': SproutColors.logic,
    'observation': SproutColors.observation,
    'knowledge': SproutColors.knowledge,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final report = ref.watch(parentReportProvider);
    final text = Theme.of(context).textTheme;
    return report.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => ListView(
        padding: const EdgeInsets.all(SproutSpace.page),
        children: const [
          EmptyState(
            title: 'The learning summary could not be opened',
            message: 'Saved progress is not changed. Try again later.',
          ),
        ],
      ),
      data: (data) => ListView(
        padding: const EdgeInsets.fromLTRB(
          SproutSpace.page,
          SproutSpace.sm,
          SproutSpace.page,
          SproutSpace.xl,
        ),
        children: [
          Text(ParentReport.disclaimer, style: text.bodyMedium),
          const SizedBox(height: SproutSpace.md),
          if (data.finishedActivities == 0)
            SproutCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('No finished activities yet', style: text.titleLarge),
                  const SizedBox(height: SproutSpace.sm),
                  Text(
                    'When an activity is finished on this device, practice days, stars and skills appear here.',
                    style: text.bodyMedium,
                  ),
                ],
              ),
            )
          else
            _StatGrid(
              stats: [
                ('Practised today', data.practicedToday),
                ('Last 7 days', data.practicedThisWeek),
                ('Finished activities', data.finishedActivities),
                ('Times played', data.timesPlayed),
                ('Days with practice', data.learningDays),
                ('Stars saved', data.totalStars),
              ],
            ),
          const SectionHeading(title: 'Skills'),
          SproutCard(
            padding: const EdgeInsets.symmetric(
              horizontal: SproutSpace.md,
              vertical: SproutSpace.sm,
            ),
            child: Column(
              children: [
                for (var index = 0; index < _skills.length; index++) ...[
                  if (index > 0) const Divider(),
                  _SkillRow(
                    practice: _skill(data.skills, _skills[index]),
                    tint: _skillTint[_skills[index]]!,
                    mark: _skillMark[_skills[index]]!,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: SproutSpace.sm),
          Text(
            'Tic-Tac-Toe wins are saved as games. They do not change the logic score.',
            style: text.bodySmall,
          ),
          const SectionHeading(title: 'By game'),
          SproutCard(
            padding: const EdgeInsets.symmetric(
              horizontal: SproutSpace.md,
              vertical: SproutSpace.sm,
            ),
            child: Column(
              children: [
                for (var index = 0;
                    index < GameCategory.values.length;
                    index++) ...[
                  if (index > 0) const Divider(),
                  _CountRow(
                    label: categoryLabel(GameCategory.values[index].storageKey),
                    count:
                        data.categoryCounts[GameCategory
                            .values[index]
                            .storageKey] ??
                        0,
                  ),
                ],
              ],
            ),
          ),
          const SectionHeading(title: 'Recent activity'),
          if (data.recent.isEmpty)
            SproutCard(
              child: Text('Nothing finished yet.', style: text.bodyLarge),
            )
          else
            SproutCard(
              padding: const EdgeInsets.symmetric(
                horizontal: SproutSpace.md,
                vertical: SproutSpace.sm,
              ),
              child: Column(
                children: [
                  for (var index = 0; index < data.recent.length; index++) ...[
                    if (index > 0) const Divider(),
                    _RecentRow(item: data.recent[index]),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }

  SkillPractice _skill(List<SkillPractice> skills, String skillId) {
    for (final skill in skills) {
      if (skill.skillId == skillId) {
        return skill;
      }
    }
    return SkillPractice(
      skillId: skillId,
      attempts: 0,
      firstTry: 0,
      hintAssisted: 0,
      incorrect: 0,
      difficulty: 1,
      recentOutcomes: '',
    );
  }
}

class _StatGrid extends StatelessWidget {
  const _StatGrid({required this.stats});

  final List<(String, int)> stats;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final scale = MediaQuery.textScalerOf(context).scale(1);
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 560
            ? 3
            : scale > 1.5
            ? 1
            : 2;
        const gap = 12.0;
        final width =
            (constraints.maxWidth - gap * (columns - 1)) / columns;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final (label, value) in stats)
              SizedBox(
                width: width,
                child: Semantics(
                  label: '$label: $value',
                  excludeSemantics: true,
                  child: SproutCard(
                    padding: const EdgeInsets.all(SproutSpace.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$value',
                          style: text.headlineMedium?.copyWith(
                            color: SproutColors.primary,
                          ),
                        ),
                        Text(label, style: text.bodyMedium),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _SkillRow extends StatelessWidget {
  const _SkillRow({
    required this.practice,
    required this.tint,
    required this.mark,
  });

  final SkillPractice practice;
  final Color tint;
  final Color mark;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final title = skillTitle(practice.skillId);
    final summary = skillSummary(practice);
    return Semantics(
      label: '$title. $summary',
      excludeSemantics: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: tint, shape: BoxShape.circle),
              child: Icon(Icons.eco_rounded, color: mark, size: 22),
            ),
            const SizedBox(width: SproutSpace.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: text.titleMedium),
                  const SizedBox(height: 2),
                  Text(summary, style: text.bodyMedium),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CountRow extends StatelessWidget {
  const _CountRow({required this.label, required this.count});

  final String label;
  final int count;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Semantics(
      label: '$label: $count finished',
      excludeSemantics: true,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: SproutSize.parentTarget),
        child: Row(
          children: [
            Expanded(child: Text(label, style: text.bodyLarge)),
            Text(
              '$count finished',
              style: text.labelLarge?.copyWith(
                color: count == 0 ? SproutColors.inkMuted : SproutColors.ink,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecentRow extends StatelessWidget {
  const _RecentRow({required this.item});

  final RecentPractice item;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final plays = '${item.attempts} ${item.attempts == 1 ? 'play' : 'plays'}';
    final stars = '${item.stars} ${item.stars == 1 ? 'star' : 'stars'}';
    return Semantics(
      label: '${item.title}. ${categoryLabel(item.engine)}. $plays. $stars.',
      excludeSemantics: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.title, style: text.titleSmall),
            const SizedBox(height: 2),
            Text(
              '${categoryLabel(item.engine)} · $plays · $stars',
              style: text.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
