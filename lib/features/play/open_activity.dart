import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/session_providers.dart';
import '../../domain/games/play/activity_catalog.dart';
import '../../domain/games/play/activity_definition.dart';
import '../../domain/models/game_category.dart';
import '../../domain/monetization/free_entitlement_policy.dart';
import '../../domain/geography/geography_catalog.dart';
import '../../domain/heritage/heritage_catalog.dart';
import '../../domain/lessons/lesson_catalog.dart';
import '../geography/geography_activity_screen.dart';
import '../heritage/heritage_activity_screen.dart';
import '../lessons/lesson_activity_screen.dart';
import 'activity_access.dart';
import 'activity_screen.dart';
import 'difference_screen.dart';
import 'maze_screen.dart';
import 'tic_tac_toe_screen.dart';

var _activityRouteOpen = false;

void openActivity(
  BuildContext context,
  ActivityAccess decision, {
  String? journeyDate,
}) {
  if (_activityRouteOpen) {
    return;
  }
  _activityRouteOpen = true;
  Navigator.of(context)
      .push(
        MaterialPageRoute<void>(
          builder: (context) => decision.access == LevelAccess.locked
              ? const LockedActivityScreen()
              : screenFor(decision.activity, journeyDate: journeyDate),
        ),
      )
      .whenComplete(() {
        _activityRouteOpen = false;
      });
}

Widget screenFor(ActivityDefinition activity, {String? journeyDate}) {
  if (activity.id.startsWith('lesson:')) {
    final lesson = LessonCatalog().byId(activity.id);
    if (lesson != null) {
      return LessonActivityScreen(lesson: lesson, journeyDate: journeyDate);
    }
  }
  if (activity.id.startsWith('geo:')) {
    final geography = GeographyCatalog().byId(activity.id);
    if (geography != null) {
      return GeographyActivityScreen(
        activity: geography,
        journeyDate: journeyDate,
      );
    }
  }
  if (activity.id.startsWith('heritage:')) {
    final heritage = HeritageCatalog().byId(activity.id);
    if (heritage != null) {
      return HeritageActivityScreen(
        activity: heritage,
        journeyDate: journeyDate,
      );
    }
  }
  return switch (activity.category) {
    GameCategory.maze => MazeScreen(
      activity: activity,
      journeyDate: journeyDate,
    ),
    GameCategory.findDifference => DifferenceScreen(
      activity: activity,
      journeyDate: journeyDate,
    ),
    GameCategory.ticTacToe => TicTacToeScreen(
      activity: activity,
      journeyDate: journeyDate,
    ),
    _ => ActivityScreen(activity: activity, journeyDate: journeyDate),
  };
}

Future<void> openNextJourneyActivity(
  BuildContext context,
  WidgetRef ref, {
  required ActivityDefinition activity,
  required String? journeyDate,
}) async {
  if (journeyDate == null) {
    Navigator.of(context).pop();
    return;
  }
  final journey = await ref.read(dailyJourneyProvider.future);
  if (!context.mounted) {
    return;
  }
  final next = journey.nextAfter(activity.id);
  final nextActivity = next == null
      ? null
      : const ActivityCatalog().byId(next.activityId);
  if (nextActivity == null) {
    Navigator.of(context).pop();
    return;
  }
  Navigator.of(context).pushReplacement(
    MaterialPageRoute<void>(
      builder: (context) => screenFor(nextActivity, journeyDate: journeyDate),
    ),
  );
}
