import 'package:drift/drift.dart';

import '../../../core/errors/app_failure.dart';
import '../../../domain/models/age_band.dart';
import '../../../domain/models/child_profile.dart' as model;
import '../../../domain/models/readiness.dart';
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
    final existing = await getActiveProfile();
    if (existing != null) {
      throw const ProfileAlreadyExistsFailure();
    }
    return addProfile(avatarId: avatarId, ageBand: ageBand, nickname: nickname);
  }

  @override
  Future<model.ChildProfile> addProfile({
    required String avatarId,
    required AgeBand ageBand,
    String? nickname,
    Readiness readiness = Readiness.steady,
  }) async {
    if (!_avatarPattern.hasMatch(avatarId)) {
      throw const InvalidProfileInputFailure();
    }
    final normalizedNickname = normalizeNickname(nickname);
    final id = await _database.transaction(() async {
      final count = await _database.childProfiles.count().getSingle();
      if (count >= ProfileRepository.maxProfiles) {
        throw const ProfileLimitFailure();
      }
      await _deactivateAll();
      return _database
          .into(_database.childProfiles)
          .insert(
            ChildProfilesCompanion.insert(
              avatarId: avatarId,
              ageBand: ageBand.storageKey,
              createdAt: DateTime.now().millisecondsSinceEpoch,
              nickname: Value(normalizedNickname),
              active: const Value(true),
              readiness: Value(readiness.storageKey),
            ),
          );
    });
    final created = await getActiveProfile();
    if (created == null || created.id != id) {
      throw const DatabaseFailure();
    }
    return created;
  }

  @override
  Future<model.ChildProfile> switchTo(int profileId) async {
    await _database.transaction(() async {
      final target = await (_database.select(
        _database.childProfiles,
      )..where((table) => table.id.equals(profileId))).getSingleOrNull();
      if (target == null) {
        throw const InvalidProfileInputFailure();
      }
      await _deactivateAll();
      await (_database.update(_database.childProfiles)
            ..where((table) => table.id.equals(profileId)))
          .write(const ChildProfilesCompanion(active: Value(true)));
    });
    final active = await getActiveProfile();
    if (active == null || active.id != profileId) {
      throw const DatabaseFailure();
    }
    return active;
  }

  @override
  Future<model.ChildProfile?> getActiveProfile() async {
    final row = await (_database.select(
      _database.childProfiles,
    )..where((table) => table.active.equals(true))).getSingleOrNull();
    return row == null ? null : _toModel(row);
  }

  @override
  Future<List<model.ChildProfile>> listProfiles() async {
    final rows =
        await (_database.select(_database.childProfiles)..orderBy([
              (table) => OrderingTerm.asc(table.createdAt),
              (table) => OrderingTerm.asc(table.id),
            ]))
            .get();
    return [for (final row in rows) _toModel(row)];
  }

  @override
  Future<model.ChildProfile> updateActiveProfile({
    required String avatarId,
    required AgeBand ageBand,
    String? nickname,
    Readiness? readiness,
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
        readiness: readiness == null
            ? const Value.absent()
            : Value(readiness.storageKey),
      ),
    );
    final updated = await getActiveProfile();
    if (updated == null) {
      throw const DatabaseFailure();
    }
    return updated;
  }

  Future<void> _deactivateAll() {
    return (_database.update(_database.childProfiles)
          ..where((table) => table.active.equals(true)))
        .write(const ChildProfilesCompanion(active: Value(false)));
  }

  model.ChildProfile _toModel(ChildProfile row) {
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
      readiness: Readiness.fromStorage(row.readiness),
    );
  }
}
