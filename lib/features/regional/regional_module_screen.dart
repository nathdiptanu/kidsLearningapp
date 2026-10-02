import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/session_providers.dart';
import '../../core/design_system/sprout_tokens.dart';
import '../../core/design_system/widgets/app_page_scaffold.dart';
import '../../core/design_system/widgets/fox_mascot.dart';
import '../../core/design_system/widgets/sprout_card.dart';
import '../../core/design_system/widgets/status_chip.dart';
import '../../domain/adaptive/daily_journey_planner.dart';
import '../../domain/geography/geography_models.dart';
import '../../domain/heritage/heritage_models.dart';
import '../../domain/learning/item_progress.dart';
import '../../domain/learning/learning_index.dart';
import '../../domain/learning/session_planner.dart';
import '../../domain/lessons/lesson_models.dart';
import '../../domain/progress/activity_record.dart';
import '../../domain/monetization/free_entitlement_policy.dart';
import '../../domain/regional/regional_availability.dart';
import '../geography/geography_list.dart';
import '../heritage/heritage_list.dart';
import '../lessons/lesson_list.dart';
import '../play/activity_access.dart';
import '../play/open_activity.dart';
import 'regional_module_style.dart';

/// Opens a regional module only when the availability rule allows it.
/// Returns false when the module is hidden for the current settings.
bool openRegionalModule(
  BuildContext context,
  WidgetRef ref,
  RegionalModule module,
) {
  if (!ref.read(regionalModulesProvider).contains(module)) {
    return false;
  }
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (context) => RegionalModuleScreen(module: module),
    ),
  );
  return true;
}

/// Landing page for a regional module. It closes itself if the module stops
/// being available, for example after a grown-up changes the region.
class RegionalModuleScreen extends ConsumerStatefulWidget {
  const RegionalModuleScreen({required this.module, super.key});

  final RegionalModule module;

  @override
  ConsumerState<RegionalModuleScreen> createState() =>
      _RegionalModuleScreenState();
}

class _RegionalModuleScreenState extends ConsumerState<RegionalModuleScreen> {
  var _closing = false;

