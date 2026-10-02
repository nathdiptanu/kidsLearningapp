enum ReminderScheduleResult { scheduled, denied, unavailable }

/// Local notification boundary. Game code never schedules reminders.
abstract class LearningReminderPort {
  /// Asks for notification permission, then schedules one daily reminder.
  Future<ReminderScheduleResult> enableDaily(int minutesFromMidnight);

  Future<void> cancel();

  /// Keeps a single inexact daily reminder in step with the saved time.
  /// Does not request permission. Returns false when a saved reminder
  /// cannot be scheduled.
  Future<bool> sync({required bool enabled, required int minutesFromMidnight});
}

class NoopLearningReminderPort implements LearningReminderPort {
  const NoopLearningReminderPort();

  @override
  Future<ReminderScheduleResult> enableDaily(int minutesFromMidnight) async {
    return ReminderScheduleResult.unavailable;
  }

  @override
  Future<void> cancel() async {}

  @override
  Future<bool> sync({
    required bool enabled,
    required int minutesFromMidnight,
  }) async {
    return true;
  }
}
