import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/session_providers.dart';
import '../../core/design_system/sprout_tokens.dart';
import '../../core/design_system/widgets/sprout_card.dart';
import '../../core/design_system/widgets/status_chip.dart';
import '../../domain/lessons/lesson_catalog.dart';
import '../../domain/lessons/lesson_models.dart';
import '../../domain/models/age_band.dart';
import '../../domain/models/content_pack.dart';
import '../../domain/monetization/free_entitlement_policy.dart';
import '../../domain/regional/regional_availability.dart';
import '../../features/play/activity_access.dart';
import '../../features/play/open_activity.dart';

class LessonLane extends ConsumerWidget {
  const LessonLane({required this.lessons, this.title = 'Lessons', super.key});

  final List<LessonRecord> lessons;
  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (lessons.isEmpty) {
      return const SizedBox.shrink();
    }
    final text = Theme.of(context).textTheme;
    final progress = ref.watch(progressListProvider).value ?? const [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(title, style: text.titleMedium),
        const SizedBox(height: 12),
        for (final lesson in lessons) ...[
          _LessonRow(
            lesson: lesson,
            completed: progress.any(
              (row) => row.activityId == lesson.id && row.completed,
            ),
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _LessonRow extends ConsumerWidget {
  const _LessonRow({required this.lesson, required this.completed});

  final LessonRecord lesson;
  final bool completed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = Theme.of(context).textTheme;
    final profile = ref.watch(sessionProvider).value?.profile;
    final band = profile?.ageBand ?? AgeBand.c;
    final activity = LessonCatalog().definition(lesson, band);
    return Semantics(
      button: true,
      label: '${lesson.title}. ${lesson.prompt}',
      child: TappableCard(
        onTap: () {
          openActivity(
            context,
            ActivityAccess(
              activity: activity,
              access: LevelAccess.playNew,
              record: null,
            ),
          );
        },
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(lesson.title, style: text.titleMedium),
                  Text(
                    lesson.displayText,
                    style: text.headlineSmall?.copyWith(
                      fontFamilyFallback: SproutType.fallback,
                      height: SproutType.devanagariHeight,
                    ),
                  ),
                ],
              ),
            ),
            StatusChip(
              label: lesson.reviewStatus == ReviewStatus.approved
                  ? completed
                        ? 'Play again'
                        : lesson.mode.name
                  : 'Sample',
              tone: completed ? StatusTone.done : StatusTone.info,
            ),
          ],
        ),
      ),
    );
  }
}

List<LessonRecord> hindiLessonsForSession({
  required WidgetRef ref,
  RegionalModule module = RegionalModule.hindi,
}) {
  final session = ref.watch(sessionProvider).value;
  final settings = session?.settings;
  final profile = session?.profile;
  if (settings == null || profile == null) {
    return const [];
  }
  return LessonCatalog().forModule(
    module: module,
    settings: settings,
    band: profile.ageBand,
    readiness: profile.readiness,
    includeDrafts: includeDevelopmentSamples(),
  );
}

List<LessonRecord> englishLetterLessonsForSession(WidgetRef ref) {
  final profile = ref.watch(sessionProvider).value?.profile;
  if (profile == null) {
    return const [];
  }
  return LessonCatalog().englishLetters(
    band: profile.ageBand,
    readiness: profile.readiness,
    includeDrafts: includeDevelopmentSamples(),
  );
}
