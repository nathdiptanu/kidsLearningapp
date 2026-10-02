class GeneratedInstance {
  const GeneratedInstance({
    required this.generatorType,
    required this.generatorVersion,
    required this.seed,
    required this.skillId,
  });

  final String generatorType;
  final String generatorVersion;
  final int seed;
  final String skillId;

  /// Reproducible identity. This is not the free-level activity id.
  String get id => '$generatorVersion:$skillId:seed_$seed';
}

const recentGeneratedLimit = 12;
