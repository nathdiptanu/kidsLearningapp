import '../adaptive/local_date.dart';
import '../models/game_category.dart';

class SkillPractice {
  const SkillPractice({
    required this.skillId,
    required this.attempts,
    required this.firstTry,
    required this.hintAssisted,
    required this.incorrect,
    required this.difficulty,
    required this.recentOutcomes,
  });

  final String skillId;
  final int attempts;
  final int firstTry;
  final int hintAssisted;
  final int incorrect;
  final int difficulty;
  final String recentOutcomes;
}

class RecentPractice {
  const RecentPractice({
    required this.activityId,
    required this.title,
    required this.engine,
    required this.attempts,
    required this.stars,
    required this.playedAt,
  });

  final String activityId;
  final String title;
  final String engine;
  final int attempts;
  final int stars;
  final int playedAt;
}

class ParentReport {
  const ParentReport({
    required this.practicedToday,
    required this.practicedThisWeek,
    required this.finishedActivities,
    required this.timesPlayed,
    required this.learningDays,
    required this.totalStars,
    required this.categoryCounts,
    required this.skills,
    required this.recent,
    this.learningNotes = const [],
  });

  final int practicedToday;
  final int practicedThisWeek;
  final int finishedActivities;
  final int timesPlayed;
  final int learningDays;
  final int totalStars;
  final Map<String, int> categoryCounts;
  final List<SkillPractice> skills;
  final List<RecentPractice> recent;
  final List<String> learningNotes;

  static const disclaimer =
      'These notes describe practice in this app. They are not a diagnosis, a school mark, or a formal assessment. They are not an IQ score and they do not compare this child with other children.';
}

String skillTitle(String skillId) {
  return switch (skillId) {
    'maths' => 'Maths',
    'english' => 'English',
    'logic' => 'Logic',
    'observation' => 'Observation',
    'knowledge' => 'Knowledge',
    _ => skillId,
  };
}

/// Uses stored counts only. It does not invent a percentage or a trend line.
String skillSummary(SkillPractice skill) {
  if (skill.attempts <= 0) {
    return 'No finished practice yet.';
  }
  final recent = _recentPhrase(skill.recentOutcomes);
  final volume =
      '${skill.attempts} finished ${skill.attempts == 1 ? 'activity' : 'activities'}. '
      '${skill.firstTry} were correct on the first try. '
      '${skill.hintAssisted} used a hint. '
      'Current difficulty is ${skill.difficulty}.';
  if (skill.attempts < 3) {
    return '$volume Only a little practice is saved so far. $recent';
  }
  if (skill.firstTry > skill.hintAssisted) {
    return '$volume First-try answers are common in this skill. $recent';
  }
  if (skill.hintAssisted > skill.firstTry) {
    return '$volume More practice at this difficulty is useful. $recent';
  }
  return '$volume $recent';
}

String _recentPhrase(String recentOutcomes) {
  if (recentOutcomes.isEmpty) {
    return 'No recent result series is stored.';
  }
  final letters = recentOutcomes.split(',').where((item) => item.isNotEmpty);
  var first = 0;
  var retry = 0;
  var hint = 0;
  for (final letter in letters) {
    switch (letter) {
      case 'F':
        first += 1;
      case 'R':
        retry += 1;
      case 'H':
        hint += 1;
    }
  }
  return 'Latest saved results: $first first-try, $retry retry, $hint hint.';
}

int practicedOnDay(Iterable<int> playedAtMillis, DateTime day) {
  final key = localDateKey(day);
  var count = 0;
  for (final millis in playedAtMillis) {
    final played = DateTime.fromMillisecondsSinceEpoch(millis);
    if (localDateKey(played) == key) {
      count += 1;
    }
  }
  return count;
}

int practicedSince(Iterable<int> playedAtMillis, DateTime start) {
  final threshold = start.millisecondsSinceEpoch;
  var count = 0;
  for (final millis in playedAtMillis) {
    if (millis >= threshold) {
      count += 1;
    }
  }
  return count;
}

String categoryLabel(String engine) {
  return switch (GameCategory.fromStorage(engine)) {
    GameCategory.maths => 'Maths',
    GameCategory.vocabulary => 'Words',
    GameCategory.pattern => 'Patterns',
    GameCategory.maze => 'Mazes',
    GameCategory.matching => 'Matching',
    GameCategory.findDifference => 'Spot the difference',
    GameCategory.findObjects => 'Find objects',
    GameCategory.knowledge => 'Knowledge',
    GameCategory.ticTacToe => 'Tic-Tac-Toe',
    GameCategory.hindi => 'Hindi',
    GameCategory.discoverIndia => 'Discover India',
    null => engine,
  };
}
