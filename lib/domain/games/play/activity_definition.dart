import '../../models/age_band.dart';
import '../../models/game_category.dart';

class ActivityDefinition {
  const ActivityDefinition({
    required this.id,
    required this.category,
    required this.band,
    required this.variant,
    required this.seed,
    required this.title,
    required this.questionCount,
  });

  final String id;
  final GameCategory category;
  final AgeBand band;
  final int variant;
  final int seed;
  final String title;
  final int questionCount;
}
