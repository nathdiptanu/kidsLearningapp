import '../../geography/geography_catalog.dart';
import '../../heritage/heritage_catalog.dart';
import '../../lessons/lesson_catalog.dart';
import '../../models/age_band.dart';
import '../../models/game_category.dart';
import '../find_difference/difference_catalog.dart';
import '../connect_dots/connect_dots_catalog.dart';
import '../find_objects/find_objects_catalog.dart';
import '../knowledge/knowledge_bank.dart';
import '../matching/matching_generator.dart';
import '../maths/maths_generator.dart';
import '../pattern/pattern_generator.dart';
import '../vocabulary/vocabulary_generator.dart';
import 'activity_definition.dart';
import 'play_question.dart';
import '../../regional/explorer_content.dart';
import '../../regional/india_learning_content.dart';

/// Stable catalog size for one age band. Tic-Tac-Toe is listed, but it is
/// not part of the five learning-section totals.
int activitiesInBand(GameCategory category) {
  return switch (category) {
    GameCategory.maths => 105,
    GameCategory.vocabulary => 88,
    GameCategory.knowledge => 75,
    GameCategory.pattern => 85,
    GameCategory.maze => 100,
    GameCategory.matching => 69,
    GameCategory.findDifference => differenceScenes.length,
    GameCategory.findObjects => findObjectScenes.length,
    GameCategory.connectDots => 50,
    GameCategory.ticTacToe => 5,
    GameCategory.hindi || GameCategory.discoverIndia => 0,
  };
}

/// Activity ids stay on the catalog slot. A new generator seed must not
/// create another free level.
class ActivityCatalog {
  const ActivityCatalog();

  List<ActivityDefinition> forBand(GameCategory category, AgeBand band) {
    if (band == AgeBand.toddler) {
      if (category != GameCategory.matching) return const [];
      return List.generate(
        6,
        (variant) => _definition(category, band, variant),
      );
    }
    return List.generate(
      activitiesInBand(category),
      (variant) => _definition(category, band, variant),
    );
  }

  ActivityDefinition _definition(
    GameCategory category,
    AgeBand band,
    int variant,
  ) {
    return ActivityDefinition(
      id: '${category.storageKey}:v1:${band.storageKey}:$variant',
      category: category,
      band: band,
      variant: variant,
      seed: seedFor(band, variant),
      title: _title(category, band, variant),
      questionCount: band == AgeBand.toddler
          ? 1
          : switch (category) {
              GameCategory.matching => 2,
              GameCategory.maze ||
              GameCategory.findDifference ||
              GameCategory.findObjects ||
              GameCategory.connectDots ||
              GameCategory.knowledge ||
              GameCategory.ticTacToe ||
              GameCategory.hindi ||
              GameCategory.discoverIndia => 1,
              _ => 3,
            },
    );
  }

  List<ActivityDefinition> playableFor(AgeBand band) {
    return [
      for (final category in GameCategory.values)
        if (category != GameCategory.ticTacToe) ...forBand(category, band),
    ];
  }

  List<ActivityDefinition> all() {
    return [
      for (final band in AgeBand.values)
        for (final category in GameCategory.values) ...forBand(category, band),
    ];
  }

  /// Parses `category:v1:band:variant` instead of scanning the catalog.
  ActivityDefinition? byId(String id) {
    final india = indiaQuestionByActivityId(id);
    if (india != null) {
      return ActivityDefinition(
        id: id,
        category: GameCategory.discoverIndia,
        band: AgeBand.c,
        variant: 0,
        seed: 0,
        title: india.prompt,
        questionCount: 1,
      );
    }
    final item = explorerItemById(id);
    if (item != null) {
      return ActivityDefinition(
        id: id,
        category: item.hindi ? GameCategory.hindi : GameCategory.discoverIndia,
        band: AgeBand.c,
        variant: 0,
        seed: 0,
        title: item.title,
        questionCount: 1,
      );
    }
    final lesson = LessonCatalog().definitionById(id, AgeBand.c);
    if (lesson != null) {
      return lesson;
    }
    final geography = GeographyCatalog().definitionById(id, AgeBand.c);
    if (geography != null) {
      return geography;
    }
    final heritage = HeritageCatalog().definitionById(id, AgeBand.c);
    if (heritage != null) {
      return heritage;
    }
    final parts = id.split(':');
    if (parts.length != 4 || parts[1] != 'v1') {
      return null;
    }
    final category = GameCategory.fromStorage(parts[0]);
    final band = AgeBand.fromStorage(parts[2]);
    final variant = int.tryParse(parts[3]);
    if (category == null ||
        band == null ||
        variant == null ||
        variant < 0 ||
        variant >= activitiesInBand(category) ||
        '$variant' != parts[3]) {
      return null;
    }
    return _definition(category, band, variant);
  }

