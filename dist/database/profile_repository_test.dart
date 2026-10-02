import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sproutlab/core/errors/app_failure.dart';
import 'package:sproutlab/data/local/database/app_database.dart';
import 'package:sproutlab/data/repositories/drift_entitlement_repository.dart';
import 'package:sproutlab/data/repositories/drift_profile_repository.dart';
import 'package:sproutlab/domain/models/age_band.dart';
import 'package:sproutlab/domain/models/entitlement_snapshot.dart';

void main() {
  late AppDatabase database;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await database.close();
  });

  test('schema version is 9', () {
    expect(database.schemaVersion, 9);
  });

  test('one profile can be saved and read back', () async {
    final repository = DriftProfileRepository(database);
    expect(await repository.getActiveProfile(), isNull);
    final profile = await repository.createProfile(
      avatarId: 'avatar_01',
      ageBand: AgeBand.b,
      nickname: '  Mini  ',
    );
    expect(profile.nickname, 'Mini');
    expect(profile.ageBand, AgeBand.b);
    expect(profile.active, isTrue);

    final loaded = await repository.getActiveProfile();
    expect(loaded?.id, profile.id);
    expect(loaded?.nickname, 'Mini');

    expect(
      repository.createProfile(avatarId: 'avatar_02', ageBand: AgeBand.a),
      throwsA(isA<ProfileAlreadyExistsFailure>()),
    );
  });

  test('blank nickname is stored as absent', () async {
    final repository = DriftProfileRepository(database);
    final profile = await repository.createProfile(
      avatarId: 'avatar_01',
      ageBand: AgeBand.a,
      nickname: '   ',
    );
    expect(profile.nickname, isNull);
  });

  test('progress cannot be stored without a profile', () async {
    expect(
      database
          .into(database.activityProgress)
          .insert(
            ActivityProgressCompanion.insert(
              profileId: 99,
              activityId: 'maze_1',
              engineType: 'maze',
              lastPlayedAt: 1,
            ),
          ),
      throwsA(isA<SqliteException>()),
    );
  });

  test('entitlement cache round trip does not store a price', () async {
    final repository = DriftEntitlementRepository(database);
    expect((await repository.read()).status, EntitlementStatus.inactive);
    await repository.save(
      const EntitlementSnapshot(
        status: EntitlementStatus.active,
        productId: 'sproutlab_annual',
        expiryMillis: 200,
        lastReconciledAtMillis: 100,
      ),
    );
    final loaded = await repository.read();
    expect(loaded.status, EntitlementStatus.active);
    expect(loaded.productId, 'sproutlab_annual');
    expect(loaded.premiumActiveAt(150), isTrue);
    expect(loaded.premiumActiveAt(200), isFalse);
  });
}
