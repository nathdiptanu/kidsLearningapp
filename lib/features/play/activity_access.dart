import 'package:flutter/material.dart';

import '../../core/design_system/sprout_tokens.dart';
import '../../core/design_system/widgets/app_page_scaffold.dart';
import '../../core/design_system/widgets/fox_mascot.dart';
import '../../core/design_system/widgets/primary_kid_button.dart';
import '../../core/design_system/widgets/sprout_card.dart';
import '../../core/design_system/widgets/status_chip.dart';
import '../../domain/games/play/activity_definition.dart';
import '../../domain/models/game_category.dart';
import '../../domain/monetization/free_entitlement_policy.dart';
import '../../domain/progress/activity_record.dart';
import '../parent/premium_screen.dart';

class ActivityAccess {
  const ActivityAccess({
    required this.activity,
    required this.access,
    required this.record,
  });

  final ActivityDefinition activity;
  final LevelAccess access;
  final ActivityRecord? record;
}

int freeCompletedCount(List<ActivityRecord> records, GameCategory category) {
  return records
      .where(
        (record) =>
            record.engineType == category.storageKey &&
            record.countedAsFree &&
            record.completed,
      )
      .length;
}

ActivityRecord? recordFor(List<ActivityRecord> records, String activityId) {
  for (final record in records) {
    if (record.activityId == activityId) {
      return record;
    }
  }
  return null;
}

ActivityAccess accessFor({
  required ActivityDefinition activity,
  required List<ActivityRecord> records,
  required bool premiumActive,
  Set<String> startedActivityIds = const {},
}) {
  final record = recordFor(records, activity.id);
  final completed = record?.completed ?? false;
  final access = const FreeEntitlementPolicy().decide(
    premiumActive: premiumActive,
    alreadyStarted: !completed && startedActivityIds.contains(activity.id),
    alreadyCompleted: completed,
    uniqueFreeLevelsCompleted: freeCompletedCount(records, activity.category),
  );
  return ActivityAccess(activity: activity, access: access, record: record);
}

ActivityDefinition? nextOpenActivity({
  required List<ActivityDefinition> activities,
  required List<ActivityRecord> records,
  required bool premiumActive,
}) {
  ActivityDefinition? replay;
  for (final activity in activities) {
    final decision = accessFor(
      activity: activity,
      records: records,
      premiumActive: premiumActive,
    );
    if (decision.access == LevelAccess.playNew ||
        decision.access == LevelAccess.continueInProgress) {
      return activity;
    }
    if (decision.access == LevelAccess.replay && replay == null) {
      replay = activity;
    }
  }
  return replay;
}

class LockedActivityScreen extends StatelessWidget {
  const LockedActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Locked')),
      body: SafeArea(
        top: false,
        child: PageWidth(
          child: ListView(
            padding: const EdgeInsets.all(SproutSpace.page),
            children: [
              const Center(child: FoxMascot(size: 130)),
              const SizedBox(height: SproutSpace.md),
              SproutCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: StatusChip(
                        label: 'Locked',
                        tone: StatusTone.locked,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'This new activity is locked.',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: SproutSpace.md),
                    Text(
                      'The free new activities in this game are already finished. You can play again any activity you already finished.',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: SproutSpace.sm),
                    Text(
                      'A grown-up can look at more activities. This screen does not start a purchase.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: SproutSpace.lg),
                    PrimaryKidButton(
                      label: 'Ask a grown-up',
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (context) => const PremiumScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    SecondaryKidButton(
                      label: 'Back',
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