  List<PlayQuestion> questionsFor(ActivityDefinition activity) {
    return switch (activity.category) {
      GameCategory.maths => const MathsGenerator().generate(
        band: activity.band,
        seed: activity.seed,
        variant: activity.variant,
        count: activity.questionCount,
      ),
      GameCategory.pattern => const PatternGenerator().generate(
        band: activity.band,
        seed: activity.seed,
        variant: activity.variant,
        count: activity.questionCount,
      ),
      GameCategory.matching => const MatchingGenerator().generate(
        band: activity.band,
        variant: activity.variant,
        count: activity.questionCount,
      ),
      GameCategory.vocabulary => const VocabularyGenerator().generate(
        band: activity.band,
        seed: activity.seed,
        variant: activity.variant,
        count: activity.questionCount,
      ),
      GameCategory.knowledge => const KnowledgeGenerator().generate(
        band: activity.band,
        seed: activity.seed,
        variant: activity.variant,
      ),
      GameCategory.maze ||
      GameCategory.findDifference ||
      GameCategory.findObjects ||
      GameCategory.connectDots ||
      GameCategory.ticTacToe ||
      GameCategory.hindi ||
      GameCategory.discoverIndia => const [],
    };
  }

  /// Lists show the level number next to this name, so names are not
  /// numbered here.
  String _title(GameCategory category, AgeBand band, int variant) {
    if (band == AgeBand.toddler) return 'Match the picture together';
    return switch (category) {
      GameCategory.maths => _mathsTitle(band, variant),
      GameCategory.pattern => _patternTitle(variant),
      GameCategory.matching => 'Which one does not belong?',
      GameCategory.maze => _mazeTitle(variant),
      GameCategory.vocabulary => _vocabTitle(band, variant),
      GameCategory.findDifference =>
        const DifferenceCatalog().sceneFor(variant).title,
      GameCategory.findObjects =>
        const FindObjectsCatalog().sceneFor(variant).title,
      GameCategory.connectDots => connectDotsTitle(variant),
      GameCategory.knowledge => _knowledgeTitle(band, variant),
      GameCategory.ticTacToe => _ticTitle(variant),
      GameCategory.hindi => 'Hindi',
      GameCategory.discoverIndia => 'Discover India',
    };
  }

  String _knowledgeTitle(AgeBand band, int variant) {
    final facts = knowledgeFactsFor(band);
    return facts[variant % facts.length].prompt;
  }

  String _patternTitle(int variant) {
    return variant.isEven ? 'What comes next?' : 'Finish the pattern';
  }

  String _ticTitle(int variant) {
    return switch (variant % 5) {
      0 => 'Crosses and circles',
      1 => 'A guided game',
      2 => 'A harder game',
      3 => 'Your turn next',
      _ => 'Finish the line',
    };
  }

  String _vocabTitle(AgeBand band, int variant) {
    if (band == AgeBand.a) {
      return variant.isEven ? 'Match the picture' : 'Find this picture';
    }
    if (variant >= 38) {
      return 'Words that build a sentence';
    }
    return switch (variant % 3) {
      0 => 'Match the picture',
      1 => 'Find this picture',
      _ => 'Starting letter',
    };
  }

  String _mazeTitle(int variant) {
    if (variant >= 50) {
      return const [
        'A longer garden path',
        'Through the flower beds',
        'Past the quiet pond',
        'Along the hedge',
        'A hidden garden corner',
        'The winding petal trail',
      ][(variant - 50) % 6];
    }
    if (variant >= 38) {
      return const [
        'The rainbow trail',
        'A sunny garden stroll',
        'Bluebell adventure',
        'Find the berry blossom',
        'Through the twinkle garden',
        'Flower friends',
        'A cheerful little journey',
        'The butterfly path',
        'A meadow surprise',
        'Around the garden',
        'Follow your curiosity',
        'Blossom adventure',
      ][variant - 38];
    }
    return const [
      'A short path',
      'Follow the path',
      'A winding path',
      'Reach the flower',
      'A bigger maze',
      'One more path',
    ][variant % 6];
  }

  String _mathsTitle(AgeBand band, int variant) {
    final titles = switch (band) {
      AgeBand.a || AgeBand.toddler => const [
        'Count the leaves',
        'Count the group',
        'Which has more?',
        'Compare pebbles',
        'Match the number',
        'How many?',
      ],
      AgeBand.b => const [
        'Count the group',
        'Which has more?',
        'Add one or two',
        'Add a little more',
        'Missing number',
        'Number order',
      ],
      AgeBand.c => const [
        'Add two numbers',
        'Take away',
        'Number pattern',
        'Times in groups',
        'Share equally',
        'Equal groups',
      ],
      AgeBand.d => const [
        'Add in your head',
        'Take away in your head',
        'Equal groups',
        'Times tables',
        'Share equally',
        'Number pattern',
      ],
    };
    return titles[variant % titles.length];
  }
}

/// Keeps the original six seeds. Later slots use a separate seed range.
int seedFor(AgeBand band, int variant) {
  if (variant < 6) {
    return (band.index + 1) * 100 + variant + 1;
  }
  return (band.index + 1) * 1000 + variant * 31 + 7;
}