  void _closeIfHidden(bool available) {
    if (available || _closing) {
      return;
    }
    _closing = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Navigator.of(context).maybePop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final module = widget.module;
    final available = ref.watch(regionalModulesProvider).contains(module);
    _closeIfHidden(available);
    if (!available) {
      return AppPageScaffold(
        title: module.title,
        body: const SizedBox.shrink(),
      );
    }
    final text = Theme.of(context).textTheme;
    final lessons = module == RegionalModule.hindi
        ? hindiLessonsForSession(ref: ref)
        : const <LessonRecord>[];
    final places = module == RegionalModule.discoverIndia
        ? discoverIndiaActivitiesForSession(ref)
        : const <GeographyActivity>[];
    final heritage = module == RegionalModule.discoverIndia
        ? discoverIndiaHeritageForSession(ref)
        : const <HeritageActivity>[];
    final practice = todaysPracticeForSession(ref, module);
    return AppPageScaffold(
      title: module.title,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          SproutSpace.page,
          SproutSpace.sm,
          SproutSpace.page,
          SproutSpace.xl,
        ),
        children: [
          SproutCard(
            color: module.tint,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Semantics(
                        header: true,
                        child: Text(module.title, style: text.headlineMedium),
                      ),
                      const SizedBox(height: SproutSpace.xs),
                      Text(module.subtitle, style: text.bodyLarge),
                      const SizedBox(height: 12),
                      StatusChip(
                        label: lessons.isEmpty &&
                                places.isEmpty &&
                                heritage.isEmpty
                            ? 'Coming soon'
                            : 'Development samples',
                        tone: StatusTone.info,
                        icon: lessons.isEmpty &&
                                places.isEmpty &&
                                heritage.isEmpty
                            ? Icons.schedule_rounded
                            : Icons.science_rounded,
                      ),
                    ],
                  ),
                ),
                const FoxMascot(size: 96),
              ],
            ),
          ),
          if (lessons.isNotEmpty) ...[
            const SizedBox(height: SproutSpace.lg),
            LessonLane(title: 'Try a sample', lessons: lessons),
          ],
          if (places.isNotEmpty) ...[
            const SizedBox(height: SproutSpace.lg),
            GeographyLane(title: 'Places', activities: places),
          ],
          if (heritage.isNotEmpty) ...[
            const SizedBox(height: SproutSpace.lg),
            HeritageLane(title: 'Heritage', activities: heritage),
          ],
          if (practice.isNotEmpty) ...[
            const SizedBox(height: SproutSpace.lg),
            _PracticeLane(slots: practice),
          ],
          const SizedBox(height: SproutSpace.lg),
          SectionHeading(title: 'What you will do'),
          const SizedBox(height: 12),
          for (final step in module.journey) ...[
            _JourneyRow(step: step, mark: module.mark),
            const SizedBox(height: 12),
          ],
          const SizedBox(height: SproutSpace.sm),
          Semantics(
            container: true,
            child: Text(
              'For grown-ups: ${module.reviewNote} Changing the learning region later keeps any progress.',
              style: text.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

List<PlannedActivity> todaysPracticeForSession(
  WidgetRef ref,
  RegionalModule module,
) {
  final session = ref.watch(sessionProvider).value;
  final settings = session?.settings;
  final profile = session?.profile;
  if (settings == null || profile == null) {
    return const [];
  }
  final items = switch (ref.watch(itemProgressProvider)) {
    AsyncData(:final value) => value,
    _ => const <LearningItemSnapshot>[],
  };
  final records = switch (ref.watch(progressListProvider)) {
    AsyncData(:final value) => value,
    _ => const <ActivityRecord>[],
  };
  final candidates = [
    for (final item in LearningIndex().visible(
      settings: settings,
      band: profile.ageBand,
      readiness: profile.readiness,
      includeDrafts: includeDevelopmentSamples(),
      introducedItemIds: {
        for (final row in items)
          if (row.hasBeenIntroduced) row.itemId,
      },
    ))
      if (module == RegionalModule.hindi
          ? item.family == 'hindi'
          : item.family == 'geography' || item.family == 'heritage')
        item,
  ];
  return const LearningSessionPlanner().plan(
    band: profile.ageBand,
    readiness: profile.readiness,
    candidates: candidates,
    progress: items,
    records: records,
  );
}

class _PracticeLane extends ConsumerWidget {
  const _PracticeLane({required this.slots});

  final List<PlannedActivity> slots;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Today\'s practice', style: text.titleMedium),
        const SizedBox(height: 4),
        Text(
          'New letters or places, a look back at what was already introduced, and one easier success. A single correct tap is not treated as finished learning.',
          style: text.bodyMedium,
        ),
        const SizedBox(height: 12),
        for (final slot in slots) ...[
          _PracticeRow(slot: slot),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _PracticeRow extends StatelessWidget {
  const _PracticeRow({required this.slot});

  final PlannedActivity slot;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final role = switch (slot.role) {
      JourneyRole.current => 'New',
      JourneyRole.review => 'Review',
      JourneyRole.stretch => 'Easy',
    };
    return Semantics(
      button: true,
      label: '${slot.activity.title}. $role.',
      child: TappableCard(
        onTap: () {
          openActivity(
            context,
            ActivityAccess(
              activity: slot.activity,
              access: LevelAccess.playNew,
              record: null,
            ),
          );
        },
        child: Row(
          children: [
            Expanded(
              child: Text(slot.activity.title, style: text.titleMedium),
            ),
            StatusChip(label: role, tone: StatusTone.info),
          ],
        ),
      ),
    );
  }
}

class _JourneyRow extends StatelessWidget {
  const _JourneyRow({required this.step, required this.mark});

  final RegionalJourneyStep step;
  final Color mark;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Semantics(
      label: '${step.title}. ${step.detail}.',
      excludeSemantics: true,
      child: SproutCard(
        padding: const EdgeInsets.all(SproutSpace.md),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: SproutColors.primarySoft,
                shape: BoxShape.circle,
              ),
              child: Icon(step.icon, color: mark),
            ),
            const SizedBox(width: SproutSpace.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(step.title, style: text.titleMedium),
                  Text(step.detail, style: text.bodyMedium),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
