import '../../app/app_identity.dart';

/// One optional daily reminder. The copy has no place for a nickname or score.
abstract final class DailyReminder {
  static const id = 41;
  static const body = 'Ready for a little learning adventure?';

  static String get title => AppIdentity.visibleName;

  static DateTime nextOccurrence(DateTime now, int minutesFromMidnight) {
    final bounded = minutesFromMidnight.clamp(0, (23 * 60) + 59);
    final hour = bounded ~/ 60;
    final minute = bounded % 60;
    final today = DateTime(now.year, now.month, now.day, hour, minute);
    if (today.isAfter(now)) {
      return today;
    }
    return DateTime(now.year, now.month, now.day + 1, hour, minute);
  }
}
