import '../../core/errors/app_failure.dart';
import '../models/age_band.dart';
import '../models/child_profile.dart';

abstract interface class ProfileRepository {
  Future<ChildProfile?> getActiveProfile();

  Future<ChildProfile> createProfile({
    required String avatarId,
    required AgeBand ageBand,
    String? nickname,
  });

  Future<ChildProfile> updateActiveProfile({
    required String avatarId,
    required AgeBand ageBand,
    String? nickname,
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
