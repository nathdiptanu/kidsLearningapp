import '../../core/errors/app_failure.dart';
import '../models/age_band.dart';
import '../models/child_profile.dart';
import '../models/readiness.dart';

abstract interface class ProfileRepository {
  /// Engineering bound so the parent list stays short. Not a product rule.
  static const maxProfiles = 6;

  Future<ChildProfile?> getActiveProfile();

  /// Oldest first.
  Future<List<ChildProfile>> listProfiles();

  /// First profile only. Throws when an active profile already exists.
  Future<ChildProfile> createProfile({
    required String avatarId,
    required AgeBand ageBand,
    String? nickname,
  });

  /// Adds another child and makes them active. Other profiles keep their data.
  Future<ChildProfile> addProfile({
    required String avatarId,
    required AgeBand ageBand,
    String? nickname,
    Readiness readiness = Readiness.steady,
  });

  /// Makes [profileId] the only active profile. Nothing is deleted.
  Future<ChildProfile> switchTo(int profileId);

  Future<ChildProfile> updateActiveProfile({
    required String avatarId,
    required AgeBand ageBand,
    String? nickname,
    Readiness? readiness,
  });
}

/// Optional local nickname. Empty input is stored as absent.
/// 24 characters is an engineering display bound, not a product rule.
String? normalizeNickname(String? nickname) {
  if (nickname == null) {
    return null;
  }
  final trimmed = nickname.trim();
  if (trimmed.isEmpty) {
    return null;
  }
  if (trimmed.length > 24) {
    throw const InvalidProfileInputFailure();
  }
  return trimmed;
}
