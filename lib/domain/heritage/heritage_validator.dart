import '../models/content_pack.dart';
import 'heritage_models.dart';

class HeritagePackValidator {
  const HeritagePackValidator();

  List<String> validate(HeritagePack pack, {required bool release}) {
    final issues = <String>[];
    final ids = <String>{};
    for (final site in pack.sites.values) {
      if (!ids.add(site.id)) {
        issues.add('duplicate site ${site.id}');
      }
      if (site.fact.text.trim().isEmpty || site.fact.sourceUrl.trim().isEmpty) {
        issues.add('${site.id} fact needs text and a source');
      }
      if (site.fact.verifiedAt.trim().isEmpty) {
        issues.add('${site.id} fact needs a verification date');
      }
      if (site.story.isEmpty) {
        issues.add('${site.id} missing story lines');
      }
      for (final line in site.story) {
        if (line.sourceUrl.trim().isEmpty || line.verifiedAt.trim().isEmpty) {
          issues.add('${site.id} story line needs a source and date');
        }
      }
      if (release && !site.releaseReady) {
        issues.add('${site.id} is not approved for release');
      }
    }
    for (final activity in pack.activities) {
      if (activity.siteId != null && pack.sites[activity.siteId] == null) {
        issues.add('${activity.id} points at an unknown site');
      }
      if (activity.mode == HeritageMode.recall) {
        final stories = pack.activities.where(
          (item) => item.mode == HeritageMode.story,
        );
        if (stories.isEmpty) {
          issues.add('${activity.id} has no stories to review');
        }
      }
      if (release && !activity.releaseReady) {
        issues.add('${activity.id} is not approved for release');
      }
    }
    if (release && pack.reviewStatus != ReviewStatus.approved) {
      issues.add('pack ${pack.packId} is not approved for release');
    }
    return issues;
  }

  List<HeritageActivity> playable(HeritagePack pack, {required bool release}) {
    if (release) {
      return [
        for (final activity in pack.activities)
          if (activity.releaseReady) activity,
      ];
    }
    return pack.activities;
  }
}
