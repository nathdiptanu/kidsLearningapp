import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/session_providers.dart';
import '../../core/design_system/avatars/avatar_badge.dart';
import '../../core/design_system/learning_area.dart';
import '../../core/design_system/sprout_tokens.dart';
import '../../core/design_system/widgets/activity_card.dart';
import '../../core/design_system/widgets/app_page_scaffold.dart';
import '../../core/design_system/widgets/brand_header.dart';
import '../../core/design_system/widgets/fox_mascot.dart';
import '../../core/design_system/widgets/primary_kid_button.dart';
import '../../core/design_system/widgets/sprout_card.dart';
import '../../core/design_system/widgets/status_chip.dart';
import '../../data/repositories/drift_journey_repository.dart';
import '../../domain/adaptive/daily_journey_planner.dart';
import '../../domain/games/play/activity_catalog.dart';
import '../../domain/progress/activity_record.dart';
import '../../features/parent/grown_up_settings_screen.dart';
import '../../features/play/activity_access.dart';
import '../../features/play/open_activity.dart';
import '../explore/explore_screen.dart';

void openGrownUpArea(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (context) => const GrownUpSettingsScreen(),
    ),
  );
}

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider).value;
    final progress = ref.watch(progressListProvider).value ?? const [];
    final profile = session?.profile;
    if (profile == null) {
      return const SizedBox.shrink();
    }
    final journey = ref.watch(dailyJourneyProvider);
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
          _Greeting(nickname: profile.nickname, avatarId: profile.avatarId),
          const _SessionNote(),
          const SizedBox(height: SproutSpace.md),
          ...journey.when(
            loading: () => const [
              Padding(
                padding: EdgeInsets.all(SproutSpace.xl),
                child: Center(child: CircularProgressIndicator()),
              ),
            ],
            error: (error, stack) => const [
              EmptyState(
                title: 'Today\'s adventure could not be opened',
                message: 'Saved progress is safe. Try Explore, or close and open the app again.',
              ),
            ],
            data: (plan) => [
              _JourneyHero(
                plan: plan,
                onNext: () async {
                  await ref
                      .read(journeyRepositoryProvider)
                      .ensure(
                        profile: profile,
                        records: progress,
                        now: DateTime.now(),
                        premiumActive: ref.read(premiumActiveProvider),
                        settings: session!.settings,
                        itemProgress: await ref.read(
                          itemProgressProvider.future,
                        ),
                        afterCompletedJourneyId: plan.id,
                      );
                  ref.invalidate(dailyJourneyProvider);
                },
                onReplay: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const PlayAgainScreen(),
                  ),
                ),
                onStart: plan.current == null
                    ? null
                    : () => _open(context, ref, plan.current!, plan, progress),
              ),
              const SectionHeading(title: 'Your activities'),
              for (var index = 0; index < plan.slots.length; index++) ...[
                _JourneyActivity(
                  step: index + 1,
                  slot: plan.slots[index],
                  current:
                      plan.current?.activityId == plan.slots[index].activityId,
                  onTap: () =>
                      _open(context, ref, plan.slots[index], plan, progress),
                ),
                const SizedBox(height: 12),
              ],
            ],
          ),
        ],
      ),
    );
  }

  void _open(
    BuildContext context,
    WidgetRef ref,
    JourneySlotView slot,
    DailyJourneyView plan,
    List<ActivityRecord> progress,
  ) {
    final activity = const ActivityCatalog().byId(slot.activityId);
    if (activity == null) {
      return;
    }
    final decision = accessFor(
      activity: activity,
      records: progress,
      premiumActive: ref.read(premiumActiveProvider),
      startedActivityIds:
          ref.read(startedActivityIdsProvider).value ?? const {},
    );
    openActivity(context, decision, journeyDate: plan.dateKey);
  }
}

class _Greeting extends StatelessWidget {
  const _Greeting({required this.nickname, required this.avatarId});

  final String? nickname;
  final String avatarId;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final scale = MediaQuery.textScalerOf(context).scale(1);
    final mascot = scale > 1.6 ? 88.0 : 120.0;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ExcludeSemantics(
                    child: AvatarBadge(avatarId: avatarId, size: 36),
                  ),
                  const SizedBox(width: SproutSpace.sm),
                  Flexible(
                    child: Text(
                      nickname == null ? 'Hello!' : 'Hello, $nickname!',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: text.titleMedium?.copyWith(
                        color: SproutColors.inkMuted,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: SproutSpace.xs),
              Semantics(
                header: true,
                child: Text(
                  'Let\'s learn and play!',
                  style: text.headlineMedium,
                ),
              ),
            ],
          ),
        ),
        FoxMascot(size: mascot),
      ],
    );
  }
}

class _JourneyHero extends StatelessWidget {
  const _JourneyHero({
    required this.plan,
    required this.onStart,
    required this.onNext,
    required this.onReplay,
  });

