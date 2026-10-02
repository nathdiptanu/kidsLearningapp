import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/session_providers.dart';
import '../../core/design_system/widgets/sprout_card.dart';
import '../../core/design_system/widgets/status_chip.dart';
import '../../domain/geography/geography_catalog.dart';
import '../../domain/geography/geography_models.dart';
import '../../domain/lessons/lesson_models.dart';
import '../../domain/models/age_band.dart';
import '../../domain/models/content_pack.dart';
import '../../domain/monetization/free_entitlement_policy.dart';
import '../../domain/regional/regional_availability.dart';
import '../play/activity_access.dart';
import '../play/open_activity.dart';

class GeographyLane extends ConsumerWidget {
  const GeographyLane({
    required this.activities,
    this.title = 'Places',
    super.key,
  });

  final List<GeographyActivity> activities;
  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (activities.isEmpty) {
      return const SizedBox.shrink();
    }
    final text = Theme.of(context).textTheme;
    final progress = ref.watch(progressListProvider).value ?? const [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(title, style: text.titleMedium),
        const SizedBox(height: 12),
        for (final activity in activities) ...[
          _GeoRow(
            activity: activity,
            completed: progress.any(
              (row) => row.activityId == activity.id && row.completed,
            ),
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _GeoRow extends ConsumerWidget {
  const _GeoRow({required this.activity, required this.completed});

  final GeographyActivity activity;
  final bool completed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = Theme.of(context).textTheme;
    final profile = ref.watch(sessionProvider).value?.profile;
    final band = profile?.ageBand ?? AgeBand.c;
    final definition = GeographyCatalog().definition(activity, band);
    return Semantics(
      button: true,
      label: '${activity.title}. ${activity.prompt}',
      child: TappableCard(
        onTap: () {
          openActivity(
            context,
            ActivityAccess(
              activity: definition,
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
                  Text(activity.title, style: text.titleMedium),
                  Text(activity.prompt, style: text.bodyMedium),
                ],
              ),
            ),
            StatusChip(
              label: activity.reviewStatus == ReviewStatus.approved
                  ? completed
                        ? 'Play again'
                        : activity.mode.name
                  : 'Sample',
              tone: completed ? StatusTone.done : StatusTone.info,
            ),
          ],
        ),
      ),
    );
  }
}

List<GeographyActivity> discoverIndiaActivitiesForSession(WidgetRef ref) {
  final session = ref.watch(sessionProvider).value;
  final settings = session?.settings;
  final profile = session?.profile;
  if (settings == null || profile == null) {
    return const [];
  }
  if (!RegionalAvailability.isAvailable(
    settings,
    RegionalModule.discoverIndia,
  )) {
    return const [];
  }
  final progress = ref.watch(progressListProvider).value ?? const [];
  return GeographyCatalog().visible(
    settings: settings,
    band: profile.ageBand,
    readiness: profile.readiness,
    includeDrafts: includeDevelopmentSamples(),
    introducedPlaceIds: introducedPlacesFrom([
      for (final row in progress)
        if (row.completed) row.activityId,
    ]),
  );
}
