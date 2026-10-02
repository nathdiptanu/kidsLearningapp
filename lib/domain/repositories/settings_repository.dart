import '../settings/local_settings.dart';

abstract interface class SettingsRepository {
  Future<LocalSettings> load();

  Future<void> save(LocalSettings settings);
}