  final DailyJourneyView plan;
  final VoidCallback? onStart;
  final VoidCallback onNext;
  final VoidCallback onReplay;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final done = plan.finishedCount;
    final total = plan.slots.length;
    final marks = [
      for (final slot in plan.slots)
        slot.done
            ? StepMark.done
            : slot.activityId == plan.current?.activityId
            ? StepMark.current
            : StepMark.upcoming,
    ];
    return SproutCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            plan.isComplete ? 'Adventure complete' : 'Today\'s adventure',
            style: text.titleLarge,
          ),
          const SizedBox(height: SproutSpace.xs),
          Text(
            '$done of $total activities complete${plan.skippedCount == 0 ? '' : ' · ${plan.skippedCount} skipped'}',
            style: text.bodyMedium?.copyWith(color: SproutColors.ink),
          ),
          const SizedBox(height: SproutSpace.md + 4),
          JourneyProgress(marks: marks),
          const SizedBox(height: SproutSpace.md + 4),
          if (plan.isComplete)
            DecoratedBox(
              decoration: const BoxDecoration(
                color: SproutColors.successSoft,
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(SproutSpace.md),
                child: Row(
                  children: [
                    const ExcludeSemantics(
                      child: Icon(
                        Icons.check_circle_rounded,
                        color: SproutColors.success,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        plan.skippedCount == 0
                            ? 'Well played! You finished this adventure.'
                            : 'Well explored! You can try a new adventure.',
                        style: text.bodyLarge,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            Align(
              alignment: Alignment.centerLeft,
              child: PrimaryKidButton(
                label: done == 0 ? 'Start adventure' : 'Continue adventure',
                trailingIcon: Icons.chevron_right_rounded,
                onPressed: onStart,
              ),
            ),
          if (plan.isComplete) ...[
            const SizedBox(height: 12),
            PrimaryKidButton(label: 'Next adventure', onPressed: onNext),
            const SizedBox(height: 12),
            SecondaryKidButton(label: 'Play again', onPressed: onReplay),
            const SizedBox(height: 12),
            SecondaryKidButton(
              label: 'Take a break',
              onPressed: () => showDialog<void>(
                context: context,
                builder: (_) => const AlertDialog(
                  title: Text('Time for a break'),
                  content: Text('You can come back whenever you are ready.'),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _JourneyActivity extends StatelessWidget {
  const _JourneyActivity({
    required this.step,
    required this.slot,
    required this.current,
    required this.onTap,
  });

  final int step;
  final JourneySlotView slot;
  final bool current;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final activity = const ActivityCatalog().byId(slot.activityId);
    final category = activity?.category;
    final kind = category == null ? null : gameKindLabel(category);
    final role = switch (slot.role) {
      JourneyRole.review => 'Practice again',
      JourneyRole.stretch => 'A little extra',
      JourneyRole.current => null,
    };
    final detail = [?kind, ?role].join(' · ');
    final stars = slot.stars == 1 ? '1 star' : '${slot.stars} stars';
    final status = slot.done
        ? StatusChip(label: 'Done · $stars', tone: StatusTone.done)
        : slot.skipped
        ? const StatusChip(label: 'Skipped')
        : current
        ? const StatusChip(label: 'Up next', tone: StatusTone.ready)
        : null;
    final stateWords = slot.done
        ? 'Done, $stars'
        : slot.skipped
        ? 'Skipped'
        : current
        ? 'Up next'
        : 'Later';
    return ActivityCard(
      step: step,
      stepMark: slot.done
          ? StepMark.done
          : current
          ? StepMark.current
          : StepMark.upcoming,
      title: slot.title,
      subtitle: detail.isEmpty ? null : detail,
      art: category == null ? SproutArt.logic : artFor(category),
      tint: category == null ? SproutColors.logicSurface : tintFor(category),
      status: status,
      highlighted: current,
      onTap: onTap,
      semanticsLabel: 'Step $step. ${slot.title}. $detail. $stateWords',
    );
  }
}

class _SessionNote extends ConsumerStatefulWidget {
  const _SessionNote();

  @override
  ConsumerState<_SessionNote> createState() => _SessionNoteState();
}

class _SessionNoteState extends ConsumerState<_SessionNote> {
  var _hidden = false;
  late final DateTime _started = DateTime.now();
  Timer? _tick;

  @override
  void initState() {
    super.initState();
    _tick = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _tick?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final limit =
        ref.watch(sessionProvider).value?.settings.sessionLimitMinutes ?? 0;
    if (_hidden || limit <= 0) {
      return const SizedBox.shrink();
    }
    final elapsed = DateTime.now().difference(_started);
    if (elapsed.inMinutes < limit) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.only(top: SproutSpace.md),
      child: SproutCard(
        color: SproutColors.englishSurface,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Time for a break soon',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: SproutSpace.sm),
            Text(
              'A grown-up chose a gentle stop after $limit minutes in SproutLab. Finish what you started, then rest. This does not control other apps.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: SproutSpace.md),
            SecondaryKidButton(
              label: 'Keep playing',
              onPressed: () => setState(() => _hidden = true),
            ),
          ],
        ),
      ),
    );
  }
}
