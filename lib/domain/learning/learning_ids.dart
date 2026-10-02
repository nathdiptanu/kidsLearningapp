import '../lessons/lesson_models.dart';
import '../models/game_category.dart';
import 'item_progress.dart';

/// Stable item ids. Activity titles and generated variants do not change these.
String itemIdForLesson(LessonRecord lesson) {
  final parts = lesson.id.split(':');
  final slug = parts.length >= 4 ? parts.sublist(3).join(':') : '';
  if (lesson.category == GameCategory.hindi) {
    return switch (slug) {
      'a' => 'letter-hi-a',
      'aa' => 'letter-hi-aa',
      'anar' => 'word-anar',
      'aam' => 'word-aam',
      _ => 'item-${lesson.displayText}',
    };
  }
  return switch (slug) {
    'a_name' => 'letter-en-a-name',
    'a_sound' => 'letter-en-a-sound',
    'a' => 'letter-en-a-name',
    'q_queen' => 'letter-en-q',
    'cat' => 'word-cat',
    _ => 'item-${lesson.displayText}',
  };
}

PracticeMode practiceModeForLesson(LessonMode mode) {
  return switch (mode) {
    LessonMode.listen => PracticeMode.listen,
    LessonMode.find || LessonMode.match => PracticeMode.recognize,
    LessonMode.trace => PracticeMode.trace,
    LessonMode.build => PracticeMode.build,
    LessonMode.review => PracticeMode.recall,
  };
}

bool lessonIntroduces(LessonMode mode) {
  return mode == LessonMode.listen ||
      mode == LessonMode.find ||
      mode == LessonMode.match;
}
