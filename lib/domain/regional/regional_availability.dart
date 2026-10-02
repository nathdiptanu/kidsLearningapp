import '../settings/local_settings.dart';
import 'learning_preferences.dart';

/// Modules that are only offered for one learning region.
enum RegionalModule {
  hindi('hindi', LearningRegion.india),
  discoverIndia('discover_india', LearningRegion.india);

  const RegionalModule(this.storageKey, this.region);

  /// Prefix for future activity and progress ids. Do not rename.
  final String storageKey;
  final LearningRegion region;
}

/// The single rule for whether a regional module may be shown or opened.
/// Explore, any future search or deep link, and the module screens all ask
/// this. Hiding a module never deletes its progress.
abstract final class RegionalAvailability {
  static bool isAvailable(LocalSettings settings, RegionalModule module) {
    if (settings.learningRegion != module.region) {
      return false;
    }
    return switch (module) {
      RegionalModule.hindi => settings.hindiEnabled,
      RegionalModule.discoverIndia => settings.discoverIndiaEnabled,
    };
  }

  static List<RegionalModule> available(LocalSettings settings) {
    return [
      for (final module in RegionalModule.values)
        if (isAvailable(settings, module)) module,
    ];
  }
}
