import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/session_providers.dart';
import '../../core/design_system/learning_area.dart';
import '../../core/design_system/sprout_tokens.dart';
import '../../core/design_system/widgets/activity_card.dart';
import '../../core/design_system/widgets/app_page_scaffold.dart';
import '../../core/design_system/widgets/brand_header.dart';
import '../../core/design_system/widgets/category_card.dart';
import '../../core/design_system/widgets/fox_mascot.dart';
import '../../core/design_system/widgets/sprout_card.dart';
import '../../core/design_system/widgets/status_chip.dart';
import '../../domain/lessons/lesson_models.dart';
import '../../domain/games/play/activity_catalog.dart';
import '../lessons/lesson_list.dart';
import '../../domain/games/play/activity_definition.dart';
import '../../domain/models/age_band.dart';
import '../../domain/models/game_category.dart';
import '../../domain/monetization/free_entitlement_policy.dart';
import '../../domain/monetization/monetization_config.dart';
import '../../domain/progress/activity_record.dart';
import '../../domain/regional/regional_availability.dart';
import '../../features/play/activity_access.dart';
import '../../features/play/open_activity.dart';
import '../home/home_screen.dart';
import '../regional/regional_module_screen.dart';
import '../regional/regional_module_style.dart';

class ExploreScreen extends ConsumerWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(sessionProvider).value?.profile;
    if (profile == null) {
      return const SizedBox.shrink();
    }
    final progress = ref.watch(progressListProvider).value ?? const [];
    final band = profile.ageBand;
    final replayable = progress.where((record) => record.completed).length;
    final regional = ref.watch(regionalModulesProvider);
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Semantics(
                      header: true,
                      child: Text('Explore', style: text.headlineMedium),
                    ),
                    const SizedBox(height: SproutSpace.xs),
                    Text(
                      'Choose a learning adventure',
                      style: text.bodyLarge?.copyWith(
                        color: SproutColors.inkMuted,
                      ),
                    ),
                    const SizedBox(height: 12),
                    StatusChip(
                      label: 'Ages ${band.label}',
                      icon: Icons.child_care_rounded,
                    ),
                  ],
                ),
              ),
              const FoxMascot(size: 112),
            ],
          ),
          const SizedBox(height: SproutSpace.lg),
          _CategoryGrid(
            cards: [
              for (final area in LearningArea.values)
                CategoryCard(
                  title: area.title,
                  subtitle: area.subtitle,
                  art: area.art,
                  tint: area.tint,
                  footnote: _finishedNote(area, band, progress),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (context) => CategoryScreen(area: area),
                    ),
                  ),
                ),
              for (final module in regional)
                CategoryCard(
                  title: module.title,
                  subtitle: module.subtitle,
                  art: module.art,
                  tint: module.tint,
                  scriptSample: module.scriptSample,
                  scriptColor: module.mark,
                  footnote: includeDevelopmentSamples()
                      ? 'Development samples'
                      : 'Coming soon',
                  onTap: () => openRegionalModule(context, ref, module),
                ),
            ],
          ),
          const SizedBox(height: SproutSpace.md),
          CategoryCard(
            wide: true,
            title: 'Play again',
            subtitle: 'Revisit your favourites',
            footnote: replayable == 0
                ? 'Finished activities appear here'
                : replayable == 1
                ? '1 finished activity'
                : '$replayable finished activities',
            art: SproutArt.maze,
            tint: SproutColors.mazeSurface,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (context) => const PlayAgainScreen(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _finishedNote(
    LearningArea area,
    AgeBand band,
    List<ActivityRecord> progress,
  ) {
    const catalog = ActivityCatalog();
    final ids = {
      for (final category in area.categories)
        for (final activity in catalog.forBand(category, band)) activity.id,
    };
    final done = progress
        .where((record) => record.completed && ids.contains(record.activityId))
        .length;
    return '$done of ${ids.length} finished';
  }
}

class _CategoryGrid extends StatelessWidget {
  const _CategoryGrid({required this.cards});

  final List<Widget> cards;

  @override
  Widget build(BuildContext context) {
    final scale = MediaQuery.textScalerOf(context).scale(1);
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        var columns = width >= 600
            ? 3
            : width >= 300
            ? 2
            : 1;
        if (scale > 1.3) {
          columns = width >= 600 ? 2 : 1;
        }
        const gap = 12.0;
        return Column(
          children: [
            for (var start = 0; start < cards.length; start += columns) ...[
              if (start > 0) const SizedBox(height: gap),
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (var offset = 0; offset < columns; offset++) ...[
                      if (offset > 0) const SizedBox(width: gap),
                      Expanded(
                        child: start + offset < cards.length
                            ? cards[start + offset]
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

/// One learning area: its games and levels for the saved band.
class CategoryScreen extends ConsumerWidget {
  const CategoryScreen({required this.area, super.key});

  final LearningArea area;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(sessionProvider).value?.profile;
    if (profile == null) {
      return AppPageScaffold(title: area.title, body: const SizedBox.shrink());
    }
    final progress = ref.watch(progressListProvider).value ?? const [];
    final premium = ref.watch(premiumActiveProvider);
    final started = ref.watch(startedActivityIdsProvider).value ?? const {};
    const catalog = ActivityCatalog();
    final text = Theme.of(context).textTheme;
    const pad = EdgeInsets.symmetric(horizontal: SproutSpace.page);
    return AppPageScaffold(
      title: area.title,
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: pad.copyWith(top: SproutSpace.sm),
            sliver: SliverToBoxAdapter(
              child: SproutCard(
                color: area.tint,
                accent: SproutColors.cardEdge,
                padding: const EdgeInsets.all(SproutSpace.md),
                child: Row(
                  children: [
                    SizedBox(
                      width: 120,
                      child: AspectRatio(
                        aspectRatio: 4 / 3,
                        child: ArtTile(
                          art: area.art,
                          tint: area.tint,
                          radius: 16,
                        ),
                      ),
                    ),
                    const SizedBox(width: SproutSpace.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(area.subtitle, style: text.titleMedium),
                          const SizedBox(height: SproutSpace.sm),
                          StatusChip(
                            label: 'Ages ${profile.ageBand.label}',
                            icon: Icons.child_care_rounded,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          for (final category in area.categories) ...[
            SliverPadding(
              padding: pad,
              sliver: SliverToBoxAdapter(
                child: SectionHeading(
                  title: gameKindLabel(category),
                  detail: _sectionDetail(category, progress, premium),
                ),
              ),
            ),
            SliverPadding(
              padding: pad,
              sliver: _LevelList(
                activities: catalog.forBand(category, profile.ageBand),
                progress: progress,
                premium: premium,
                started: started,
              ),
            ),
          ],
          if (area == LearningArea.english)
            SliverPadding(
              padding: pad,
              sliver: SliverToBoxAdapter(
                child: LessonLane(
                  title: 'Letters and sounds',
                  lessons: englishLetterLessonsForSession(ref),
                ),
              ),
            ),
          const SliverToBoxAdapter(child: SizedBox(height: SproutSpace.xl)),
        ],
      ),
    );
  }

  String _sectionDetail(
    GameCategory category,
    List<ActivityRecord> progress,
    bool premium,
  ) {
    final base = gameKindDetail(category);
    final where = category == GameCategory.ticTacToe
        ? ' Played on this device against the app.'
        : '';
    if (premium) {
      return '$base.$where';
    }
    const limit = MonetizationConfig.freeCompletedLevelsPerGame;
    final used = freeCompletedCount(progress, category).clamp(0, limit);
    return '$base.$where $used of $limit free new levels finished. '
        'Finished levels can always be played again.';
  }
}

class _LevelList extends StatelessWidget {
  const _LevelList({
    required this.activities,
    required this.progress,
    required this.premium,
    required this.started,
  });

  final List<ActivityDefinition> activities;
  final List<ActivityRecord> progress;
  final bool premium;
  final Set<String> started;

  @override
  Widget build(BuildContext context) {
    return SliverList.separated(
      itemCount: activities.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final decision = accessFor(
          activity: activities[index],
          records: progress,
          premiumActive: premium,
          startedActivityIds: started,
        );
        return LevelCard(decision: decision);
      },
    );
  }
}

/// One level with its access state from the central policy.
class LevelCard extends StatelessWidget {
  const LevelCard({required this.decision, this.showKind = false, super.key});

  final ActivityAccess decision;
  final bool showKind;

  @override
  Widget build(BuildContext context) {
    final activity = decision.activity;
    final stars = decision.record?.bestStars ?? 0;
    final (status, words) = switch (decision.access) {
      LevelAccess.replay => (
        StatusChip(
          label: stars > 0
              ? 'Finished · best $stars ${stars == 1 ? 'star' : 'stars'}'
              : 'Finished',
          tone: StatusTone.done,
        ),
        'Finished. Play again.',
      ),
      LevelAccess.continueInProgress => (
        const StatusChip(label: 'Continue', tone: StatusTone.inProgress),
        'Started. Continue.',
      ),
      LevelAccess.locked => (
        const StatusChip(label: 'Locked', tone: StatusTone.locked),
        'Locked. Ask a grown-up.',
      ),
      LevelAccess.playNew => (
        const StatusChip(label: 'Ready', tone: StatusTone.ready),
        'Ready to play.',
      ),
    };
    final subtitle = showKind
        ? '${gameKindLabel(activity.category)} · ${levelLabel(activity)} · Ages ${activity.band.label}'
        : levelLabel(activity);
    return ActivityCard(
      step: activity.variant + 1,
      stepMark: decision.access == LevelAccess.replay
          ? StepMark.done
          : StepMark.upcoming,
      title: activity.title,
      subtitle: subtitle,
      art: artFor(activity.category),
      tint: tintFor(activity.category),
      dimmed: decision.access == LevelAccess.locked,
      status: status,
      onTap: () => openActivity(context, decision),
      semanticsLabel: '${activity.title}. $subtitle. $words',
    );
  }
}

bool _replayVisible(
  ActivityDefinition activity,
  List<RegionalModule> modules,
) {
  if (activity.category == GameCategory.hindi) {
    return modules.contains(RegionalModule.hindi);
  }
  if (activity.category == GameCategory.discoverIndia) {
    return modules.contains(RegionalModule.discoverIndia);
  }
  return true;
}

/// Finished activities that can be replayed, newest first.
class PlayAgainScreen extends ConsumerWidget {
  const PlayAgainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(progressListProvider).value ?? const [];
    final premium = ref.watch(premiumActiveProvider);
    final started = ref.watch(startedActivityIdsProvider).value ?? const {};
    const catalog = ActivityCatalog();
    final settings = ref.watch(sessionProvider).value?.settings;
    final modules = settings == null
        ? const <RegionalModule>[]
        : RegionalAvailability.available(settings);
    final finished = progress.where((record) => record.completed).toList()
      ..sort((a, b) => b.lastPlayedAt.compareTo(a.lastPlayedAt));
    final decisions = <ActivityAccess>[
      for (final record in finished)
        if (catalog.byId(record.activityId) case final activity?)
          if (_replayVisible(activity, modules))
          accessFor(
            activity: activity,
            records: progress,
            premiumActive: premium,
            startedActivityIds: started,
          ),
    ].where((decision) => decision.access != LevelAccess.locked).toList();
    return AppPageScaffold(
      title: 'Play again',
      body: decisions.isEmpty
          ? ListView(
              padding: const EdgeInsets.all(SproutSpace.page),
              children: const [
                EmptyState(
                  title: 'Nothing to play again yet',
                  message: 'When you finish an activity, it shows up here so you can play it again.',
                ),
              ],
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(
                SproutSpace.page,
                SproutSpace.sm,
                SproutSpace.page,
                SproutSpace.xl,
              ),
              itemCount: decisions.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) =>
                  LevelCard(decision: decisions[index], showKind: true),
            ),
    );
  }
}
