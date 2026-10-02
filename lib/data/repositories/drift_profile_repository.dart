import 'package:drift/drift.dart';

import '../../../core/errors/app_failure.dart';
import '../../../domain/models/age_band.dart';
import '../../../domain/models/child_profile.dart' as model;
import '../../../domain/repositories/profile_repository.dart';
import '../local/database/app_database.dart';

class DriftProfileRepository implements ProfileRepository {
  DriftProfileRepository(this._database);

  final AppDatabase _database;

  static final _avatarPattern = RegExp(r'^[a-z0-9_]{1,64}$');

  @override
  Future<model.ChildProfile> createProfile({
    required String avatarId,
    required AgeBand ageBand,
    String? nickname,
  }) async {
    if (!_avatarPattern.hasMatch(avatarId)) {
      throw const InvalidProfileInputFailure();
    }
    final normalizedNickname = normalizeNickname(nickname);
    final existing = await getActiveProfile();
    if (existing != null) {
      throw const ProfileAlreadyExistsFailure();
    }
    final id = await _database
        .into(_database.childProfiles)
        .insert(
          ChildProfilesCompanion.insert(
            avatarId: avatarId,
            ageBand: ageBand.storageKey,
            createdAt: DateTime.now().millisecondsSinceEpoch,
            nickname: Value(normalizedNickname),
            active: const Value(true),
          ),
        );
    final created = await getActiveProfile();
    if (created == null || created.id != id) {
      throw const DatabaseFailure();
    }
    return created;
  }

  @override
  Future<model.ChildProfile?> getActiveProfile() async {
    final row = await (_database.select(
      _database.childProfiles,
    )..where((table) => table.active.equals(true))).getSingleOrNull();
    if (row == null) {
      return null;
    }
    final ageBand = AgeBand.fromStorage(row.ageBand);
    if (ageBand == null) {
      throw const DatabaseFailure();
    }
    return model.ChildProfile(
      id: row.id,
      nickname: row.nickname,
      avatarId: row.avatarId,
      ageBand: ageBand,
      createdAtMillis: row.createdAt,
      active: row.active,
    );
  }

  @override
  Future<model.ChildProfile> updateActiveProfile({
    required String avatarId,
    required AgeBand ageBand,
    String? nickname,
  }) async {
    if (!_avatarPattern.hasMatch(avatarId)) {
      throw const InvalidProfileInputFailure();
    }
    final existing = await getActiveProfile();
    if (existing == null) {
      throw const DatabaseFailure();
    }
    final normalizedNickname = normalizeNickname(nickname);
    await (_database.update(
      _database.childProfiles,
    )..where((table) => table.id.equals(existing.id))).write(
      ChildProfilesCompanion(
        avatarId: Value(avatarId),
        ageBand: Value(ageBand.storageKey),
        nickname: Value(normalizedNickname),
      ),
    );
    final updated = await getActiveProfile();
    if (updated == null) {
      throw const DatabaseFailure();
    }
    return updated;
  }
}
