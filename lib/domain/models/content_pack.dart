enum ReviewStatus {
  approved,
  placeholder,
  rejected;

  static ReviewStatus? fromStorage(String value) {
    return switch (value) {
      'APPROVED' => ReviewStatus.approved,
      'PLACEHOLDER' => ReviewStatus.placeholder,
      'REJECTED' => ReviewStatus.rejected,
      _ => null,
    };
  }
}

class BundledActivity {
  const BundledActivity({
    required this.id,
    required this.engine,
    required this.skill,
    required this.difficulty,
    required this.ageBands,
    required this.premium,
    required this.contentVersion,
    required this.reviewStatus,
  });

  final String id;
  final String engine;
  final String skill;
  final int difficulty;
  final List<String> ageBands;
  final bool premium;
  final int contentVersion;
  final ReviewStatus reviewStatus;
}

class ContentPackManifest {
  const ContentPackManifest({
    required this.packId,
    required this.schemaVersion,
    required this.contentVersion,
    required this.minimumAppVersion,
    required this.reviewStatus,
    required this.activities,
  });

  final String packId;
  final int schemaVersion;
  final int contentVersion;
  final String? minimumAppVersion;
  final ReviewStatus reviewStatus;
  final List<BundledActivity> activities;
}
