import '../../../app/app_identity.dart';
import '../../../domain/models/content_pack.dart';
import '../../../domain/models/game_category.dart';

class ContentValidation {
  const ContentValidation({
    required this.usable,
    required this.playable,
    required this.issues,
  });

  final bool usable;
  final List<BundledActivity> playable;
  final List<String> issues;
}

class ContentValidator {
  const ContentValidator();

  static const supportedSchemaVersion = 1;

  ContentValidation validate(
    ContentPackManifest manifest, {
    String appVersion = AppIdentity.appVersion,
  }) {
    final issues = <String>[];
    if (manifest.packId.trim().isEmpty) {
      issues.add('missing pack id');
    }
    if (manifest.schemaVersion != supportedSchemaVersion) {
      issues.add('unsupported schema');
    }
    if (manifest.contentVersion < 1) {
      issues.add('invalid content version');
    }
    if (!_versionAllows(appVersion, manifest.minimumAppVersion)) {
      issues.add('app version is below the pack requirement');
    }

    final seen = <String>{};
    final playable = <BundledActivity>[];
    var usable = issues.isEmpty;
    for (final activity in manifest.activities) {
      if (activity.id.trim().isEmpty || seen.contains(activity.id)) {
        usable = false;
        issues.add('duplicate or missing activity id');
        continue;
      }
      seen.add(activity.id);
      final activityIssues = _activityIssues(activity);
      if (activityIssues.isNotEmpty) {
        issues.add('${activity.id} skipped: ${activityIssues.join(', ')}');
        continue;
      }
      if (activity.reviewStatus == ReviewStatus.approved) {
        playable.add(activity);
      }
    }

    return ContentValidation(
      usable: usable,
      playable: playable,
      issues: issues,
    );
  }

  List<String> _activityIssues(BundledActivity activity) {
    final issues = <String>[];
    if (GameCategory.fromStorage(activity.engine) == null) {
      issues.add('unknown engine');
    }
    if (SkillArea.fromStorage(activity.skill) == null) {
      issues.add('unknown skill');
    }
    if (activity.difficulty < 1) {
      issues.add('invalid difficulty');
    }
    if (activity.ageBands.isEmpty) {
      issues.add('missing age band');
    }
    return issues;
  }

  bool _versionAllows(String appVersion, String? minimumAppVersion) {
    if (minimumAppVersion == null || minimumAppVersion.isEmpty) {
      return true;
    }
    final app = _parseVersion(appVersion);
    final minimum = _parseVersion(minimumAppVersion);
    if (app == null || minimum == null) {
      return false;
    }
    for (var index = 0; index < 3; index++) {
      if (app[index] != minimum[index]) {
        return app[index] > minimum[index];
      }
    }
    return true;
  }

  List<int>? _parseVersion(String value) {
    final parts = value.split('.');
    if (parts.length != 3) {
      return null;
    }
    final numbers = <int>[];
    for (final part in parts) {
      final parsed = int.tryParse(part);
      if (parsed == null || parsed < 0) {
        return null;
      }
      numbers.add(parsed);
    }
    return numbers;
  }
}
