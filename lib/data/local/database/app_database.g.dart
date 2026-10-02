// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ChildProfilesTable extends ChildProfiles
    with TableInfo<$ChildProfilesTable, ChildProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChildProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nicknameMeta = const VerificationMeta(
    'nickname',
  );
  @override
  late final GeneratedColumn<String> nickname = GeneratedColumn<String>(
    'nickname',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _avatarIdMeta = const VerificationMeta(
    'avatarId',
  );
  @override
  late final GeneratedColumn<String> avatarId = GeneratedColumn<String>(
    'avatar_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ageBandMeta = const VerificationMeta(
    'ageBand',
  );
  @override
  late final GeneratedColumn<String> ageBand = GeneratedColumn<String>(
    'age_band',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
    'active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nickname,
    avatarId,
    ageBand,
    createdAt,
    active,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'child_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChildProfile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nickname')) {
      context.handle(
        _nicknameMeta,
        nickname.isAcceptableOrUnknown(data['nickname']!, _nicknameMeta),
      );
    }
    if (data.containsKey('avatar_id')) {
      context.handle(
        _avatarIdMeta,
        avatarId.isAcceptableOrUnknown(data['avatar_id']!, _avatarIdMeta),
      );
    } else if (isInserting) {
      context.missing(_avatarIdMeta);
    }
    if (data.containsKey('age_band')) {
      context.handle(
        _ageBandMeta,
        ageBand.isAcceptableOrUnknown(data['age_band']!, _ageBandMeta),
      );
    } else if (isInserting) {
      context.missing(_ageBandMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('active')) {
      context.handle(
        _activeMeta,
        active.isAcceptableOrUnknown(data['active']!, _activeMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChildProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChildProfile(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nickname: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nickname'],
      ),
      avatarId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}avatar_id'],
      )!,
      ageBand: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}age_band'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      active: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}active'],
      )!,
    );
  }

  @override
  $ChildProfilesTable createAlias(String alias) {
    return $ChildProfilesTable(attachedDatabase, alias);
  }
}

class ChildProfile extends DataClass implements Insertable<ChildProfile> {
  final int id;
  final String? nickname;
  final String avatarId;
  final String ageBand;
  final int createdAt;
  final bool active;
  const ChildProfile({
    required this.id,
    this.nickname,
    required this.avatarId,
    required this.ageBand,
    required this.createdAt,
    required this.active,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || nickname != null) {
      map['nickname'] = Variable<String>(nickname);
    }
    map['avatar_id'] = Variable<String>(avatarId);
    map['age_band'] = Variable<String>(ageBand);
    map['created_at'] = Variable<int>(createdAt);
    map['active'] = Variable<bool>(active);
    return map;
  }

  ChildProfilesCompanion toCompanion(bool nullToAbsent) {
    return ChildProfilesCompanion(
      id: Value(id),
      nickname: nickname == null && nullToAbsent
          ? const Value.absent()
          : Value(nickname),
      avatarId: Value(avatarId),
      ageBand: Value(ageBand),
      createdAt: Value(createdAt),
      active: Value(active),
    );
  }

  factory ChildProfile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChildProfile(
      id: serializer.fromJson<int>(json['id']),
      nickname: serializer.fromJson<String?>(json['nickname']),
      avatarId: serializer.fromJson<String>(json['avatarId']),
      ageBand: serializer.fromJson<String>(json['ageBand']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      active: serializer.fromJson<bool>(json['active']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nickname': serializer.toJson<String?>(nickname),
      'avatarId': serializer.toJson<String>(avatarId),
      'ageBand': serializer.toJson<String>(ageBand),
      'createdAt': serializer.toJson<int>(createdAt),
      'active': serializer.toJson<bool>(active),
    };
  }

  ChildProfile copyWith({
    int? id,
    Value<String?> nickname = const Value.absent(),
    String? avatarId,
    String? ageBand,
    int? createdAt,
    bool? active,
  }) => ChildProfile(
    id: id ?? this.id,
    nickname: nickname.present ? nickname.value : this.nickname,
    avatarId: avatarId ?? this.avatarId,
    ageBand: ageBand ?? this.ageBand,
    createdAt: createdAt ?? this.createdAt,
    active: active ?? this.active,
  );
  ChildProfile copyWithCompanion(ChildProfilesCompanion data) {
    return ChildProfile(
      id: data.id.present ? data.id.value : this.id,
      nickname: data.nickname.present ? data.nickname.value : this.nickname,
      avatarId: data.avatarId.present ? data.avatarId.value : this.avatarId,
      ageBand: data.ageBand.present ? data.ageBand.value : this.ageBand,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      active: data.active.present ? data.active.value : this.active,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChildProfile(')
          ..write('id: $id, ')
          ..write('nickname: $nickname, ')
          ..write('avatarId: $avatarId, ')
          ..write('ageBand: $ageBand, ')
          ..write('createdAt: $createdAt, ')
          ..write('active: $active')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, nickname, avatarId, ageBand, createdAt, active);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChildProfile &&
          other.id == this.id &&
          other.nickname == this.nickname &&
          other.avatarId == this.avatarId &&
          other.ageBand == this.ageBand &&
          other.createdAt == this.createdAt &&
          other.active == this.active);
}

class ChildProfilesCompanion extends UpdateCompanion<ChildProfile> {
  final Value<int> id;
  final Value<String?> nickname;
  final Value<String> avatarId;
  final Value<String> ageBand;
  final Value<int> createdAt;
  final Value<bool> active;
  const ChildProfilesCompanion({
    this.id = const Value.absent(),
    this.nickname = const Value.absent(),
    this.avatarId = const Value.absent(),
    this.ageBand = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.active = const Value.absent(),
  });
  ChildProfilesCompanion.insert({
    this.id = const Value.absent(),
    this.nickname = const Value.absent(),
    required String avatarId,
    required String ageBand,
    required int createdAt,
    this.active = const Value.absent(),
  }) : avatarId = Value(avatarId),
       ageBand = Value(ageBand),
       createdAt = Value(createdAt);
  static Insertable<ChildProfile> custom({
    Expression<int>? id,
    Expression<String>? nickname,
    Expression<String>? avatarId,
    Expression<String>? ageBand,
    Expression<int>? createdAt,
    Expression<bool>? active,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nickname != null) 'nickname': nickname,
      if (avatarId != null) 'avatar_id': avatarId,
      if (ageBand != null) 'age_band': ageBand,
      if (createdAt != null) 'created_at': createdAt,
      if (active != null) 'active': active,
    });
  }

  ChildProfilesCompanion copyWith({
    Value<int>? id,
    Value<String?>? nickname,
    Value<String>? avatarId,
    Value<String>? ageBand,
    Value<int>? createdAt,
    Value<bool>? active,
  }) {
    return ChildProfilesCompanion(
      id: id ?? this.id,
      nickname: nickname ?? this.nickname,
      avatarId: avatarId ?? this.avatarId,
      ageBand: ageBand ?? this.ageBand,
      createdAt: createdAt ?? this.createdAt,
      active: active ?? this.active,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nickname.present) {
      map['nickname'] = Variable<String>(nickname.value);
    }
    if (avatarId.present) {
      map['avatar_id'] = Variable<String>(avatarId.value);
    }
    if (ageBand.present) {
      map['age_band'] = Variable<String>(ageBand.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChildProfilesCompanion(')
          ..write('id: $id, ')
          ..write('nickname: $nickname, ')
          ..write('avatarId: $avatarId, ')
          ..write('ageBand: $ageBand, ')
          ..write('createdAt: $createdAt, ')
          ..write('active: $active')
          ..write(')'))
        .toString();
  }
}

class $ActivityProgressTable extends ActivityProgress
    with TableInfo<$ActivityProgressTable, ActivityProgressData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActivityProgressTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<int> profileId = GeneratedColumn<int>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES child_profiles (id)',
    ),
  );
  static const VerificationMeta _activityIdMeta = const VerificationMeta(
    'activityId',
  );
  @override
  late final GeneratedColumn<String> activityId = GeneratedColumn<String>(
    'activity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _engineTypeMeta = const VerificationMeta(
    'engineType',
  );
  @override
  late final GeneratedColumn<String> engineType = GeneratedColumn<String>(
    'engine_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _attemptsMeta = const VerificationMeta(
    'attempts',
  );
  @override
  late final GeneratedColumn<int> attempts = GeneratedColumn<int>(
    'attempts',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _completionsMeta = const VerificationMeta(
    'completions',
  );
  @override
  late final GeneratedColumn<int> completions = GeneratedColumn<int>(
    'completions',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _bestStarsMeta = const VerificationMeta(
    'bestStars',
  );
  @override
  late final GeneratedColumn<int> bestStars = GeneratedColumn<int>(
    'best_stars',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _hintsUsedMeta = const VerificationMeta(
    'hintsUsed',
  );
  @override
  late final GeneratedColumn<int> hintsUsed = GeneratedColumn<int>(
    'hints_used',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastPlayedAtMeta = const VerificationMeta(
    'lastPlayedAt',
  );
  @override
  late final GeneratedColumn<int> lastPlayedAt = GeneratedColumn<int>(
    'last_played_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _masteryContributionMeta =
      const VerificationMeta('masteryContribution');
  @override
  late final GeneratedColumn<double> masteryContribution =
      GeneratedColumn<double>(
        'mastery_contribution',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      );
  static const VerificationMeta _countedAsFreeMeta = const VerificationMeta(
    'countedAsFree',
  );
  @override
  late final GeneratedColumn<bool> countedAsFree = GeneratedColumn<bool>(
    'counted_as_free',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("counted_as_free" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _generatorTypeMeta = const VerificationMeta(
    'generatorType',
  );
  @override
  late final GeneratedColumn<String> generatorType = GeneratedColumn<String>(
    'generator_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _generatorVersionMeta = const VerificationMeta(
    'generatorVersion',
  );
  @override
  late final GeneratedColumn<String> generatorVersion = GeneratedColumn<String>(
    'generator_version',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _seedMeta = const VerificationMeta('seed');
  @override
  late final GeneratedColumn<int> seed = GeneratedColumn<int>(
    'seed',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _skillIdMeta = const VerificationMeta(
    'skillId',
  );
  @override
  late final GeneratedColumn<String> skillId = GeneratedColumn<String>(
    'skill_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _resultSummaryMeta = const VerificationMeta(
    'resultSummary',
  );
  @override
  late final GeneratedColumn<String> resultSummary = GeneratedColumn<String>(
    'result_summary',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bestScoreMeta = const VerificationMeta(
    'bestScore',
  );
  @override
  late final GeneratedColumn<int> bestScore = GeneratedColumn<int>(
    'best_score',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    profileId,
    activityId,
    engineType,
    attempts,
    completions,
    bestStars,
    hintsUsed,
    lastPlayedAt,
    masteryContribution,
    countedAsFree,
    generatorType,
    generatorVersion,
    seed,
    skillId,
    resultSummary,
    bestScore,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'activity_progress';
  @override
  VerificationContext validateIntegrity(
    Insertable<ActivityProgressData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('activity_id')) {
      context.handle(
        _activityIdMeta,
        activityId.isAcceptableOrUnknown(data['activity_id']!, _activityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_activityIdMeta);
    }
    if (data.containsKey('engine_type')) {
      context.handle(
        _engineTypeMeta,
        engineType.isAcceptableOrUnknown(data['engine_type']!, _engineTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_engineTypeMeta);
    }
    if (data.containsKey('attempts')) {
      context.handle(
        _attemptsMeta,
        attempts.isAcceptableOrUnknown(data['attempts']!, _attemptsMeta),
      );
    }
    if (data.containsKey('completions')) {
      context.handle(
        _completionsMeta,
        completions.isAcceptableOrUnknown(
          data['completions']!,
          _completionsMeta,
        ),
      );
    }
    if (data.containsKey('best_stars')) {
      context.handle(
        _bestStarsMeta,
        bestStars.isAcceptableOrUnknown(data['best_stars']!, _bestStarsMeta),
      );
    }
    if (data.containsKey('hints_used')) {
      context.handle(
        _hintsUsedMeta,
        hintsUsed.isAcceptableOrUnknown(data['hints_used']!, _hintsUsedMeta),
      );
    }
    if (data.containsKey('last_played_at')) {
      context.handle(
        _lastPlayedAtMeta,
        lastPlayedAt.isAcceptableOrUnknown(
          data['last_played_at']!,
          _lastPlayedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastPlayedAtMeta);
    }
    if (data.containsKey('mastery_contribution')) {
      context.handle(
        _masteryContributionMeta,
        masteryContribution.isAcceptableOrUnknown(
          data['mastery_contribution']!,
          _masteryContributionMeta,
        ),
      );
    }
    if (data.containsKey('counted_as_free')) {
      context.handle(
        _countedAsFreeMeta,
        countedAsFree.isAcceptableOrUnknown(
          data['counted_as_free']!,
          _countedAsFreeMeta,
        ),
      );
    }
    if (data.containsKey('generator_type')) {
      context.handle(
        _generatorTypeMeta,
        generatorType.isAcceptableOrUnknown(
          data['generator_type']!,
          _generatorTypeMeta,
        ),
      );
    }
    if (data.containsKey('generator_version')) {
      context.handle(
        _generatorVersionMeta,
        generatorVersion.isAcceptableOrUnknown(
          data['generator_version']!,
          _generatorVersionMeta,
        ),
      );
    }
    if (data.containsKey('seed')) {
      context.handle(
        _seedMeta,
        seed.isAcceptableOrUnknown(data['seed']!, _seedMeta),
      );
    }
    if (data.containsKey('skill_id')) {
      context.handle(
        _skillIdMeta,
        skillId.isAcceptableOrUnknown(data['skill_id']!, _skillIdMeta),
      );
    }
    if (data.containsKey('result_summary')) {
      context.handle(
        _resultSummaryMeta,
        resultSummary.isAcceptableOrUnknown(
          data['result_summary']!,
          _resultSummaryMeta,
        ),
      );
    }
    if (data.containsKey('best_score')) {
      context.handle(
        _bestScoreMeta,
        bestScore.isAcceptableOrUnknown(data['best_score']!, _bestScoreMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {profileId, activityId};
  @override
  ActivityProgressData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ActivityProgressData(
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}profile_id'],
      )!,
      activityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}activity_id'],
      )!,
      engineType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}engine_type'],
      )!,
      attempts: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempts'],
      )!,
      completions: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}completions'],
      )!,
      bestStars: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}best_stars'],
      )!,
      hintsUsed: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hints_used'],
      )!,
      lastPlayedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_played_at'],
      )!,
      masteryContribution: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}mastery_contribution'],
      )!,
      countedAsFree: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}counted_as_free'],
      )!,
      generatorType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}generator_type'],
      ),
      generatorVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}generator_version'],
      ),
      seed: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}seed'],
      ),
      skillId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}skill_id'],
      ),
      resultSummary: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}result_summary'],
      ),
      bestScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}best_score'],
      )!,
    );
  }

  @override
  $ActivityProgressTable createAlias(String alias) {
    return $ActivityProgressTable(attachedDatabase, alias);
  }
}

class ActivityProgressData extends DataClass
    implements Insertable<ActivityProgressData> {
  final int profileId;
  final String activityId;
  final String engineType;
  final int attempts;
  final int completions;
  final int bestStars;
  final int hintsUsed;
  final int lastPlayedAt;
  final double masteryContribution;
  final bool countedAsFree;
  final String? generatorType;
  final String? generatorVersion;
  final int? seed;
  final String? skillId;
  final String? resultSummary;
  final int bestScore;
  const ActivityProgressData({
    required this.profileId,
    required this.activityId,
    required this.engineType,
    required this.attempts,
    required this.completions,
    required this.bestStars,
    required this.hintsUsed,
    required this.lastPlayedAt,
    required this.masteryContribution,
    required this.countedAsFree,
    this.generatorType,
    this.generatorVersion,
    this.seed,
    this.skillId,
    this.resultSummary,
    required this.bestScore,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['profile_id'] = Variable<int>(profileId);
    map['activity_id'] = Variable<String>(activityId);
    map['engine_type'] = Variable<String>(engineType);
    map['attempts'] = Variable<int>(attempts);
    map['completions'] = Variable<int>(completions);
    map['best_stars'] = Variable<int>(bestStars);
    map['hints_used'] = Variable<int>(hintsUsed);
    map['last_played_at'] = Variable<int>(lastPlayedAt);
    map['mastery_contribution'] = Variable<double>(masteryContribution);
    map['counted_as_free'] = Variable<bool>(countedAsFree);
    if (!nullToAbsent || generatorType != null) {
      map['generator_type'] = Variable<String>(generatorType);
    }
    if (!nullToAbsent || generatorVersion != null) {
      map['generator_version'] = Variable<String>(generatorVersion);
    }
    if (!nullToAbsent || seed != null) {
      map['seed'] = Variable<int>(seed);
    }
    if (!nullToAbsent || skillId != null) {
      map['skill_id'] = Variable<String>(skillId);
    }
    if (!nullToAbsent || resultSummary != null) {
      map['result_summary'] = Variable<String>(resultSummary);
    }
    map['best_score'] = Variable<int>(bestScore);
    return map;
  }

  ActivityProgressCompanion toCompanion(bool nullToAbsent) {
    return ActivityProgressCompanion(
      profileId: Value(profileId),
      activityId: Value(activityId),
      engineType: Value(engineType),
      attempts: Value(attempts),
      completions: Value(completions),
      bestStars: Value(bestStars),
      hintsUsed: Value(hintsUsed),
      lastPlayedAt: Value(lastPlayedAt),
      masteryContribution: Value(masteryContribution),
      countedAsFree: Value(countedAsFree),
      generatorType: generatorType == null && nullToAbsent
          ? const Value.absent()
          : Value(generatorType),
      generatorVersion: generatorVersion == null && nullToAbsent
          ? const Value.absent()
          : Value(generatorVersion),
      seed: seed == null && nullToAbsent ? const Value.absent() : Value(seed),
      skillId: skillId == null && nullToAbsent
          ? const Value.absent()
          : Value(skillId),
      resultSummary: resultSummary == null && nullToAbsent
          ? const Value.absent()
          : Value(resultSummary),
      bestScore: Value(bestScore),
    );
  }

  factory ActivityProgressData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ActivityProgressData(
      profileId: serializer.fromJson<int>(json['profileId']),
      activityId: serializer.fromJson<String>(json['activityId']),
      engineType: serializer.fromJson<String>(json['engineType']),
      attempts: serializer.fromJson<int>(json['attempts']),
      completions: serializer.fromJson<int>(json['completions']),
      bestStars: serializer.fromJson<int>(json['bestStars']),
      hintsUsed: serializer.fromJson<int>(json['hintsUsed']),
      lastPlayedAt: serializer.fromJson<int>(json['lastPlayedAt']),
      masteryContribution: serializer.fromJson<double>(
        json['masteryContribution'],
      ),
      countedAsFree: serializer.fromJson<bool>(json['countedAsFree']),
      generatorType: serializer.fromJson<String?>(json['generatorType']),
      generatorVersion: serializer.fromJson<String?>(json['generatorVersion']),
      seed: serializer.fromJson<int?>(json['seed']),
      skillId: serializer.fromJson<String?>(json['skillId']),
      resultSummary: serializer.fromJson<String?>(json['resultSummary']),
      bestScore: serializer.fromJson<int>(json['bestScore']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'profileId': serializer.toJson<int>(profileId),
      'activityId': serializer.toJson<String>(activityId),
      'engineType': serializer.toJson<String>(engineType),
      'attempts': serializer.toJson<int>(attempts),
      'completions': serializer.toJson<int>(completions),
      'bestStars': serializer.toJson<int>(bestStars),
      'hintsUsed': serializer.toJson<int>(hintsUsed),
      'lastPlayedAt': serializer.toJson<int>(lastPlayedAt),
      'masteryContribution': serializer.toJson<double>(masteryContribution),
      'countedAsFree': serializer.toJson<bool>(countedAsFree),
      'generatorType': serializer.toJson<String?>(generatorType),
      'generatorVersion': serializer.toJson<String?>(generatorVersion),
      'seed': serializer.toJson<int?>(seed),
      'skillId': serializer.toJson<String?>(skillId),
      'resultSummary': serializer.toJson<String?>(resultSummary),
      'bestScore': serializer.toJson<int>(bestScore),
    };
  }

  ActivityProgressData copyWith({
    int? profileId,
    String? activityId,
    String? engineType,
    int? attempts,
    int? completions,
    int? bestStars,
    int? hintsUsed,
    int? lastPlayedAt,
    double? masteryContribution,
    bool? countedAsFree,
    Value<String?> generatorType = const Value.absent(),
    Value<String?> generatorVersion = const Value.absent(),
    Value<int?> seed = const Value.absent(),
    Value<String?> skillId = const Value.absent(),
    Value<String?> resultSummary = const Value.absent(),
    int? bestScore,
  }) => ActivityProgressData(
    profileId: profileId ?? this.profileId,
    activityId: activityId ?? this.activityId,
    engineType: engineType ?? this.engineType,
    attempts: attempts ?? this.attempts,
    completions: completions ?? this.completions,
    bestStars: bestStars ?? this.bestStars,
    hintsUsed: hintsUsed ?? this.hintsUsed,
    lastPlayedAt: lastPlayedAt ?? this.lastPlayedAt,
    masteryContribution: masteryContribution ?? this.masteryContribution,
    countedAsFree: countedAsFree ?? this.countedAsFree,
    generatorType: generatorType.present
        ? generatorType.value
        : this.generatorType,
    generatorVersion: generatorVersion.present
        ? generatorVersion.value
        : this.generatorVersion,
    seed: seed.present ? seed.value : this.seed,
    skillId: skillId.present ? skillId.value : this.skillId,
    resultSummary: resultSummary.present
        ? resultSummary.value
        : this.resultSummary,
    bestScore: bestScore ?? this.bestScore,
  );
  ActivityProgressData copyWithCompanion(ActivityProgressCompanion data) {
    return ActivityProgressData(
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      activityId: data.activityId.present
          ? data.activityId.value
          : this.activityId,
      engineType: data.engineType.present
          ? data.engineType.value
          : this.engineType,
      attempts: data.attempts.present ? data.attempts.value : this.attempts,
      completions: data.completions.present
          ? data.completions.value
          : this.completions,
      bestStars: data.bestStars.present ? data.bestStars.value : this.bestStars,
      hintsUsed: data.hintsUsed.present ? data.hintsUsed.value : this.hintsUsed,
      lastPlayedAt: data.lastPlayedAt.present
          ? data.lastPlayedAt.value
          : this.lastPlayedAt,
      masteryContribution: data.masteryContribution.present
          ? data.masteryContribution.value
          : this.masteryContribution,
      countedAsFree: data.countedAsFree.present
          ? data.countedAsFree.value
          : this.countedAsFree,
      generatorType: data.generatorType.present
          ? data.generatorType.value
          : this.generatorType,
      generatorVersion: data.generatorVersion.present
          ? data.generatorVersion.value
          : this.generatorVersion,
      seed: data.seed.present ? data.seed.value : this.seed,
      skillId: data.skillId.present ? data.skillId.value : this.skillId,
      resultSummary: data.resultSummary.present
          ? data.resultSummary.value
          : this.resultSummary,
      bestScore: data.bestScore.present ? data.bestScore.value : this.bestScore,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ActivityProgressData(')
          ..write('profileId: $profileId, ')
          ..write('activityId: $activityId, ')
          ..write('engineType: $engineType, ')
          ..write('attempts: $attempts, ')
          ..write('completions: $completions, ')
          ..write('bestStars: $bestStars, ')
          ..write('hintsUsed: $hintsUsed, ')
          ..write('lastPlayedAt: $lastPlayedAt, ')
          ..write('masteryContribution: $masteryContribution, ')
          ..write('countedAsFree: $countedAsFree, ')
          ..write('generatorType: $generatorType, ')
          ..write('generatorVersion: $generatorVersion, ')
          ..write('seed: $seed, ')
          ..write('skillId: $skillId, ')
          ..write('resultSummary: $resultSummary, ')
          ..write('bestScore: $bestScore')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    profileId,
    activityId,
    engineType,
    attempts,
    completions,
    bestStars,
    hintsUsed,
    lastPlayedAt,
    masteryContribution,
    countedAsFree,
    generatorType,
    generatorVersion,
    seed,
    skillId,
    resultSummary,
    bestScore,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ActivityProgressData &&
          other.profileId == this.profileId &&
          other.activityId == this.activityId &&
          other.engineType == this.engineType &&
          other.attempts == this.attempts &&
          other.completions == this.completions &&
          other.bestStars == this.bestStars &&
          other.hintsUsed == this.hintsUsed &&
          other.lastPlayedAt == this.lastPlayedAt &&
          other.masteryContribution == this.masteryContribution &&
          other.countedAsFree == this.countedAsFree &&
          other.generatorType == this.generatorType &&
          other.generatorVersion == this.generatorVersion &&
          other.seed == this.seed &&
          other.skillId == this.skillId &&
          other.resultSummary == this.resultSummary &&
          other.bestScore == this.bestScore);
}

class ActivityProgressCompanion extends UpdateCompanion<ActivityProgressData> {
  final Value<int> profileId;
  final Value<String> activityId;
  final Value<String> engineType;
  final Value<int> attempts;
  final Value<int> completions;
  final Value<int> bestStars;
  final Value<int> hintsUsed;
  final Value<int> lastPlayedAt;
  final Value<double> masteryContribution;
  final Value<bool> countedAsFree;
  final Value<String?> generatorType;
  final Value<String?> generatorVersion;
  final Value<int?> seed;
  final Value<String?> skillId;
  final Value<String?> resultSummary;
  final Value<int> bestScore;
  final Value<int> rowid;
  const ActivityProgressCompanion({
    this.profileId = const Value.absent(),
    this.activityId = const Value.absent(),
    this.engineType = const Value.absent(),
    this.attempts = const Value.absent(),
    this.completions = const Value.absent(),
    this.bestStars = const Value.absent(),
    this.hintsUsed = const Value.absent(),
    this.lastPlayedAt = const Value.absent(),
    this.masteryContribution = const Value.absent(),
    this.countedAsFree = const Value.absent(),
    this.generatorType = const Value.absent(),
    this.generatorVersion = const Value.absent(),
    this.seed = const Value.absent(),
    this.skillId = const Value.absent(),
    this.resultSummary = const Value.absent(),
    this.bestScore = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ActivityProgressCompanion.insert({
    required int profileId,
    required String activityId,
    required String engineType,
    this.attempts = const Value.absent(),
    this.completions = const Value.absent(),
    this.bestStars = const Value.absent(),
    this.hintsUsed = const Value.absent(),
    required int lastPlayedAt,
    this.masteryContribution = const Value.absent(),
    this.countedAsFree = const Value.absent(),
    this.generatorType = const Value.absent(),
    this.generatorVersion = const Value.absent(),
    this.seed = const Value.absent(),
    this.skillId = const Value.absent(),
    this.resultSummary = const Value.absent(),
    this.bestScore = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : profileId = Value(profileId),
       activityId = Value(activityId),
       engineType = Value(engineType),
       lastPlayedAt = Value(lastPlayedAt);
  static Insertable<ActivityProgressData> custom({
    Expression<int>? profileId,
    Expression<String>? activityId,
    Expression<String>? engineType,
    Expression<int>? attempts,
    Expression<int>? completions,
    Expression<int>? bestStars,
    Expression<int>? hintsUsed,
    Expression<int>? lastPlayedAt,
    Expression<double>? masteryContribution,
    Expression<bool>? countedAsFree,
    Expression<String>? generatorType,
    Expression<String>? generatorVersion,
    Expression<int>? seed,
    Expression<String>? skillId,
    Expression<String>? resultSummary,
    Expression<int>? bestScore,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (profileId != null) 'profile_id': profileId,
      if (activityId != null) 'activity_id': activityId,
      if (engineType != null) 'engine_type': engineType,
      if (attempts != null) 'attempts': attempts,
      if (completions != null) 'completions': completions,
      if (bestStars != null) 'best_stars': bestStars,
      if (hintsUsed != null) 'hints_used': hintsUsed,
      if (lastPlayedAt != null) 'last_played_at': lastPlayedAt,
      if (masteryContribution != null)
        'mastery_contribution': masteryContribution,
      if (countedAsFree != null) 'counted_as_free': countedAsFree,
      if (generatorType != null) 'generator_type': generatorType,
      if (generatorVersion != null) 'generator_version': generatorVersion,
      if (seed != null) 'seed': seed,
      if (skillId != null) 'skill_id': skillId,
      if (resultSummary != null) 'result_summary': resultSummary,
      if (bestScore != null) 'best_score': bestScore,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ActivityProgressCompanion copyWith({
    Value<int>? profileId,
    Value<String>? activityId,
    Value<String>? engineType,
    Value<int>? attempts,
    Value<int>? completions,
    Value<int>? bestStars,
    Value<int>? hintsUsed,
    Value<int>? lastPlayedAt,
    Value<double>? masteryContribution,
    Value<bool>? countedAsFree,
    Value<String?>? generatorType,
    Value<String?>? generatorVersion,
    Value<int?>? seed,
    Value<String?>? skillId,
    Value<String?>? resultSummary,
    Value<int>? bestScore,
    Value<int>? rowid,
  }) {
    return ActivityProgressCompanion(
      profileId: profileId ?? this.profileId,
      activityId: activityId ?? this.activityId,
      engineType: engineType ?? this.engineType,
      attempts: attempts ?? this.attempts,
      completions: completions ?? this.completions,
      bestStars: bestStars ?? this.bestStars,
      hintsUsed: hintsUsed ?? this.hintsUsed,
      lastPlayedAt: lastPlayedAt ?? this.lastPlayedAt,
      masteryContribution: masteryContribution ?? this.masteryContribution,
      countedAsFree: countedAsFree ?? this.countedAsFree,
      generatorType: generatorType ?? this.generatorType,
      generatorVersion: generatorVersion ?? this.generatorVersion,
      seed: seed ?? this.seed,
      skillId: skillId ?? this.skillId,
      resultSummary: resultSummary ?? this.resultSummary,
      bestScore: bestScore ?? this.bestScore,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (profileId.present) {
      map['profile_id'] = Variable<int>(profileId.value);
    }
    if (activityId.present) {
      map['activity_id'] = Variable<String>(activityId.value);
    }
    if (engineType.present) {
      map['engine_type'] = Variable<String>(engineType.value);
    }
    if (attempts.present) {
      map['attempts'] = Variable<int>(attempts.value);
    }
    if (completions.present) {
      map['completions'] = Variable<int>(completions.value);
    }
    if (bestStars.present) {
      map['best_stars'] = Variable<int>(bestStars.value);
    }
    if (hintsUsed.present) {
      map['hints_used'] = Variable<int>(hintsUsed.value);
    }
    if (lastPlayedAt.present) {
      map['last_played_at'] = Variable<int>(lastPlayedAt.value);
    }
    if (masteryContribution.present) {
      map['mastery_contribution'] = Variable<double>(masteryContribution.value);
    }
    if (countedAsFree.present) {
      map['counted_as_free'] = Variable<bool>(countedAsFree.value);
    }
    if (generatorType.present) {
      map['generator_type'] = Variable<String>(generatorType.value);
    }
    if (generatorVersion.present) {
      map['generator_version'] = Variable<String>(generatorVersion.value);
    }
    if (seed.present) {
      map['seed'] = Variable<int>(seed.value);
    }
    if (skillId.present) {
      map['skill_id'] = Variable<String>(skillId.value);
    }
    if (resultSummary.present) {
      map['result_summary'] = Variable<String>(resultSummary.value);
    }
    if (bestScore.present) {
      map['best_score'] = Variable<int>(bestScore.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActivityProgressCompanion(')
          ..write('profileId: $profileId, ')
          ..write('activityId: $activityId, ')
          ..write('engineType: $engineType, ')
          ..write('attempts: $attempts, ')
          ..write('completions: $completions, ')
          ..write('bestStars: $bestStars, ')
          ..write('hintsUsed: $hintsUsed, ')
          ..write('lastPlayedAt: $lastPlayedAt, ')
          ..write('masteryContribution: $masteryContribution, ')
          ..write('countedAsFree: $countedAsFree, ')
          ..write('generatorType: $generatorType, ')
          ..write('generatorVersion: $generatorVersion, ')
          ..write('seed: $seed, ')
          ..write('skillId: $skillId, ')
          ..write('resultSummary: $resultSummary, ')
          ..write('bestScore: $bestScore, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SkillProgressTable extends SkillProgress
    with TableInfo<$SkillProgressTable, SkillProgressData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SkillProgressTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<int> profileId = GeneratedColumn<int>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES child_profiles (id)',
    ),
  );
  static const VerificationMeta _skillIdMeta = const VerificationMeta(
    'skillId',
  );
  @override
  late final GeneratedColumn<String> skillId = GeneratedColumn<String>(
    'skill_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _masteryMeta = const VerificationMeta(
    'mastery',
  );
  @override
  late final GeneratedColumn<double> mastery = GeneratedColumn<double>(
    'mastery',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _attemptCountMeta = const VerificationMeta(
    'attemptCount',
  );
  @override
  late final GeneratedColumn<int> attemptCount = GeneratedColumn<int>(
    'attempt_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastUpdatedAtMeta = const VerificationMeta(
    'lastUpdatedAt',
  );
  @override
  late final GeneratedColumn<int> lastUpdatedAt = GeneratedColumn<int>(
    'last_updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currentDifficultyMeta = const VerificationMeta(
    'currentDifficulty',
  );
  @override
  late final GeneratedColumn<int> currentDifficulty = GeneratedColumn<int>(
    'current_difficulty',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _correctFirstTryMeta = const VerificationMeta(
    'correctFirstTry',
  );
  @override
  late final GeneratedColumn<int> correctFirstTry = GeneratedColumn<int>(
    'correct_first_try',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _correctAfterHintMeta = const VerificationMeta(
    'correctAfterHint',
  );
  @override
  late final GeneratedColumn<int> correctAfterHint = GeneratedColumn<int>(
    'correct_after_hint',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _incorrectCountMeta = const VerificationMeta(
    'incorrectCount',
  );
  @override
  late final GeneratedColumn<int> incorrectCount = GeneratedColumn<int>(
    'incorrect_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _recentOutcomesMeta = const VerificationMeta(
    'recentOutcomes',
  );
  @override
  late final GeneratedColumn<String> recentOutcomes = GeneratedColumn<String>(
    'recent_outcomes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _recentActivityIdsMeta = const VerificationMeta(
    'recentActivityIds',
  );
  @override
  late final GeneratedColumn<String> recentActivityIds =
      GeneratedColumn<String>(
        'recent_activity_ids',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant(''),
      );
  @override
  List<GeneratedColumn> get $columns => [
    profileId,
    skillId,
    mastery,
    attemptCount,
    lastUpdatedAt,
    currentDifficulty,
    correctFirstTry,
    correctAfterHint,
    incorrectCount,
    recentOutcomes,
    recentActivityIds,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'skill_progress';
  @override
  VerificationContext validateIntegrity(
    Insertable<SkillProgressData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('skill_id')) {
      context.handle(
        _skillIdMeta,
        skillId.isAcceptableOrUnknown(data['skill_id']!, _skillIdMeta),
      );
    } else if (isInserting) {
      context.missing(_skillIdMeta);
    }
    if (data.containsKey('mastery')) {
      context.handle(
        _masteryMeta,
        mastery.isAcceptableOrUnknown(data['mastery']!, _masteryMeta),
      );
    }
    if (data.containsKey('attempt_count')) {
      context.handle(
        _attemptCountMeta,
        attemptCount.isAcceptableOrUnknown(
          data['attempt_count']!,
          _attemptCountMeta,
        ),
      );
    }
    if (data.containsKey('last_updated_at')) {
      context.handle(
        _lastUpdatedAtMeta,
        lastUpdatedAt.isAcceptableOrUnknown(
          data['last_updated_at']!,
          _lastUpdatedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastUpdatedAtMeta);
    }
    if (data.containsKey('current_difficulty')) {
      context.handle(
        _currentDifficultyMeta,
        currentDifficulty.isAcceptableOrUnknown(
          data['current_difficulty']!,
          _currentDifficultyMeta,
        ),
      );
    }
    if (data.containsKey('correct_first_try')) {
      context.handle(
        _correctFirstTryMeta,
        correctFirstTry.isAcceptableOrUnknown(
          data['correct_first_try']!,
          _correctFirstTryMeta,
        ),
      );
    }
    if (data.containsKey('correct_after_hint')) {
      context.handle(
        _correctAfterHintMeta,
        correctAfterHint.isAcceptableOrUnknown(
          data['correct_after_hint']!,
          _correctAfterHintMeta,
        ),
      );
    }
    if (data.containsKey('incorrect_count')) {
      context.handle(
        _incorrectCountMeta,
        incorrectCount.isAcceptableOrUnknown(
          data['incorrect_count']!,
          _incorrectCountMeta,
        ),
      );
    }
    if (data.containsKey('recent_outcomes')) {
      context.handle(
        _recentOutcomesMeta,
        recentOutcomes.isAcceptableOrUnknown(
          data['recent_outcomes']!,
          _recentOutcomesMeta,
        ),
      );
    }
    if (data.containsKey('recent_activity_ids')) {
      context.handle(
        _recentActivityIdsMeta,
        recentActivityIds.isAcceptableOrUnknown(
          data['recent_activity_ids']!,
          _recentActivityIdsMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {profileId, skillId};
  @override
  SkillProgressData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SkillProgressData(
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}profile_id'],
      )!,
      skillId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}skill_id'],
      )!,
      mastery: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}mastery'],
      )!,
      attemptCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempt_count'],
      )!,
      lastUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_updated_at'],
      )!,
      currentDifficulty: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_difficulty'],
      )!,
      correctFirstTry: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}correct_first_try'],
      )!,
      correctAfterHint: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}correct_after_hint'],
      )!,
      incorrectCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}incorrect_count'],
      )!,
      recentOutcomes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recent_outcomes'],
      )!,
      recentActivityIds: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recent_activity_ids'],
      )!,
    );
  }

  @override
  $SkillProgressTable createAlias(String alias) {
    return $SkillProgressTable(attachedDatabase, alias);
  }
}

class SkillProgressData extends DataClass
    implements Insertable<SkillProgressData> {
  final int profileId;
  final String skillId;
  final double mastery;
  final int attemptCount;
  final int lastUpdatedAt;
  final int currentDifficulty;
  final int correctFirstTry;
  final int correctAfterHint;
  final int incorrectCount;
  final String recentOutcomes;
  final String recentActivityIds;
  const SkillProgressData({
    required this.profileId,
    required this.skillId,
    required this.mastery,
    required this.attemptCount,
    required this.lastUpdatedAt,
    required this.currentDifficulty,
    required this.correctFirstTry,
    required this.correctAfterHint,
    required this.incorrectCount,
    required this.recentOutcomes,
    required this.recentActivityIds,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['profile_id'] = Variable<int>(profileId);
    map['skill_id'] = Variable<String>(skillId);
    map['mastery'] = Variable<double>(mastery);
    map['attempt_count'] = Variable<int>(attemptCount);
    map['last_updated_at'] = Variable<int>(lastUpdatedAt);
    map['current_difficulty'] = Variable<int>(currentDifficulty);
    map['correct_first_try'] = Variable<int>(correctFirstTry);
    map['correct_after_hint'] = Variable<int>(correctAfterHint);
    map['incorrect_count'] = Variable<int>(incorrectCount);
    map['recent_outcomes'] = Variable<String>(recentOutcomes);
    map['recent_activity_ids'] = Variable<String>(recentActivityIds);
    return map;
  }

  SkillProgressCompanion toCompanion(bool nullToAbsent) {
    return SkillProgressCompanion(
      profileId: Value(profileId),
      skillId: Value(skillId),
      mastery: Value(mastery),
      attemptCount: Value(attemptCount),
      lastUpdatedAt: Value(lastUpdatedAt),
      currentDifficulty: Value(currentDifficulty),
      correctFirstTry: Value(correctFirstTry),
      correctAfterHint: Value(correctAfterHint),
      incorrectCount: Value(incorrectCount),
      recentOutcomes: Value(recentOutcomes),
      recentActivityIds: Value(recentActivityIds),
    );
  }

  factory SkillProgressData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SkillProgressData(
      profileId: serializer.fromJson<int>(json['profileId']),
      skillId: serializer.fromJson<String>(json['skillId']),
      mastery: serializer.fromJson<double>(json['mastery']),
      attemptCount: serializer.fromJson<int>(json['attemptCount']),
      lastUpdatedAt: serializer.fromJson<int>(json['lastUpdatedAt']),
      currentDifficulty: serializer.fromJson<int>(json['currentDifficulty']),
      correctFirstTry: serializer.fromJson<int>(json['correctFirstTry']),
      correctAfterHint: serializer.fromJson<int>(json['correctAfterHint']),
      incorrectCount: serializer.fromJson<int>(json['incorrectCount']),
      recentOutcomes: serializer.fromJson<String>(json['recentOutcomes']),
      recentActivityIds: serializer.fromJson<String>(json['recentActivityIds']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'profileId': serializer.toJson<int>(profileId),
      'skillId': serializer.toJson<String>(skillId),
      'mastery': serializer.toJson<double>(mastery),
      'attemptCount': serializer.toJson<int>(attemptCount),
      'lastUpdatedAt': serializer.toJson<int>(lastUpdatedAt),
      'currentDifficulty': serializer.toJson<int>(currentDifficulty),
      'correctFirstTry': serializer.toJson<int>(correctFirstTry),
      'correctAfterHint': serializer.toJson<int>(correctAfterHint),
      'incorrectCount': serializer.toJson<int>(incorrectCount),
      'recentOutcomes': serializer.toJson<String>(recentOutcomes),
      'recentActivityIds': serializer.toJson<String>(recentActivityIds),
    };
  }

  SkillProgressData copyWith({
    int? profileId,
    String? skillId,
    double? mastery,
    int? attemptCount,
    int? lastUpdatedAt,
    int? currentDifficulty,
    int? correctFirstTry,
    int? correctAfterHint,
    int? incorrectCount,
    String? recentOutcomes,
    String? recentActivityIds,
  }) => SkillProgressData(
    profileId: profileId ?? this.profileId,
    skillId: skillId ?? this.skillId,
    mastery: mastery ?? this.mastery,
    attemptCount: attemptCount ?? this.attemptCount,
    lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
    currentDifficulty: currentDifficulty ?? this.currentDifficulty,
    correctFirstTry: correctFirstTry ?? this.correctFirstTry,
    correctAfterHint: correctAfterHint ?? this.correctAfterHint,
    incorrectCount: incorrectCount ?? this.incorrectCount,
    recentOutcomes: recentOutcomes ?? this.recentOutcomes,
    recentActivityIds: recentActivityIds ?? this.recentActivityIds,
  );
  SkillProgressData copyWithCompanion(SkillProgressCompanion data) {
    return SkillProgressData(
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      skillId: data.skillId.present ? data.skillId.value : this.skillId,
      mastery: data.mastery.present ? data.mastery.value : this.mastery,
      attemptCount: data.attemptCount.present
          ? data.attemptCount.value
          : this.attemptCount,
      lastUpdatedAt: data.lastUpdatedAt.present
          ? data.lastUpdatedAt.value
          : this.lastUpdatedAt,
      currentDifficulty: data.currentDifficulty.present
          ? data.currentDifficulty.value
          : this.currentDifficulty,
      correctFirstTry: data.correctFirstTry.present
          ? data.correctFirstTry.value
          : this.correctFirstTry,
      correctAfterHint: data.correctAfterHint.present
          ? data.correctAfterHint.value
          : this.correctAfterHint,
      incorrectCount: data.incorrectCount.present
          ? data.incorrectCount.value
          : this.incorrectCount,
      recentOutcomes: data.recentOutcomes.present
          ? data.recentOutcomes.value
          : this.recentOutcomes,
      recentActivityIds: data.recentActivityIds.present
          ? data.recentActivityIds.value
          : this.recentActivityIds,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SkillProgressData(')
          ..write('profileId: $profileId, ')
          ..write('skillId: $skillId, ')
          ..write('mastery: $mastery, ')
          ..write('attemptCount: $attemptCount, ')
          ..write('lastUpdatedAt: $lastUpdatedAt, ')
          ..write('currentDifficulty: $currentDifficulty, ')
          ..write('correctFirstTry: $correctFirstTry, ')
          ..write('correctAfterHint: $correctAfterHint, ')
          ..write('incorrectCount: $incorrectCount, ')
          ..write('recentOutcomes: $recentOutcomes, ')
          ..write('recentActivityIds: $recentActivityIds')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    profileId,
    skillId,
    mastery,
    attemptCount,
    lastUpdatedAt,
    currentDifficulty,
    correctFirstTry,
    correctAfterHint,
    incorrectCount,
    recentOutcomes,
    recentActivityIds,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SkillProgressData &&
          other.profileId == this.profileId &&
          other.skillId == this.skillId &&
          other.mastery == this.mastery &&
          other.attemptCount == this.attemptCount &&
          other.lastUpdatedAt == this.lastUpdatedAt &&
          other.currentDifficulty == this.currentDifficulty &&
          other.correctFirstTry == this.correctFirstTry &&
          other.correctAfterHint == this.correctAfterHint &&
          other.incorrectCount == this.incorrectCount &&
          other.recentOutcomes == this.recentOutcomes &&
          other.recentActivityIds == this.recentActivityIds);
}

class SkillProgressCompanion extends UpdateCompanion<SkillProgressData> {
  final Value<int> profileId;
  final Value<String> skillId;
  final Value<double> mastery;
  final Value<int> attemptCount;
  final Value<int> lastUpdatedAt;
  final Value<int> currentDifficulty;
  final Value<int> correctFirstTry;
  final Value<int> correctAfterHint;
  final Value<int> incorrectCount;
  final Value<String> recentOutcomes;
  final Value<String> recentActivityIds;
  final Value<int> rowid;
  const SkillProgressCompanion({
    this.profileId = const Value.absent(),
    this.skillId = const Value.absent(),
    this.mastery = const Value.absent(),
    this.attemptCount = const Value.absent(),
    this.lastUpdatedAt = const Value.absent(),
    this.currentDifficulty = const Value.absent(),
    this.correctFirstTry = const Value.absent(),
    this.correctAfterHint = const Value.absent(),
    this.incorrectCount = const Value.absent(),
    this.recentOutcomes = const Value.absent(),
    this.recentActivityIds = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SkillProgressCompanion.insert({
    required int profileId,
    required String skillId,
    this.mastery = const Value.absent(),
    this.attemptCount = const Value.absent(),
    required int lastUpdatedAt,
    this.currentDifficulty = const Value.absent(),
    this.correctFirstTry = const Value.absent(),
    this.correctAfterHint = const Value.absent(),
    this.incorrectCount = const Value.absent(),
    this.recentOutcomes = const Value.absent(),
    this.recentActivityIds = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : profileId = Value(profileId),
       skillId = Value(skillId),
       lastUpdatedAt = Value(lastUpdatedAt);
  static Insertable<SkillProgressData> custom({
    Expression<int>? profileId,
    Expression<String>? skillId,
    Expression<double>? mastery,
    Expression<int>? attemptCount,
    Expression<int>? lastUpdatedAt,
    Expression<int>? currentDifficulty,
    Expression<int>? correctFirstTry,
    Expression<int>? correctAfterHint,
    Expression<int>? incorrectCount,
    Expression<String>? recentOutcomes,
    Expression<String>? recentActivityIds,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (profileId != null) 'profile_id': profileId,
      if (skillId != null) 'skill_id': skillId,
      if (mastery != null) 'mastery': mastery,
      if (attemptCount != null) 'attempt_count': attemptCount,
      if (lastUpdatedAt != null) 'last_updated_at': lastUpdatedAt,
      if (currentDifficulty != null) 'current_difficulty': currentDifficulty,
      if (correctFirstTry != null) 'correct_first_try': correctFirstTry,
      if (correctAfterHint != null) 'correct_after_hint': correctAfterHint,
      if (incorrectCount != null) 'incorrect_count': incorrectCount,
      if (recentOutcomes != null) 'recent_outcomes': recentOutcomes,
      if (recentActivityIds != null) 'recent_activity_ids': recentActivityIds,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SkillProgressCompanion copyWith({
    Value<int>? profileId,
    Value<String>? skillId,
    Value<double>? mastery,
    Value<int>? attemptCount,
    Value<int>? lastUpdatedAt,
    Value<int>? currentDifficulty,
    Value<int>? correctFirstTry,
    Value<int>? correctAfterHint,
    Value<int>? incorrectCount,
    Value<String>? recentOutcomes,
    Value<String>? recentActivityIds,
    Value<int>? rowid,
  }) {
    return SkillProgressCompanion(
      profileId: profileId ?? this.profileId,
      skillId: skillId ?? this.skillId,
      mastery: mastery ?? this.mastery,
      attemptCount: attemptCount ?? this.attemptCount,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
      currentDifficulty: currentDifficulty ?? this.currentDifficulty,
      correctFirstTry: correctFirstTry ?? this.correctFirstTry,
      correctAfterHint: correctAfterHint ?? this.correctAfterHint,
      incorrectCount: incorrectCount ?? this.incorrectCount,
      recentOutcomes: recentOutcomes ?? this.recentOutcomes,
      recentActivityIds: recentActivityIds ?? this.recentActivityIds,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (profileId.present) {
      map['profile_id'] = Variable<int>(profileId.value);
    }
    if (skillId.present) {
      map['skill_id'] = Variable<String>(skillId.value);
    }
    if (mastery.present) {
      map['mastery'] = Variable<double>(mastery.value);
    }
    if (attemptCount.present) {
      map['attempt_count'] = Variable<int>(attemptCount.value);
    }
    if (lastUpdatedAt.present) {
      map['last_updated_at'] = Variable<int>(lastUpdatedAt.value);
    }
    if (currentDifficulty.present) {
      map['current_difficulty'] = Variable<int>(currentDifficulty.value);
    }
    if (correctFirstTry.present) {
      map['correct_first_try'] = Variable<int>(correctFirstTry.value);
    }
    if (correctAfterHint.present) {
      map['correct_after_hint'] = Variable<int>(correctAfterHint.value);
    }
    if (incorrectCount.present) {
      map['incorrect_count'] = Variable<int>(incorrectCount.value);
    }
    if (recentOutcomes.present) {
      map['recent_outcomes'] = Variable<String>(recentOutcomes.value);
    }
    if (recentActivityIds.present) {
      map['recent_activity_ids'] = Variable<String>(recentActivityIds.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SkillProgressCompanion(')
          ..write('profileId: $profileId, ')
          ..write('skillId: $skillId, ')
          ..write('mastery: $mastery, ')
          ..write('attemptCount: $attemptCount, ')
          ..write('lastUpdatedAt: $lastUpdatedAt, ')
          ..write('currentDifficulty: $currentDifficulty, ')
          ..write('correctFirstTry: $correctFirstTry, ')
          ..write('correctAfterHint: $correctAfterHint, ')
          ..write('incorrectCount: $incorrectCount, ')
          ..write('recentOutcomes: $recentOutcomes, ')
          ..write('recentActivityIds: $recentActivityIds, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DailyJourneysTable extends DailyJourneys
    with TableInfo<$DailyJourneysTable, DailyJourney> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyJourneysTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<int> profileId = GeneratedColumn<int>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES child_profiles (id)',
    ),
  );
  static const VerificationMeta _localDateKeyMeta = const VerificationMeta(
    'localDateKey',
  );
  @override
  late final GeneratedColumn<String> localDateKey = GeneratedColumn<String>(
    'local_date_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currentIndexMeta = const VerificationMeta(
    'currentIndex',
  );
  @override
  late final GeneratedColumn<int> currentIndex = GeneratedColumn<int>(
    'current_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _completedCountMeta = const VerificationMeta(
    'completedCount',
  );
  @override
  late final GeneratedColumn<int> completedCount = GeneratedColumn<int>(
    'completed_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _starsEarnedMeta = const VerificationMeta(
    'starsEarned',
  );
  @override
  late final GeneratedColumn<int> starsEarned = GeneratedColumn<int>(
    'stars_earned',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    profileId,
    localDateKey,
    currentIndex,
    completedCount,
    starsEarned,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_journeys';
  @override
  VerificationContext validateIntegrity(
    Insertable<DailyJourney> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('local_date_key')) {
      context.handle(
        _localDateKeyMeta,
        localDateKey.isAcceptableOrUnknown(
          data['local_date_key']!,
          _localDateKeyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_localDateKeyMeta);
    }
    if (data.containsKey('current_index')) {
      context.handle(
        _currentIndexMeta,
        currentIndex.isAcceptableOrUnknown(
          data['current_index']!,
          _currentIndexMeta,
        ),
      );
    }
    if (data.containsKey('completed_count')) {
      context.handle(
        _completedCountMeta,
        completedCount.isAcceptableOrUnknown(
          data['completed_count']!,
          _completedCountMeta,
        ),
      );
    }
    if (data.containsKey('stars_earned')) {
      context.handle(
        _starsEarnedMeta,
        starsEarned.isAcceptableOrUnknown(
          data['stars_earned']!,
          _starsEarnedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {profileId, localDateKey},
  ];
  @override
  DailyJourney map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyJourney(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}profile_id'],
      )!,
      localDateKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_date_key'],
      )!,
      currentIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_index'],
      )!,
      completedCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}completed_count'],
      )!,
      starsEarned: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}stars_earned'],
      )!,
    );
  }

  @override
  $DailyJourneysTable createAlias(String alias) {
    return $DailyJourneysTable(attachedDatabase, alias);
  }
}

class DailyJourney extends DataClass implements Insertable<DailyJourney> {
  final int id;
  final int profileId;
  final String localDateKey;
  final int currentIndex;
  final int completedCount;
  final int starsEarned;
  const DailyJourney({
    required this.id,
    required this.profileId,
    required this.localDateKey,
    required this.currentIndex,
    required this.completedCount,
    required this.starsEarned,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['profile_id'] = Variable<int>(profileId);
    map['local_date_key'] = Variable<String>(localDateKey);
    map['current_index'] = Variable<int>(currentIndex);
    map['completed_count'] = Variable<int>(completedCount);
    map['stars_earned'] = Variable<int>(starsEarned);
    return map;
  }

  DailyJourneysCompanion toCompanion(bool nullToAbsent) {
    return DailyJourneysCompanion(
      id: Value(id),
      profileId: Value(profileId),
      localDateKey: Value(localDateKey),
      currentIndex: Value(currentIndex),
      completedCount: Value(completedCount),
      starsEarned: Value(starsEarned),
    );
  }

  factory DailyJourney.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyJourney(
      id: serializer.fromJson<int>(json['id']),
      profileId: serializer.fromJson<int>(json['profileId']),
      localDateKey: serializer.fromJson<String>(json['localDateKey']),
      currentIndex: serializer.fromJson<int>(json['currentIndex']),
      completedCount: serializer.fromJson<int>(json['completedCount']),
      starsEarned: serializer.fromJson<int>(json['starsEarned']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'profileId': serializer.toJson<int>(profileId),
      'localDateKey': serializer.toJson<String>(localDateKey),
      'currentIndex': serializer.toJson<int>(currentIndex),
      'completedCount': serializer.toJson<int>(completedCount),
      'starsEarned': serializer.toJson<int>(starsEarned),
    };
  }

  DailyJourney copyWith({
    int? id,
    int? profileId,
    String? localDateKey,
    int? currentIndex,
    int? completedCount,
    int? starsEarned,
  }) => DailyJourney(
    id: id ?? this.id,
    profileId: profileId ?? this.profileId,
    localDateKey: localDateKey ?? this.localDateKey,
    currentIndex: currentIndex ?? this.currentIndex,
    completedCount: completedCount ?? this.completedCount,
    starsEarned: starsEarned ?? this.starsEarned,
  );
  DailyJourney copyWithCompanion(DailyJourneysCompanion data) {
    return DailyJourney(
      id: data.id.present ? data.id.value : this.id,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      localDateKey: data.localDateKey.present
          ? data.localDateKey.value
          : this.localDateKey,
      currentIndex: data.currentIndex.present
          ? data.currentIndex.value
          : this.currentIndex,
      completedCount: data.completedCount.present
          ? data.completedCount.value
          : this.completedCount,
      starsEarned: data.starsEarned.present
          ? data.starsEarned.value
          : this.starsEarned,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyJourney(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('localDateKey: $localDateKey, ')
          ..write('currentIndex: $currentIndex, ')
          ..write('completedCount: $completedCount, ')
          ..write('starsEarned: $starsEarned')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    profileId,
    localDateKey,
    currentIndex,
    completedCount,
    starsEarned,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyJourney &&
          other.id == this.id &&
          other.profileId == this.profileId &&
          other.localDateKey == this.localDateKey &&
          other.currentIndex == this.currentIndex &&
          other.completedCount == this.completedCount &&
          other.starsEarned == this.starsEarned);
}

class DailyJourneysCompanion extends UpdateCompanion<DailyJourney> {
  final Value<int> id;
  final Value<int> profileId;
  final Value<String> localDateKey;
  final Value<int> currentIndex;
  final Value<int> completedCount;
  final Value<int> starsEarned;
  const DailyJourneysCompanion({
    this.id = const Value.absent(),
    this.profileId = const Value.absent(),
    this.localDateKey = const Value.absent(),
    this.currentIndex = const Value.absent(),
    this.completedCount = const Value.absent(),
    this.starsEarned = const Value.absent(),
  });
  DailyJourneysCompanion.insert({
    this.id = const Value.absent(),
    required int profileId,
    required String localDateKey,
    this.currentIndex = const Value.absent(),
    this.completedCount = const Value.absent(),
    this.starsEarned = const Value.absent(),
  }) : profileId = Value(profileId),
       localDateKey = Value(localDateKey);
  static Insertable<DailyJourney> custom({
    Expression<int>? id,
    Expression<int>? profileId,
    Expression<String>? localDateKey,
    Expression<int>? currentIndex,
    Expression<int>? completedCount,
    Expression<int>? starsEarned,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profileId != null) 'profile_id': profileId,
      if (localDateKey != null) 'local_date_key': localDateKey,
      if (currentIndex != null) 'current_index': currentIndex,
      if (completedCount != null) 'completed_count': completedCount,
      if (starsEarned != null) 'stars_earned': starsEarned,
    });
  }

  DailyJourneysCompanion copyWith({
    Value<int>? id,
    Value<int>? profileId,
    Value<String>? localDateKey,
    Value<int>? currentIndex,
    Value<int>? completedCount,
    Value<int>? starsEarned,
  }) {
    return DailyJourneysCompanion(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      localDateKey: localDateKey ?? this.localDateKey,
      currentIndex: currentIndex ?? this.currentIndex,
      completedCount: completedCount ?? this.completedCount,
      starsEarned: starsEarned ?? this.starsEarned,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<int>(profileId.value);
    }
    if (localDateKey.present) {
      map['local_date_key'] = Variable<String>(localDateKey.value);
    }
    if (currentIndex.present) {
      map['current_index'] = Variable<int>(currentIndex.value);
    }
    if (completedCount.present) {
      map['completed_count'] = Variable<int>(completedCount.value);
    }
    if (starsEarned.present) {
      map['stars_earned'] = Variable<int>(starsEarned.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyJourneysCompanion(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('localDateKey: $localDateKey, ')
          ..write('currentIndex: $currentIndex, ')
          ..write('completedCount: $completedCount, ')
          ..write('starsEarned: $starsEarned')
          ..write(')'))
        .toString();
  }
}

class $DailyJourneyItemsTable extends DailyJourneyItems
    with TableInfo<$DailyJourneyItemsTable, DailyJourneyItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyJourneyItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _journeyIdMeta = const VerificationMeta(
    'journeyId',
  );
  @override
  late final GeneratedColumn<int> journeyId = GeneratedColumn<int>(
    'journey_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES daily_journeys (id)',
    ),
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _activityIdMeta = const VerificationMeta(
    'activityId',
  );
  @override
  late final GeneratedColumn<String> activityId = GeneratedColumn<String>(
    'activity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('current'),
  );
  static const VerificationMeta _doneMeta = const VerificationMeta('done');
  @override
  late final GeneratedColumn<bool> done = GeneratedColumn<bool>(
    'done',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("done" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    journeyId,
    position,
    activityId,
    role,
    done,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_journey_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<DailyJourneyItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('journey_id')) {
      context.handle(
        _journeyIdMeta,
        journeyId.isAcceptableOrUnknown(data['journey_id']!, _journeyIdMeta),
      );
    } else if (isInserting) {
      context.missing(_journeyIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('activity_id')) {
      context.handle(
        _activityIdMeta,
        activityId.isAcceptableOrUnknown(data['activity_id']!, _activityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_activityIdMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    }
    if (data.containsKey('done')) {
      context.handle(
        _doneMeta,
        done.isAcceptableOrUnknown(data['done']!, _doneMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {journeyId, position};
  @override
  DailyJourneyItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyJourneyItem(
      journeyId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}journey_id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      activityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}activity_id'],
      )!,
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
      done: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}done'],
      )!,
    );
  }

  @override
  $DailyJourneyItemsTable createAlias(String alias) {
    return $DailyJourneyItemsTable(attachedDatabase, alias);
  }
}

class DailyJourneyItem extends DataClass
    implements Insertable<DailyJourneyItem> {
  final int journeyId;
  final int position;
  final String activityId;
  final String role;
  final bool done;
  const DailyJourneyItem({
    required this.journeyId,
    required this.position,
    required this.activityId,
    required this.role,
    required this.done,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['journey_id'] = Variable<int>(journeyId);
    map['position'] = Variable<int>(position);
    map['activity_id'] = Variable<String>(activityId);
    map['role'] = Variable<String>(role);
    map['done'] = Variable<bool>(done);
    return map;
  }

  DailyJourneyItemsCompanion toCompanion(bool nullToAbsent) {
    return DailyJourneyItemsCompanion(
      journeyId: Value(journeyId),
      position: Value(position),
      activityId: Value(activityId),
      role: Value(role),
      done: Value(done),
    );
  }

  factory DailyJourneyItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyJourneyItem(
      journeyId: serializer.fromJson<int>(json['journeyId']),
      position: serializer.fromJson<int>(json['position']),
      activityId: serializer.fromJson<String>(json['activityId']),
      role: serializer.fromJson<String>(json['role']),
      done: serializer.fromJson<bool>(json['done']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'journeyId': serializer.toJson<int>(journeyId),
      'position': serializer.toJson<int>(position),
      'activityId': serializer.toJson<String>(activityId),
      'role': serializer.toJson<String>(role),
      'done': serializer.toJson<bool>(done),
    };
  }

  DailyJourneyItem copyWith({
    int? journeyId,
    int? position,
    String? activityId,
    String? role,
    bool? done,
  }) => DailyJourneyItem(
    journeyId: journeyId ?? this.journeyId,
    position: position ?? this.position,
    activityId: activityId ?? this.activityId,
    role: role ?? this.role,
    done: done ?? this.done,
  );
  DailyJourneyItem copyWithCompanion(DailyJourneyItemsCompanion data) {
    return DailyJourneyItem(
      journeyId: data.journeyId.present ? data.journeyId.value : this.journeyId,
      position: data.position.present ? data.position.value : this.position,
      activityId: data.activityId.present
          ? data.activityId.value
          : this.activityId,
      role: data.role.present ? data.role.value : this.role,
      done: data.done.present ? data.done.value : this.done,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyJourneyItem(')
          ..write('journeyId: $journeyId, ')
          ..write('position: $position, ')
          ..write('activityId: $activityId, ')
          ..write('role: $role, ')
          ..write('done: $done')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(journeyId, position, activityId, role, done);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyJourneyItem &&
          other.journeyId == this.journeyId &&
          other.position == this.position &&
          other.activityId == this.activityId &&
          other.role == this.role &&
          other.done == this.done);
}

class DailyJourneyItemsCompanion extends UpdateCompanion<DailyJourneyItem> {
  final Value<int> journeyId;
  final Value<int> position;
  final Value<String> activityId;
  final Value<String> role;
  final Value<bool> done;
  final Value<int> rowid;
  const DailyJourneyItemsCompanion({
    this.journeyId = const Value.absent(),
    this.position = const Value.absent(),
    this.activityId = const Value.absent(),
    this.role = const Value.absent(),
    this.done = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DailyJourneyItemsCompanion.insert({
    required int journeyId,
    required int position,
    required String activityId,
    this.role = const Value.absent(),
    this.done = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : journeyId = Value(journeyId),
       position = Value(position),
       activityId = Value(activityId);
  static Insertable<DailyJourneyItem> custom({
    Expression<int>? journeyId,
    Expression<int>? position,
    Expression<String>? activityId,
    Expression<String>? role,
    Expression<bool>? done,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (journeyId != null) 'journey_id': journeyId,
      if (position != null) 'position': position,
      if (activityId != null) 'activity_id': activityId,
      if (role != null) 'role': role,
      if (done != null) 'done': done,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DailyJourneyItemsCompanion copyWith({
    Value<int>? journeyId,
    Value<int>? position,
    Value<String>? activityId,
    Value<String>? role,
    Value<bool>? done,
    Value<int>? rowid,
  }) {
    return DailyJourneyItemsCompanion(
      journeyId: journeyId ?? this.journeyId,
      position: position ?? this.position,
      activityId: activityId ?? this.activityId,
      role: role ?? this.role,
      done: done ?? this.done,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (journeyId.present) {
      map['journey_id'] = Variable<int>(journeyId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (activityId.present) {
      map['activity_id'] = Variable<String>(activityId.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (done.present) {
      map['done'] = Variable<bool>(done.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyJourneyItemsCompanion(')
          ..write('journeyId: $journeyId, ')
          ..write('position: $position, ')
          ..write('activityId: $activityId, ')
          ..write('role: $role, ')
          ..write('done: $done, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RewardsTable extends Rewards with TableInfo<$RewardsTable, Reward> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RewardsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<int> profileId = GeneratedColumn<int>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES child_profiles (id)',
    ),
  );
  static const VerificationMeta _rewardIdMeta = const VerificationMeta(
    'rewardId',
  );
  @override
  late final GeneratedColumn<String> rewardId = GeneratedColumn<String>(
    'reward_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unlockedAtMeta = const VerificationMeta(
    'unlockedAt',
  );
  @override
  late final GeneratedColumn<int> unlockedAt = GeneratedColumn<int>(
    'unlocked_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [profileId, rewardId, unlockedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'rewards';
  @override
  VerificationContext validateIntegrity(
    Insertable<Reward> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('reward_id')) {
      context.handle(
        _rewardIdMeta,
        rewardId.isAcceptableOrUnknown(data['reward_id']!, _rewardIdMeta),
      );
    } else if (isInserting) {
      context.missing(_rewardIdMeta);
    }
    if (data.containsKey('unlocked_at')) {
      context.handle(
        _unlockedAtMeta,
        unlockedAt.isAcceptableOrUnknown(data['unlocked_at']!, _unlockedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_unlockedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {profileId, rewardId};
  @override
  Reward map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Reward(
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}profile_id'],
      )!,
      rewardId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reward_id'],
      )!,
      unlockedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}unlocked_at'],
      )!,
    );
  }

  @override
  $RewardsTable createAlias(String alias) {
    return $RewardsTable(attachedDatabase, alias);
  }
}

class Reward extends DataClass implements Insertable<Reward> {
  final int profileId;
  final String rewardId;
  final int unlockedAt;
  const Reward({
    required this.profileId,
    required this.rewardId,
    required this.unlockedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['profile_id'] = Variable<int>(profileId);
    map['reward_id'] = Variable<String>(rewardId);
    map['unlocked_at'] = Variable<int>(unlockedAt);
    return map;
  }

  RewardsCompanion toCompanion(bool nullToAbsent) {
    return RewardsCompanion(
      profileId: Value(profileId),
      rewardId: Value(rewardId),
      unlockedAt: Value(unlockedAt),
    );
  }

  factory Reward.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Reward(
      profileId: serializer.fromJson<int>(json['profileId']),
      rewardId: serializer.fromJson<String>(json['rewardId']),
      unlockedAt: serializer.fromJson<int>(json['unlockedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'profileId': serializer.toJson<int>(profileId),
      'rewardId': serializer.toJson<String>(rewardId),
      'unlockedAt': serializer.toJson<int>(unlockedAt),
    };
  }

  Reward copyWith({int? profileId, String? rewardId, int? unlockedAt}) =>
      Reward(
        profileId: profileId ?? this.profileId,
        rewardId: rewardId ?? this.rewardId,
        unlockedAt: unlockedAt ?? this.unlockedAt,
      );
  Reward copyWithCompanion(RewardsCompanion data) {
    return Reward(
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      rewardId: data.rewardId.present ? data.rewardId.value : this.rewardId,
      unlockedAt: data.unlockedAt.present
          ? data.unlockedAt.value
          : this.unlockedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Reward(')
          ..write('profileId: $profileId, ')
          ..write('rewardId: $rewardId, ')
          ..write('unlockedAt: $unlockedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(profileId, rewardId, unlockedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Reward &&
          other.profileId == this.profileId &&
          other.rewardId == this.rewardId &&
          other.unlockedAt == this.unlockedAt);
}

class RewardsCompanion extends UpdateCompanion<Reward> {
  final Value<int> profileId;
  final Value<String> rewardId;
  final Value<int> unlockedAt;
  final Value<int> rowid;
  const RewardsCompanion({
    this.profileId = const Value.absent(),
    this.rewardId = const Value.absent(),
    this.unlockedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RewardsCompanion.insert({
    required int profileId,
    required String rewardId,
    required int unlockedAt,
    this.rowid = const Value.absent(),
  }) : profileId = Value(profileId),
       rewardId = Value(rewardId),
       unlockedAt = Value(unlockedAt);
  static Insertable<Reward> custom({
    Expression<int>? profileId,
    Expression<String>? rewardId,
    Expression<int>? unlockedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (profileId != null) 'profile_id': profileId,
      if (rewardId != null) 'reward_id': rewardId,
      if (unlockedAt != null) 'unlocked_at': unlockedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RewardsCompanion copyWith({
    Value<int>? profileId,
    Value<String>? rewardId,
    Value<int>? unlockedAt,
    Value<int>? rowid,
  }) {
    return RewardsCompanion(
      profileId: profileId ?? this.profileId,
      rewardId: rewardId ?? this.rewardId,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (profileId.present) {
      map['profile_id'] = Variable<int>(profileId.value);
    }
    if (rewardId.present) {
      map['reward_id'] = Variable<String>(rewardId.value);
    }
    if (unlockedAt.present) {
      map['unlocked_at'] = Variable<int>(unlockedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RewardsCompanion(')
          ..write('profileId: $profileId, ')
          ..write('rewardId: $rewardId, ')
          ..write('unlockedAt: $unlockedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PracticeDaysTable extends PracticeDays
    with TableInfo<$PracticeDaysTable, PracticeDay> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PracticeDaysTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<int> profileId = GeneratedColumn<int>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES child_profiles (id)',
    ),
  );
  static const VerificationMeta _localDateKeyMeta = const VerificationMeta(
    'localDateKey',
  );
  @override
  late final GeneratedColumn<String> localDateKey = GeneratedColumn<String>(
    'local_date_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [profileId, localDateKey];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'practice_days';
  @override
  VerificationContext validateIntegrity(
    Insertable<PracticeDay> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('local_date_key')) {
      context.handle(
        _localDateKeyMeta,
        localDateKey.isAcceptableOrUnknown(
          data['local_date_key']!,
          _localDateKeyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_localDateKeyMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {profileId, localDateKey};
  @override
  PracticeDay map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PracticeDay(
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}profile_id'],
      )!,
      localDateKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_date_key'],
      )!,
    );
  }

  @override
  $PracticeDaysTable createAlias(String alias) {
    return $PracticeDaysTable(attachedDatabase, alias);
  }
}

class PracticeDay extends DataClass implements Insertable<PracticeDay> {
  final int profileId;
  final String localDateKey;
  const PracticeDay({required this.profileId, required this.localDateKey});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['profile_id'] = Variable<int>(profileId);
    map['local_date_key'] = Variable<String>(localDateKey);
    return map;
  }

  PracticeDaysCompanion toCompanion(bool nullToAbsent) {
    return PracticeDaysCompanion(
      profileId: Value(profileId),
      localDateKey: Value(localDateKey),
    );
  }

  factory PracticeDay.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PracticeDay(
      profileId: serializer.fromJson<int>(json['profileId']),
      localDateKey: serializer.fromJson<String>(json['localDateKey']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'profileId': serializer.toJson<int>(profileId),
      'localDateKey': serializer.toJson<String>(localDateKey),
    };
  }

  PracticeDay copyWith({int? profileId, String? localDateKey}) => PracticeDay(
    profileId: profileId ?? this.profileId,
    localDateKey: localDateKey ?? this.localDateKey,
  );
  PracticeDay copyWithCompanion(PracticeDaysCompanion data) {
    return PracticeDay(
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      localDateKey: data.localDateKey.present
          ? data.localDateKey.value
          : this.localDateKey,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PracticeDay(')
          ..write('profileId: $profileId, ')
          ..write('localDateKey: $localDateKey')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(profileId, localDateKey);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PracticeDay &&
          other.profileId == this.profileId &&
          other.localDateKey == this.localDateKey);
}

class PracticeDaysCompanion extends UpdateCompanion<PracticeDay> {
  final Value<int> profileId;
  final Value<String> localDateKey;
  final Value<int> rowid;
  const PracticeDaysCompanion({
    this.profileId = const Value.absent(),
    this.localDateKey = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PracticeDaysCompanion.insert({
    required int profileId,
    required String localDateKey,
    this.rowid = const Value.absent(),
  }) : profileId = Value(profileId),
       localDateKey = Value(localDateKey);
  static Insertable<PracticeDay> custom({
    Expression<int>? profileId,
    Expression<String>? localDateKey,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (profileId != null) 'profile_id': profileId,
      if (localDateKey != null) 'local_date_key': localDateKey,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PracticeDaysCompanion copyWith({
    Value<int>? profileId,
    Value<String>? localDateKey,
    Value<int>? rowid,
  }) {
    return PracticeDaysCompanion(
      profileId: profileId ?? this.profileId,
      localDateKey: localDateKey ?? this.localDateKey,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (profileId.present) {
      map['profile_id'] = Variable<int>(profileId.value);
    }
    if (localDateKey.present) {
      map['local_date_key'] = Variable<String>(localDateKey.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PracticeDaysCompanion(')
          ..write('profileId: $profileId, ')
          ..write('localDateKey: $localDateKey, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EntitlementCacheEntriesTable extends EntitlementCacheEntries
    with TableInfo<$EntitlementCacheEntriesTable, EntitlementCacheEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EntitlementCacheEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
    'product_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _expiryMillisMeta = const VerificationMeta(
    'expiryMillis',
  );
  @override
  late final GeneratedColumn<int> expiryMillis = GeneratedColumn<int>(
    'expiry_millis',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastReconciledAtMeta = const VerificationMeta(
    'lastReconciledAt',
  );
  @override
  late final GeneratedColumn<int> lastReconciledAt = GeneratedColumn<int>(
    'last_reconciled_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    productId,
    status,
    expiryMillis,
    lastReconciledAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'entitlement_cache_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<EntitlementCacheEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('expiry_millis')) {
      context.handle(
        _expiryMillisMeta,
        expiryMillis.isAcceptableOrUnknown(
          data['expiry_millis']!,
          _expiryMillisMeta,
        ),
      );
    }
    if (data.containsKey('last_reconciled_at')) {
      context.handle(
        _lastReconciledAtMeta,
        lastReconciledAt.isAcceptableOrUnknown(
          data['last_reconciled_at']!,
          _lastReconciledAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EntitlementCacheEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EntitlementCacheEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_id'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      expiryMillis: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}expiry_millis'],
      ),
      lastReconciledAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_reconciled_at'],
      ),
    );
  }

  @override
  $EntitlementCacheEntriesTable createAlias(String alias) {
    return $EntitlementCacheEntriesTable(attachedDatabase, alias);
  }
}

class EntitlementCacheEntry extends DataClass
    implements Insertable<EntitlementCacheEntry> {
  final int id;
  final String? productId;
  final String status;
  final int? expiryMillis;
  final int? lastReconciledAt;
  const EntitlementCacheEntry({
    required this.id,
    this.productId,
    required this.status,
    this.expiryMillis,
    this.lastReconciledAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || productId != null) {
      map['product_id'] = Variable<String>(productId);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || expiryMillis != null) {
      map['expiry_millis'] = Variable<int>(expiryMillis);
    }
    if (!nullToAbsent || lastReconciledAt != null) {
      map['last_reconciled_at'] = Variable<int>(lastReconciledAt);
    }
    return map;
  }

  EntitlementCacheEntriesCompanion toCompanion(bool nullToAbsent) {
    return EntitlementCacheEntriesCompanion(
      id: Value(id),
      productId: productId == null && nullToAbsent
          ? const Value.absent()
          : Value(productId),
      status: Value(status),
      expiryMillis: expiryMillis == null && nullToAbsent
          ? const Value.absent()
          : Value(expiryMillis),
      lastReconciledAt: lastReconciledAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastReconciledAt),
    );
  }

  factory EntitlementCacheEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EntitlementCacheEntry(
      id: serializer.fromJson<int>(json['id']),
      productId: serializer.fromJson<String?>(json['productId']),
      status: serializer.fromJson<String>(json['status']),
      expiryMillis: serializer.fromJson<int?>(json['expiryMillis']),
      lastReconciledAt: serializer.fromJson<int?>(json['lastReconciledAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'productId': serializer.toJson<String?>(productId),
      'status': serializer.toJson<String>(status),
      'expiryMillis': serializer.toJson<int?>(expiryMillis),
      'lastReconciledAt': serializer.toJson<int?>(lastReconciledAt),
    };
  }

  EntitlementCacheEntry copyWith({
    int? id,
    Value<String?> productId = const Value.absent(),
    String? status,
    Value<int?> expiryMillis = const Value.absent(),
    Value<int?> lastReconciledAt = const Value.absent(),
  }) => EntitlementCacheEntry(
    id: id ?? this.id,
    productId: productId.present ? productId.value : this.productId,
    status: status ?? this.status,
    expiryMillis: expiryMillis.present ? expiryMillis.value : this.expiryMillis,
    lastReconciledAt: lastReconciledAt.present
        ? lastReconciledAt.value
        : this.lastReconciledAt,
  );
  EntitlementCacheEntry copyWithCompanion(
    EntitlementCacheEntriesCompanion data,
  ) {
    return EntitlementCacheEntry(
      id: data.id.present ? data.id.value : this.id,
      productId: data.productId.present ? data.productId.value : this.productId,
      status: data.status.present ? data.status.value : this.status,
      expiryMillis: data.expiryMillis.present
          ? data.expiryMillis.value
          : this.expiryMillis,
      lastReconciledAt: data.lastReconciledAt.present
          ? data.lastReconciledAt.value
          : this.lastReconciledAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EntitlementCacheEntry(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('status: $status, ')
          ..write('expiryMillis: $expiryMillis, ')
          ..write('lastReconciledAt: $lastReconciledAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, productId, status, expiryMillis, lastReconciledAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EntitlementCacheEntry &&
          other.id == this.id &&
          other.productId == this.productId &&
          other.status == this.status &&
          other.expiryMillis == this.expiryMillis &&
          other.lastReconciledAt == this.lastReconciledAt);
}

class EntitlementCacheEntriesCompanion
    extends UpdateCompanion<EntitlementCacheEntry> {
  final Value<int> id;
  final Value<String?> productId;
  final Value<String> status;
  final Value<int?> expiryMillis;
  final Value<int?> lastReconciledAt;
  const EntitlementCacheEntriesCompanion({
    this.id = const Value.absent(),
    this.productId = const Value.absent(),
    this.status = const Value.absent(),
    this.expiryMillis = const Value.absent(),
    this.lastReconciledAt = const Value.absent(),
  });
  EntitlementCacheEntriesCompanion.insert({
    this.id = const Value.absent(),
    this.productId = const Value.absent(),
    required String status,
    this.expiryMillis = const Value.absent(),
    this.lastReconciledAt = const Value.absent(),
  }) : status = Value(status);
  static Insertable<EntitlementCacheEntry> custom({
    Expression<int>? id,
    Expression<String>? productId,
    Expression<String>? status,
    Expression<int>? expiryMillis,
    Expression<int>? lastReconciledAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (productId != null) 'product_id': productId,
      if (status != null) 'status': status,
      if (expiryMillis != null) 'expiry_millis': expiryMillis,
      if (lastReconciledAt != null) 'last_reconciled_at': lastReconciledAt,
    });
  }

  EntitlementCacheEntriesCompanion copyWith({
    Value<int>? id,
    Value<String?>? productId,
    Value<String>? status,
    Value<int?>? expiryMillis,
    Value<int?>? lastReconciledAt,
  }) {
    return EntitlementCacheEntriesCompanion(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      status: status ?? this.status,
      expiryMillis: expiryMillis ?? this.expiryMillis,
      lastReconciledAt: lastReconciledAt ?? this.lastReconciledAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (expiryMillis.present) {
      map['expiry_millis'] = Variable<int>(expiryMillis.value);
    }
    if (lastReconciledAt.present) {
      map['last_reconciled_at'] = Variable<int>(lastReconciledAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EntitlementCacheEntriesCompanion(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('status: $status, ')
          ..write('expiryMillis: $expiryMillis, ')
          ..write('lastReconciledAt: $lastReconciledAt')
          ..write(')'))
        .toString();
  }
}

class $LocalSettingsTable extends LocalSettings
    with TableInfo<$LocalSettingsTable, LocalSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _soundEffectsEnabledMeta =
      const VerificationMeta('soundEffectsEnabled');
  @override
  late final GeneratedColumn<bool> soundEffectsEnabled = GeneratedColumn<bool>(
    'sound_effects_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("sound_effects_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _musicEnabledMeta = const VerificationMeta(
    'musicEnabled',
  );
  @override
  late final GeneratedColumn<bool> musicEnabled = GeneratedColumn<bool>(
    'music_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("music_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _narrationEnabledMeta = const VerificationMeta(
    'narrationEnabled',
  );
  @override
  late final GeneratedColumn<bool> narrationEnabled = GeneratedColumn<bool>(
    'narration_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("narration_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _onboardingCompleteMeta =
      const VerificationMeta('onboardingComplete');
  @override
  late final GeneratedColumn<bool> onboardingComplete = GeneratedColumn<bool>(
    'onboarding_complete',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("onboarding_complete" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _onboardingStepMeta = const VerificationMeta(
    'onboardingStep',
  );
  @override
  late final GeneratedColumn<int> onboardingStep = GeneratedColumn<int>(
    'onboarding_step',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _draftAgeBandMeta = const VerificationMeta(
    'draftAgeBand',
  );
  @override
  late final GeneratedColumn<String> draftAgeBand = GeneratedColumn<String>(
    'draft_age_band',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _draftAvatarIdMeta = const VerificationMeta(
    'draftAvatarId',
  );
  @override
  late final GeneratedColumn<String> draftAvatarId = GeneratedColumn<String>(
    'draft_avatar_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _draftNicknameMeta = const VerificationMeta(
    'draftNickname',
  );
  @override
  late final GeneratedColumn<String> draftNickname = GeneratedColumn<String>(
    'draft_nickname',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _remindersEnabledMeta = const VerificationMeta(
    'remindersEnabled',
  );
  @override
  late final GeneratedColumn<bool> remindersEnabled = GeneratedColumn<bool>(
    'reminders_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("reminders_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _reminderMinutesMeta = const VerificationMeta(
    'reminderMinutes',
  );
  @override
  late final GeneratedColumn<int> reminderMinutes = GeneratedColumn<int>(
    'reminder_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(960),
  );
  static const VerificationMeta _reducedMotionMeta = const VerificationMeta(
    'reducedMotion',
  );
  @override
  late final GeneratedColumn<bool> reducedMotion = GeneratedColumn<bool>(
    'reduced_motion',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("reduced_motion" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _sessionLimitMinutesMeta =
      const VerificationMeta('sessionLimitMinutes');
  @override
  late final GeneratedColumn<int> sessionLimitMinutes = GeneratedColumn<int>(
    'session_limit_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    soundEffectsEnabled,
    musicEnabled,
    narrationEnabled,
    onboardingComplete,
    onboardingStep,
    draftAgeBand,
    draftAvatarId,
    draftNickname,
    remindersEnabled,
    reminderMinutes,
    reducedMotion,
    sessionLimitMinutes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('sound_effects_enabled')) {
      context.handle(
        _soundEffectsEnabledMeta,
        soundEffectsEnabled.isAcceptableOrUnknown(
          data['sound_effects_enabled']!,
          _soundEffectsEnabledMeta,
        ),
      );
    }
    if (data.containsKey('music_enabled')) {
      context.handle(
        _musicEnabledMeta,
        musicEnabled.isAcceptableOrUnknown(
          data['music_enabled']!,
          _musicEnabledMeta,
        ),
      );
    }
    if (data.containsKey('narration_enabled')) {
      context.handle(
        _narrationEnabledMeta,
        narrationEnabled.isAcceptableOrUnknown(
          data['narration_enabled']!,
          _narrationEnabledMeta,
        ),
      );
    }
    if (data.containsKey('onboarding_complete')) {
      context.handle(
        _onboardingCompleteMeta,
        onboardingComplete.isAcceptableOrUnknown(
          data['onboarding_complete']!,
          _onboardingCompleteMeta,
        ),
      );
    }
    if (data.containsKey('onboarding_step')) {
      context.handle(
        _onboardingStepMeta,
        onboardingStep.isAcceptableOrUnknown(
          data['onboarding_step']!,
          _onboardingStepMeta,
        ),
      );
    }
    if (data.containsKey('draft_age_band')) {
      context.handle(
        _draftAgeBandMeta,
        draftAgeBand.isAcceptableOrUnknown(
          data['draft_age_band']!,
          _draftAgeBandMeta,
        ),
      );
    }
    if (data.containsKey('draft_avatar_id')) {
      context.handle(
        _draftAvatarIdMeta,
        draftAvatarId.isAcceptableOrUnknown(
          data['draft_avatar_id']!,
          _draftAvatarIdMeta,
        ),
      );
    }
    if (data.containsKey('draft_nickname')) {
      context.handle(
        _draftNicknameMeta,
        draftNickname.isAcceptableOrUnknown(
          data['draft_nickname']!,
          _draftNicknameMeta,
        ),
      );
    }
    if (data.containsKey('reminders_enabled')) {
      context.handle(
        _remindersEnabledMeta,
        remindersEnabled.isAcceptableOrUnknown(
          data['reminders_enabled']!,
          _remindersEnabledMeta,
        ),
      );
    }
    if (data.containsKey('reminder_minutes')) {
      context.handle(
        _reminderMinutesMeta,
        reminderMinutes.isAcceptableOrUnknown(
          data['reminder_minutes']!,
          _reminderMinutesMeta,
        ),
      );
    }
    if (data.containsKey('reduced_motion')) {
      context.handle(
        _reducedMotionMeta,
        reducedMotion.isAcceptableOrUnknown(
          data['reduced_motion']!,
          _reducedMotionMeta,
        ),
      );
    }
    if (data.containsKey('session_limit_minutes')) {
      context.handle(
        _sessionLimitMinutesMeta,
        sessionLimitMinutes.isAcceptableOrUnknown(
          data['session_limit_minutes']!,
          _sessionLimitMinutesMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalSetting(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      soundEffectsEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}sound_effects_enabled'],
      )!,
      musicEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}music_enabled'],
      )!,
      narrationEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}narration_enabled'],
      )!,
      onboardingComplete: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}onboarding_complete'],
      )!,
      onboardingStep: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}onboarding_step'],
      )!,
      draftAgeBand: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}draft_age_band'],
      ),
      draftAvatarId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}draft_avatar_id'],
      ),
      draftNickname: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}draft_nickname'],
      ),
      remindersEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}reminders_enabled'],
      )!,
      reminderMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reminder_minutes'],
      )!,
      reducedMotion: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}reduced_motion'],
      )!,
      sessionLimitMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}session_limit_minutes'],
      )!,
    );
  }

  @override
  $LocalSettingsTable createAlias(String alias) {
    return $LocalSettingsTable(attachedDatabase, alias);
  }
}

class LocalSetting extends DataClass implements Insertable<LocalSetting> {
  final int id;
  final bool soundEffectsEnabled;
  final bool musicEnabled;
  final bool narrationEnabled;
  final bool onboardingComplete;
  final int onboardingStep;
  final String? draftAgeBand;
  final String? draftAvatarId;
  final String? draftNickname;
  final bool remindersEnabled;

  /// Minutes after local midnight. The reminder stays off until a grown-up
  /// turns it on.
  final int reminderMinutes;
  final bool reducedMotion;

  /// 0 means no gentle stop. This is an in-app suggestion, not device screen time.
  final int sessionLimitMinutes;
  const LocalSetting({
    required this.id,
    required this.soundEffectsEnabled,
    required this.musicEnabled,
    required this.narrationEnabled,
    required this.onboardingComplete,
    required this.onboardingStep,
    this.draftAgeBand,
    this.draftAvatarId,
    this.draftNickname,
    required this.remindersEnabled,
    required this.reminderMinutes,
    required this.reducedMotion,
    required this.sessionLimitMinutes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['sound_effects_enabled'] = Variable<bool>(soundEffectsEnabled);
    map['music_enabled'] = Variable<bool>(musicEnabled);
    map['narration_enabled'] = Variable<bool>(narrationEnabled);
    map['onboarding_complete'] = Variable<bool>(onboardingComplete);
    map['onboarding_step'] = Variable<int>(onboardingStep);
    if (!nullToAbsent || draftAgeBand != null) {
      map['draft_age_band'] = Variable<String>(draftAgeBand);
    }
    if (!nullToAbsent || draftAvatarId != null) {
      map['draft_avatar_id'] = Variable<String>(draftAvatarId);
    }
    if (!nullToAbsent || draftNickname != null) {
      map['draft_nickname'] = Variable<String>(draftNickname);
    }
    map['reminders_enabled'] = Variable<bool>(remindersEnabled);
    map['reminder_minutes'] = Variable<int>(reminderMinutes);
    map['reduced_motion'] = Variable<bool>(reducedMotion);
    map['session_limit_minutes'] = Variable<int>(sessionLimitMinutes);
    return map;
  }

  LocalSettingsCompanion toCompanion(bool nullToAbsent) {
    return LocalSettingsCompanion(
      id: Value(id),
      soundEffectsEnabled: Value(soundEffectsEnabled),
      musicEnabled: Value(musicEnabled),
      narrationEnabled: Value(narrationEnabled),
      onboardingComplete: Value(onboardingComplete),
      onboardingStep: Value(onboardingStep),
      draftAgeBand: draftAgeBand == null && nullToAbsent
          ? const Value.absent()
          : Value(draftAgeBand),
      draftAvatarId: draftAvatarId == null && nullToAbsent
          ? const Value.absent()
          : Value(draftAvatarId),
      draftNickname: draftNickname == null && nullToAbsent
          ? const Value.absent()
          : Value(draftNickname),
      remindersEnabled: Value(remindersEnabled),
      reminderMinutes: Value(reminderMinutes),
      reducedMotion: Value(reducedMotion),
      sessionLimitMinutes: Value(sessionLimitMinutes),
    );
  }

  factory LocalSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalSetting(
      id: serializer.fromJson<int>(json['id']),
      soundEffectsEnabled: serializer.fromJson<bool>(
        json['soundEffectsEnabled'],
      ),
      musicEnabled: serializer.fromJson<bool>(json['musicEnabled']),
      narrationEnabled: serializer.fromJson<bool>(json['narrationEnabled']),
      onboardingComplete: serializer.fromJson<bool>(json['onboardingComplete']),
      onboardingStep: serializer.fromJson<int>(json['onboardingStep']),
      draftAgeBand: serializer.fromJson<String?>(json['draftAgeBand']),
      draftAvatarId: serializer.fromJson<String?>(json['draftAvatarId']),
      draftNickname: serializer.fromJson<String?>(json['draftNickname']),
      remindersEnabled: serializer.fromJson<bool>(json['remindersEnabled']),
      reminderMinutes: serializer.fromJson<int>(json['reminderMinutes']),
      reducedMotion: serializer.fromJson<bool>(json['reducedMotion']),
      sessionLimitMinutes: serializer.fromJson<int>(
        json['sessionLimitMinutes'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'soundEffectsEnabled': serializer.toJson<bool>(soundEffectsEnabled),
      'musicEnabled': serializer.toJson<bool>(musicEnabled),
      'narrationEnabled': serializer.toJson<bool>(narrationEnabled),
      'onboardingComplete': serializer.toJson<bool>(onboardingComplete),
      'onboardingStep': serializer.toJson<int>(onboardingStep),
      'draftAgeBand': serializer.toJson<String?>(draftAgeBand),
      'draftAvatarId': serializer.toJson<String?>(draftAvatarId),
      'draftNickname': serializer.toJson<String?>(draftNickname),
      'remindersEnabled': serializer.toJson<bool>(remindersEnabled),
      'reminderMinutes': serializer.toJson<int>(reminderMinutes),
      'reducedMotion': serializer.toJson<bool>(reducedMotion),
      'sessionLimitMinutes': serializer.toJson<int>(sessionLimitMinutes),
    };
  }

  LocalSetting copyWith({
    int? id,
    bool? soundEffectsEnabled,
    bool? musicEnabled,
    bool? narrationEnabled,
    bool? onboardingComplete,
    int? onboardingStep,
    Value<String?> draftAgeBand = const Value.absent(),
    Value<String?> draftAvatarId = const Value.absent(),
    Value<String?> draftNickname = const Value.absent(),
    bool? remindersEnabled,
    int? reminderMinutes,
    bool? reducedMotion,
    int? sessionLimitMinutes,
  }) => LocalSetting(
    id: id ?? this.id,
    soundEffectsEnabled: soundEffectsEnabled ?? this.soundEffectsEnabled,
    musicEnabled: musicEnabled ?? this.musicEnabled,
    narrationEnabled: narrationEnabled ?? this.narrationEnabled,
    onboardingComplete: onboardingComplete ?? this.onboardingComplete,
    onboardingStep: onboardingStep ?? this.onboardingStep,
    draftAgeBand: draftAgeBand.present ? draftAgeBand.value : this.draftAgeBand,
    draftAvatarId: draftAvatarId.present
        ? draftAvatarId.value
        : this.draftAvatarId,
    draftNickname: draftNickname.present
        ? draftNickname.value
        : this.draftNickname,
    remindersEnabled: remindersEnabled ?? this.remindersEnabled,
    reminderMinutes: reminderMinutes ?? this.reminderMinutes,
    reducedMotion: reducedMotion ?? this.reducedMotion,
    sessionLimitMinutes: sessionLimitMinutes ?? this.sessionLimitMinutes,
  );
  LocalSetting copyWithCompanion(LocalSettingsCompanion data) {
    return LocalSetting(
      id: data.id.present ? data.id.value : this.id,
      soundEffectsEnabled: data.soundEffectsEnabled.present
          ? data.soundEffectsEnabled.value
          : this.soundEffectsEnabled,
      musicEnabled: data.musicEnabled.present
          ? data.musicEnabled.value
          : this.musicEnabled,
      narrationEnabled: data.narrationEnabled.present
          ? data.narrationEnabled.value
          : this.narrationEnabled,
      onboardingComplete: data.onboardingComplete.present
          ? data.onboardingComplete.value
          : this.onboardingComplete,
      onboardingStep: data.onboardingStep.present
          ? data.onboardingStep.value
          : this.onboardingStep,
      draftAgeBand: data.draftAgeBand.present
          ? data.draftAgeBand.value
          : this.draftAgeBand,
      draftAvatarId: data.draftAvatarId.present
          ? data.draftAvatarId.value
          : this.draftAvatarId,
      draftNickname: data.draftNickname.present
          ? data.draftNickname.value
          : this.draftNickname,
      remindersEnabled: data.remindersEnabled.present
          ? data.remindersEnabled.value
          : this.remindersEnabled,
      reminderMinutes: data.reminderMinutes.present
          ? data.reminderMinutes.value
          : this.reminderMinutes,
      reducedMotion: data.reducedMotion.present
          ? data.reducedMotion.value
          : this.reducedMotion,
      sessionLimitMinutes: data.sessionLimitMinutes.present
          ? data.sessionLimitMinutes.value
          : this.sessionLimitMinutes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalSetting(')
          ..write('id: $id, ')
          ..write('soundEffectsEnabled: $soundEffectsEnabled, ')
          ..write('musicEnabled: $musicEnabled, ')
          ..write('narrationEnabled: $narrationEnabled, ')
          ..write('onboardingComplete: $onboardingComplete, ')
          ..write('onboardingStep: $onboardingStep, ')
          ..write('draftAgeBand: $draftAgeBand, ')
          ..write('draftAvatarId: $draftAvatarId, ')
          ..write('draftNickname: $draftNickname, ')
          ..write('remindersEnabled: $remindersEnabled, ')
          ..write('reminderMinutes: $reminderMinutes, ')
          ..write('reducedMotion: $reducedMotion, ')
          ..write('sessionLimitMinutes: $sessionLimitMinutes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    soundEffectsEnabled,
    musicEnabled,
    narrationEnabled,
    onboardingComplete,
    onboardingStep,
    draftAgeBand,
    draftAvatarId,
    draftNickname,
    remindersEnabled,
    reminderMinutes,
    reducedMotion,
    sessionLimitMinutes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalSetting &&
          other.id == this.id &&
          other.soundEffectsEnabled == this.soundEffectsEnabled &&
          other.musicEnabled == this.musicEnabled &&
          other.narrationEnabled == this.narrationEnabled &&
          other.onboardingComplete == this.onboardingComplete &&
          other.onboardingStep == this.onboardingStep &&
          other.draftAgeBand == this.draftAgeBand &&
          other.draftAvatarId == this.draftAvatarId &&
          other.draftNickname == this.draftNickname &&
          other.remindersEnabled == this.remindersEnabled &&
          other.reminderMinutes == this.reminderMinutes &&
          other.reducedMotion == this.reducedMotion &&
          other.sessionLimitMinutes == this.sessionLimitMinutes);
}

class LocalSettingsCompanion extends UpdateCompanion<LocalSetting> {
  final Value<int> id;
  final Value<bool> soundEffectsEnabled;
  final Value<bool> musicEnabled;
  final Value<bool> narrationEnabled;
  final Value<bool> onboardingComplete;
  final Value<int> onboardingStep;
  final Value<String?> draftAgeBand;
  final Value<String?> draftAvatarId;
  final Value<String?> draftNickname;
  final Value<bool> remindersEnabled;
  final Value<int> reminderMinutes;
  final Value<bool> reducedMotion;
  final Value<int> sessionLimitMinutes;
  const LocalSettingsCompanion({
    this.id = const Value.absent(),
    this.soundEffectsEnabled = const Value.absent(),
    this.musicEnabled = const Value.absent(),
    this.narrationEnabled = const Value.absent(),
    this.onboardingComplete = const Value.absent(),
    this.onboardingStep = const Value.absent(),
    this.draftAgeBand = const Value.absent(),
    this.draftAvatarId = const Value.absent(),
    this.draftNickname = const Value.absent(),
    this.remindersEnabled = const Value.absent(),
    this.reminderMinutes = const Value.absent(),
    this.reducedMotion = const Value.absent(),
    this.sessionLimitMinutes = const Value.absent(),
  });
  LocalSettingsCompanion.insert({
    this.id = const Value.absent(),
    this.soundEffectsEnabled = const Value.absent(),
    this.musicEnabled = const Value.absent(),
    this.narrationEnabled = const Value.absent(),
    this.onboardingComplete = const Value.absent(),
    this.onboardingStep = const Value.absent(),
    this.draftAgeBand = const Value.absent(),
    this.draftAvatarId = const Value.absent(),
    this.draftNickname = const Value.absent(),
    this.remindersEnabled = const Value.absent(),
    this.reminderMinutes = const Value.absent(),
    this.reducedMotion = const Value.absent(),
    this.sessionLimitMinutes = const Value.absent(),
  });
  static Insertable<LocalSetting> custom({
    Expression<int>? id,
    Expression<bool>? soundEffectsEnabled,
    Expression<bool>? musicEnabled,
    Expression<bool>? narrationEnabled,
    Expression<bool>? onboardingComplete,
    Expression<int>? onboardingStep,
    Expression<String>? draftAgeBand,
    Expression<String>? draftAvatarId,
    Expression<String>? draftNickname,
    Expression<bool>? remindersEnabled,
    Expression<int>? reminderMinutes,
    Expression<bool>? reducedMotion,
    Expression<int>? sessionLimitMinutes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (soundEffectsEnabled != null)
        'sound_effects_enabled': soundEffectsEnabled,
      if (musicEnabled != null) 'music_enabled': musicEnabled,
      if (narrationEnabled != null) 'narration_enabled': narrationEnabled,
      if (onboardingComplete != null) 'onboarding_complete': onboardingComplete,
      if (onboardingStep != null) 'onboarding_step': onboardingStep,
      if (draftAgeBand != null) 'draft_age_band': draftAgeBand,
      if (draftAvatarId != null) 'draft_avatar_id': draftAvatarId,
      if (draftNickname != null) 'draft_nickname': draftNickname,
      if (remindersEnabled != null) 'reminders_enabled': remindersEnabled,
      if (reminderMinutes != null) 'reminder_minutes': reminderMinutes,
      if (reducedMotion != null) 'reduced_motion': reducedMotion,
      if (sessionLimitMinutes != null)
        'session_limit_minutes': sessionLimitMinutes,
    });
  }

  LocalSettingsCompanion copyWith({
    Value<int>? id,
    Value<bool>? soundEffectsEnabled,
    Value<bool>? musicEnabled,
    Value<bool>? narrationEnabled,
    Value<bool>? onboardingComplete,
    Value<int>? onboardingStep,
    Value<String?>? draftAgeBand,
    Value<String?>? draftAvatarId,
    Value<String?>? draftNickname,
    Value<bool>? remindersEnabled,
    Value<int>? reminderMinutes,
    Value<bool>? reducedMotion,
    Value<int>? sessionLimitMinutes,
  }) {
    return LocalSettingsCompanion(
      id: id ?? this.id,
      soundEffectsEnabled: soundEffectsEnabled ?? this.soundEffectsEnabled,
      musicEnabled: musicEnabled ?? this.musicEnabled,
      narrationEnabled: narrationEnabled ?? this.narrationEnabled,
      onboardingComplete: onboardingComplete ?? this.onboardingComplete,
      onboardingStep: onboardingStep ?? this.onboardingStep,
      draftAgeBand: draftAgeBand ?? this.draftAgeBand,
      draftAvatarId: draftAvatarId ?? this.draftAvatarId,
      draftNickname: draftNickname ?? this.draftNickname,
      remindersEnabled: remindersEnabled ?? this.remindersEnabled,
      reminderMinutes: reminderMinutes ?? this.reminderMinutes,
      reducedMotion: reducedMotion ?? this.reducedMotion,
      sessionLimitMinutes: sessionLimitMinutes ?? this.sessionLimitMinutes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (soundEffectsEnabled.present) {
      map['sound_effects_enabled'] = Variable<bool>(soundEffectsEnabled.value);
    }
    if (musicEnabled.present) {
      map['music_enabled'] = Variable<bool>(musicEnabled.value);
    }
    if (narrationEnabled.present) {
      map['narration_enabled'] = Variable<bool>(narrationEnabled.value);
    }
    if (onboardingComplete.present) {
      map['onboarding_complete'] = Variable<bool>(onboardingComplete.value);
    }
    if (onboardingStep.present) {
      map['onboarding_step'] = Variable<int>(onboardingStep.value);
    }
    if (draftAgeBand.present) {
      map['draft_age_band'] = Variable<String>(draftAgeBand.value);
    }
    if (draftAvatarId.present) {
      map['draft_avatar_id'] = Variable<String>(draftAvatarId.value);
    }
    if (draftNickname.present) {
      map['draft_nickname'] = Variable<String>(draftNickname.value);
    }
    if (remindersEnabled.present) {
      map['reminders_enabled'] = Variable<bool>(remindersEnabled.value);
    }
    if (reminderMinutes.present) {
      map['reminder_minutes'] = Variable<int>(reminderMinutes.value);
    }
    if (reducedMotion.present) {
      map['reduced_motion'] = Variable<bool>(reducedMotion.value);
    }
    if (sessionLimitMinutes.present) {
      map['session_limit_minutes'] = Variable<int>(sessionLimitMinutes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalSettingsCompanion(')
          ..write('id: $id, ')
          ..write('soundEffectsEnabled: $soundEffectsEnabled, ')
          ..write('musicEnabled: $musicEnabled, ')
          ..write('narrationEnabled: $narrationEnabled, ')
          ..write('onboardingComplete: $onboardingComplete, ')
          ..write('onboardingStep: $onboardingStep, ')
          ..write('draftAgeBand: $draftAgeBand, ')
          ..write('draftAvatarId: $draftAvatarId, ')
          ..write('draftNickname: $draftNickname, ')
          ..write('remindersEnabled: $remindersEnabled, ')
          ..write('reminderMinutes: $reminderMinutes, ')
          ..write('reducedMotion: $reducedMotion, ')
          ..write('sessionLimitMinutes: $sessionLimitMinutes')
          ..write(')'))
        .toString();
  }
}

class $RecentGeneratedLevelsTable extends RecentGeneratedLevels
    with TableInfo<$RecentGeneratedLevelsTable, RecentGeneratedLevel> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecentGeneratedLevelsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<int> profileId = GeneratedColumn<int>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES child_profiles (id)',
    ),
  );
  static const VerificationMeta _engineTypeMeta = const VerificationMeta(
    'engineType',
  );
  @override
  late final GeneratedColumn<String> engineType = GeneratedColumn<String>(
    'engine_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _instanceIdMeta = const VerificationMeta(
    'instanceId',
  );
  @override
  late final GeneratedColumn<String> instanceId = GeneratedColumn<String>(
    'instance_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _playedAtMeta = const VerificationMeta(
    'playedAt',
  );
  @override
  late final GeneratedColumn<int> playedAt = GeneratedColumn<int>(
    'played_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    profileId,
    engineType,
    instanceId,
    playedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recent_generated_levels';
  @override
  VerificationContext validateIntegrity(
    Insertable<RecentGeneratedLevel> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('engine_type')) {
      context.handle(
        _engineTypeMeta,
        engineType.isAcceptableOrUnknown(data['engine_type']!, _engineTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_engineTypeMeta);
    }
    if (data.containsKey('instance_id')) {
      context.handle(
        _instanceIdMeta,
        instanceId.isAcceptableOrUnknown(data['instance_id']!, _instanceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_instanceIdMeta);
    }
    if (data.containsKey('played_at')) {
      context.handle(
        _playedAtMeta,
        playedAt.isAcceptableOrUnknown(data['played_at']!, _playedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_playedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RecentGeneratedLevel map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecentGeneratedLevel(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}profile_id'],
      )!,
      engineType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}engine_type'],
      )!,
      instanceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}instance_id'],
      )!,
      playedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}played_at'],
      )!,
    );
  }

  @override
  $RecentGeneratedLevelsTable createAlias(String alias) {
    return $RecentGeneratedLevelsTable(attachedDatabase, alias);
  }
}

class RecentGeneratedLevel extends DataClass
    implements Insertable<RecentGeneratedLevel> {
  final int id;
  final int profileId;
  final String engineType;
  final String instanceId;
  final int playedAt;
  const RecentGeneratedLevel({
    required this.id,
    required this.profileId,
    required this.engineType,
    required this.instanceId,
    required this.playedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['profile_id'] = Variable<int>(profileId);
    map['engine_type'] = Variable<String>(engineType);
    map['instance_id'] = Variable<String>(instanceId);
    map['played_at'] = Variable<int>(playedAt);
    return map;
  }

  RecentGeneratedLevelsCompanion toCompanion(bool nullToAbsent) {
    return RecentGeneratedLevelsCompanion(
      id: Value(id),
      profileId: Value(profileId),
      engineType: Value(engineType),
      instanceId: Value(instanceId),
      playedAt: Value(playedAt),
    );
  }

  factory RecentGeneratedLevel.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecentGeneratedLevel(
      id: serializer.fromJson<int>(json['id']),
      profileId: serializer.fromJson<int>(json['profileId']),
      engineType: serializer.fromJson<String>(json['engineType']),
      instanceId: serializer.fromJson<String>(json['instanceId']),
      playedAt: serializer.fromJson<int>(json['playedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'profileId': serializer.toJson<int>(profileId),
      'engineType': serializer.toJson<String>(engineType),
      'instanceId': serializer.toJson<String>(instanceId),
      'playedAt': serializer.toJson<int>(playedAt),
    };
  }

  RecentGeneratedLevel copyWith({
    int? id,
    int? profileId,
    String? engineType,
    String? instanceId,
    int? playedAt,
  }) => RecentGeneratedLevel(
    id: id ?? this.id,
    profileId: profileId ?? this.profileId,
    engineType: engineType ?? this.engineType,
    instanceId: instanceId ?? this.instanceId,
    playedAt: playedAt ?? this.playedAt,
  );
  RecentGeneratedLevel copyWithCompanion(RecentGeneratedLevelsCompanion data) {
    return RecentGeneratedLevel(
      id: data.id.present ? data.id.value : this.id,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      engineType: data.engineType.present
          ? data.engineType.value
          : this.engineType,
      instanceId: data.instanceId.present
          ? data.instanceId.value
          : this.instanceId,
      playedAt: data.playedAt.present ? data.playedAt.value : this.playedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecentGeneratedLevel(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('engineType: $engineType, ')
          ..write('instanceId: $instanceId, ')
          ..write('playedAt: $playedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, profileId, engineType, instanceId, playedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecentGeneratedLevel &&
          other.id == this.id &&
          other.profileId == this.profileId &&
          other.engineType == this.engineType &&
          other.instanceId == this.instanceId &&
          other.playedAt == this.playedAt);
}

class RecentGeneratedLevelsCompanion
    extends UpdateCompanion<RecentGeneratedLevel> {
  final Value<int> id;
  final Value<int> profileId;
  final Value<String> engineType;
  final Value<String> instanceId;
  final Value<int> playedAt;
  const RecentGeneratedLevelsCompanion({
    this.id = const Value.absent(),
    this.profileId = const Value.absent(),
    this.engineType = const Value.absent(),
    this.instanceId = const Value.absent(),
    this.playedAt = const Value.absent(),
  });
  RecentGeneratedLevelsCompanion.insert({
    this.id = const Value.absent(),
    required int profileId,
    required String engineType,
    required String instanceId,
    required int playedAt,
  }) : profileId = Value(profileId),
       engineType = Value(engineType),
       instanceId = Value(instanceId),
       playedAt = Value(playedAt);
  static Insertable<RecentGeneratedLevel> custom({
    Expression<int>? id,
    Expression<int>? profileId,
    Expression<String>? engineType,
    Expression<String>? instanceId,
    Expression<int>? playedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profileId != null) 'profile_id': profileId,
      if (engineType != null) 'engine_type': engineType,
      if (instanceId != null) 'instance_id': instanceId,
      if (playedAt != null) 'played_at': playedAt,
    });
  }

  RecentGeneratedLevelsCompanion copyWith({
    Value<int>? id,
    Value<int>? profileId,
    Value<String>? engineType,
    Value<String>? instanceId,
    Value<int>? playedAt,
  }) {
    return RecentGeneratedLevelsCompanion(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      engineType: engineType ?? this.engineType,
      instanceId: instanceId ?? this.instanceId,
      playedAt: playedAt ?? this.playedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<int>(profileId.value);
    }
    if (engineType.present) {
      map['engine_type'] = Variable<String>(engineType.value);
    }
    if (instanceId.present) {
      map['instance_id'] = Variable<String>(instanceId.value);
    }
    if (playedAt.present) {
      map['played_at'] = Variable<int>(playedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecentGeneratedLevelsCompanion(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('engineType: $engineType, ')
          ..write('instanceId: $instanceId, ')
          ..write('playedAt: $playedAt')
          ..write(')'))
        .toString();
  }
}

class $ActivityCheckpointsTable extends ActivityCheckpoints
    with TableInfo<$ActivityCheckpointsTable, ActivityCheckpoint> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActivityCheckpointsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<int> profileId = GeneratedColumn<int>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES child_profiles (id)',
    ),
  );
  static const VerificationMeta _activityIdMeta = const VerificationMeta(
    'activityId',
  );
  @override
  late final GeneratedColumn<String> activityId = GeneratedColumn<String>(
    'activity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadVersionMeta = const VerificationMeta(
    'payloadVersion',
  );
  @override
  late final GeneratedColumn<int> payloadVersion = GeneratedColumn<int>(
    'payload_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    profileId,
    activityId,
    payloadVersion,
    payload,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'activity_checkpoints';
  @override
  VerificationContext validateIntegrity(
    Insertable<ActivityCheckpoint> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('activity_id')) {
      context.handle(
        _activityIdMeta,
        activityId.isAcceptableOrUnknown(data['activity_id']!, _activityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_activityIdMeta);
    }
    if (data.containsKey('payload_version')) {
      context.handle(
        _payloadVersionMeta,
        payloadVersion.isAcceptableOrUnknown(
          data['payload_version']!,
          _payloadVersionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_payloadVersionMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {profileId, activityId};
  @override
  ActivityCheckpoint map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ActivityCheckpoint(
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}profile_id'],
      )!,
      activityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}activity_id'],
      )!,
      payloadVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}payload_version'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ActivityCheckpointsTable createAlias(String alias) {
    return $ActivityCheckpointsTable(attachedDatabase, alias);
  }
}

class ActivityCheckpoint extends DataClass
    implements Insertable<ActivityCheckpoint> {
  final int profileId;
  final String activityId;
  final int payloadVersion;
  final String payload;
  final int updatedAt;
  const ActivityCheckpoint({
    required this.profileId,
    required this.activityId,
    required this.payloadVersion,
    required this.payload,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['profile_id'] = Variable<int>(profileId);
    map['activity_id'] = Variable<String>(activityId);
    map['payload_version'] = Variable<int>(payloadVersion);
    map['payload'] = Variable<String>(payload);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  ActivityCheckpointsCompanion toCompanion(bool nullToAbsent) {
    return ActivityCheckpointsCompanion(
      profileId: Value(profileId),
      activityId: Value(activityId),
      payloadVersion: Value(payloadVersion),
      payload: Value(payload),
      updatedAt: Value(updatedAt),
    );
  }

  factory ActivityCheckpoint.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ActivityCheckpoint(
      profileId: serializer.fromJson<int>(json['profileId']),
      activityId: serializer.fromJson<String>(json['activityId']),
      payloadVersion: serializer.fromJson<int>(json['payloadVersion']),
      payload: serializer.fromJson<String>(json['payload']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'profileId': serializer.toJson<int>(profileId),
      'activityId': serializer.toJson<String>(activityId),
      'payloadVersion': serializer.toJson<int>(payloadVersion),
      'payload': serializer.toJson<String>(payload),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  ActivityCheckpoint copyWith({
    int? profileId,
    String? activityId,
    int? payloadVersion,
    String? payload,
    int? updatedAt,
  }) => ActivityCheckpoint(
    profileId: profileId ?? this.profileId,
    activityId: activityId ?? this.activityId,
    payloadVersion: payloadVersion ?? this.payloadVersion,
    payload: payload ?? this.payload,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ActivityCheckpoint copyWithCompanion(ActivityCheckpointsCompanion data) {
    return ActivityCheckpoint(
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      activityId: data.activityId.present
          ? data.activityId.value
          : this.activityId,
      payloadVersion: data.payloadVersion.present
          ? data.payloadVersion.value
          : this.payloadVersion,
      payload: data.payload.present ? data.payload.value : this.payload,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ActivityCheckpoint(')
          ..write('profileId: $profileId, ')
          ..write('activityId: $activityId, ')
          ..write('payloadVersion: $payloadVersion, ')
          ..write('payload: $payload, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(profileId, activityId, payloadVersion, payload, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ActivityCheckpoint &&
          other.profileId == this.profileId &&
          other.activityId == this.activityId &&
          other.payloadVersion == this.payloadVersion &&
          other.payload == this.payload &&
          other.updatedAt == this.updatedAt);
}

class ActivityCheckpointsCompanion extends UpdateCompanion<ActivityCheckpoint> {
  final Value<int> profileId;
  final Value<String> activityId;
  final Value<int> payloadVersion;
  final Value<String> payload;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const ActivityCheckpointsCompanion({
    this.profileId = const Value.absent(),
    this.activityId = const Value.absent(),
    this.payloadVersion = const Value.absent(),
    this.payload = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ActivityCheckpointsCompanion.insert({
    required int profileId,
    required String activityId,
    required int payloadVersion,
    required String payload,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : profileId = Value(profileId),
       activityId = Value(activityId),
       payloadVersion = Value(payloadVersion),
       payload = Value(payload),
       updatedAt = Value(updatedAt);
  static Insertable<ActivityCheckpoint> custom({
    Expression<int>? profileId,
    Expression<String>? activityId,
    Expression<int>? payloadVersion,
    Expression<String>? payload,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (profileId != null) 'profile_id': profileId,
      if (activityId != null) 'activity_id': activityId,
      if (payloadVersion != null) 'payload_version': payloadVersion,
      if (payload != null) 'payload': payload,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ActivityCheckpointsCompanion copyWith({
    Value<int>? profileId,
    Value<String>? activityId,
    Value<int>? payloadVersion,
    Value<String>? payload,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return ActivityCheckpointsCompanion(
      profileId: profileId ?? this.profileId,
      activityId: activityId ?? this.activityId,
      payloadVersion: payloadVersion ?? this.payloadVersion,
      payload: payload ?? this.payload,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (profileId.present) {
      map['profile_id'] = Variable<int>(profileId.value);
    }
    if (activityId.present) {
      map['activity_id'] = Variable<String>(activityId.value);
    }
    if (payloadVersion.present) {
      map['payload_version'] = Variable<int>(payloadVersion.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActivityCheckpointsCompanion(')
          ..write('profileId: $profileId, ')
          ..write('activityId: $activityId, ')
          ..write('payloadVersion: $payloadVersion, ')
          ..write('payload: $payload, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LevelBadgesTable extends LevelBadges
    with TableInfo<$LevelBadgesTable, LevelBadge> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LevelBadgesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<int> profileId = GeneratedColumn<int>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES child_profiles (id)',
    ),
  );
  static const VerificationMeta _activityIdMeta = const VerificationMeta(
    'activityId',
  );
  @override
  late final GeneratedColumn<String> activityId = GeneratedColumn<String>(
    'activity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _engineTypeMeta = const VerificationMeta(
    'engineType',
  );
  @override
  late final GeneratedColumn<String> engineType = GeneratedColumn<String>(
    'engine_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scoreMeta = const VerificationMeta('score');
  @override
  late final GeneratedColumn<int> score = GeneratedColumn<int>(
    'score',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _starsMeta = const VerificationMeta('stars');
  @override
  late final GeneratedColumn<int> stars = GeneratedColumn<int>(
    'stars',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _outcomeMeta = const VerificationMeta(
    'outcome',
  );
  @override
  late final GeneratedColumn<String> outcome = GeneratedColumn<String>(
    'outcome',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _earnedAtMeta = const VerificationMeta(
    'earnedAt',
  );
  @override
  late final GeneratedColumn<int> earnedAt = GeneratedColumn<int>(
    'earned_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    profileId,
    activityId,
    engineType,
    score,
    stars,
    outcome,
    earnedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'level_badges';
  @override
  VerificationContext validateIntegrity(
    Insertable<LevelBadge> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('activity_id')) {
      context.handle(
        _activityIdMeta,
        activityId.isAcceptableOrUnknown(data['activity_id']!, _activityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_activityIdMeta);
    }
    if (data.containsKey('engine_type')) {
      context.handle(
        _engineTypeMeta,
        engineType.isAcceptableOrUnknown(data['engine_type']!, _engineTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_engineTypeMeta);
    }
    if (data.containsKey('score')) {
      context.handle(
        _scoreMeta,
        score.isAcceptableOrUnknown(data['score']!, _scoreMeta),
      );
    } else if (isInserting) {
      context.missing(_scoreMeta);
    }
    if (data.containsKey('stars')) {
      context.handle(
        _starsMeta,
        stars.isAcceptableOrUnknown(data['stars']!, _starsMeta),
      );
    } else if (isInserting) {
      context.missing(_starsMeta);
    }
    if (data.containsKey('outcome')) {
      context.handle(
        _outcomeMeta,
        outcome.isAcceptableOrUnknown(data['outcome']!, _outcomeMeta),
      );
    } else if (isInserting) {
      context.missing(_outcomeMeta);
    }
    if (data.containsKey('earned_at')) {
      context.handle(
        _earnedAtMeta,
        earnedAt.isAcceptableOrUnknown(data['earned_at']!, _earnedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_earnedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {profileId, activityId};
  @override
  LevelBadge map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LevelBadge(
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}profile_id'],
      )!,
      activityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}activity_id'],
      )!,
      engineType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}engine_type'],
      )!,
      score: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}score'],
      )!,
      stars: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}stars'],
      )!,
      outcome: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}outcome'],
      )!,
      earnedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}earned_at'],
      )!,
    );
  }

  @override
  $LevelBadgesTable createAlias(String alias) {
    return $LevelBadgesTable(attachedDatabase, alias);
  }
}

class LevelBadge extends DataClass implements Insertable<LevelBadge> {
  final int profileId;
  final String activityId;
  final String engineType;
  final int score;
  final int stars;
  final String outcome;
  final int earnedAt;
  const LevelBadge({
    required this.profileId,
    required this.activityId,
    required this.engineType,
    required this.score,
    required this.stars,
    required this.outcome,
    required this.earnedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['profile_id'] = Variable<int>(profileId);
    map['activity_id'] = Variable<String>(activityId);
    map['engine_type'] = Variable<String>(engineType);
    map['score'] = Variable<int>(score);
    map['stars'] = Variable<int>(stars);
    map['outcome'] = Variable<String>(outcome);
    map['earned_at'] = Variable<int>(earnedAt);
    return map;
  }

  LevelBadgesCompanion toCompanion(bool nullToAbsent) {
    return LevelBadgesCompanion(
      profileId: Value(profileId),
      activityId: Value(activityId),
      engineType: Value(engineType),
      score: Value(score),
      stars: Value(stars),
      outcome: Value(outcome),
      earnedAt: Value(earnedAt),
    );
  }

  factory LevelBadge.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LevelBadge(
      profileId: serializer.fromJson<int>(json['profileId']),
      activityId: serializer.fromJson<String>(json['activityId']),
      engineType: serializer.fromJson<String>(json['engineType']),
      score: serializer.fromJson<int>(json['score']),
      stars: serializer.fromJson<int>(json['stars']),
      outcome: serializer.fromJson<String>(json['outcome']),
      earnedAt: serializer.fromJson<int>(json['earnedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'profileId': serializer.toJson<int>(profileId),
      'activityId': serializer.toJson<String>(activityId),
      'engineType': serializer.toJson<String>(engineType),
      'score': serializer.toJson<int>(score),
      'stars': serializer.toJson<int>(stars),
      'outcome': serializer.toJson<String>(outcome),
      'earnedAt': serializer.toJson<int>(earnedAt),
    };
  }

  LevelBadge copyWith({
    int? profileId,
    String? activityId,
    String? engineType,
    int? score,
    int? stars,
    String? outcome,
    int? earnedAt,
  }) => LevelBadge(
    profileId: profileId ?? this.profileId,
    activityId: activityId ?? this.activityId,
    engineType: engineType ?? this.engineType,
    score: score ?? this.score,
    stars: stars ?? this.stars,
    outcome: outcome ?? this.outcome,
    earnedAt: earnedAt ?? this.earnedAt,
  );
  LevelBadge copyWithCompanion(LevelBadgesCompanion data) {
    return LevelBadge(
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      activityId: data.activityId.present
          ? data.activityId.value
          : this.activityId,
      engineType: data.engineType.present
          ? data.engineType.value
          : this.engineType,
      score: data.score.present ? data.score.value : this.score,
      stars: data.stars.present ? data.stars.value : this.stars,
      outcome: data.outcome.present ? data.outcome.value : this.outcome,
      earnedAt: data.earnedAt.present ? data.earnedAt.value : this.earnedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LevelBadge(')
          ..write('profileId: $profileId, ')
          ..write('activityId: $activityId, ')
          ..write('engineType: $engineType, ')
          ..write('score: $score, ')
          ..write('stars: $stars, ')
          ..write('outcome: $outcome, ')
          ..write('earnedAt: $earnedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    profileId,
    activityId,
    engineType,
    score,
    stars,
    outcome,
    earnedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LevelBadge &&
          other.profileId == this.profileId &&
          other.activityId == this.activityId &&
          other.engineType == this.engineType &&
          other.score == this.score &&
          other.stars == this.stars &&
          other.outcome == this.outcome &&
          other.earnedAt == this.earnedAt);
}

class LevelBadgesCompanion extends UpdateCompanion<LevelBadge> {
  final Value<int> profileId;
  final Value<String> activityId;
  final Value<String> engineType;
  final Value<int> score;
  final Value<int> stars;
  final Value<String> outcome;
  final Value<int> earnedAt;
  final Value<int> rowid;
  const LevelBadgesCompanion({
    this.profileId = const Value.absent(),
    this.activityId = const Value.absent(),
    this.engineType = const Value.absent(),
    this.score = const Value.absent(),
    this.stars = const Value.absent(),
    this.outcome = const Value.absent(),
    this.earnedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LevelBadgesCompanion.insert({
    required int profileId,
    required String activityId,
    required String engineType,
    required int score,
    required int stars,
    required String outcome,
    required int earnedAt,
    this.rowid = const Value.absent(),
  }) : profileId = Value(profileId),
       activityId = Value(activityId),
       engineType = Value(engineType),
       score = Value(score),
       stars = Value(stars),
       outcome = Value(outcome),
       earnedAt = Value(earnedAt);
  static Insertable<LevelBadge> custom({
    Expression<int>? profileId,
    Expression<String>? activityId,
    Expression<String>? engineType,
    Expression<int>? score,
    Expression<int>? stars,
    Expression<String>? outcome,
    Expression<int>? earnedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (profileId != null) 'profile_id': profileId,
      if (activityId != null) 'activity_id': activityId,
      if (engineType != null) 'engine_type': engineType,
      if (score != null) 'score': score,
      if (stars != null) 'stars': stars,
      if (outcome != null) 'outcome': outcome,
      if (earnedAt != null) 'earned_at': earnedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LevelBadgesCompanion copyWith({
    Value<int>? profileId,
    Value<String>? activityId,
    Value<String>? engineType,
    Value<int>? score,
    Value<int>? stars,
    Value<String>? outcome,
    Value<int>? earnedAt,
    Value<int>? rowid,
  }) {
    return LevelBadgesCompanion(
      profileId: profileId ?? this.profileId,
      activityId: activityId ?? this.activityId,
      engineType: engineType ?? this.engineType,
      score: score ?? this.score,
      stars: stars ?? this.stars,
      outcome: outcome ?? this.outcome,
      earnedAt: earnedAt ?? this.earnedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (profileId.present) {
      map['profile_id'] = Variable<int>(profileId.value);
    }
    if (activityId.present) {
      map['activity_id'] = Variable<String>(activityId.value);
    }
    if (engineType.present) {
      map['engine_type'] = Variable<String>(engineType.value);
    }
    if (score.present) {
      map['score'] = Variable<int>(score.value);
    }
    if (stars.present) {
      map['stars'] = Variable<int>(stars.value);
    }
    if (outcome.present) {
      map['outcome'] = Variable<String>(outcome.value);
    }
    if (earnedAt.present) {
      map['earned_at'] = Variable<int>(earnedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LevelBadgesCompanion(')
          ..write('profileId: $profileId, ')
          ..write('activityId: $activityId, ')
          ..write('engineType: $engineType, ')
          ..write('score: $score, ')
          ..write('stars: $stars, ')
          ..write('outcome: $outcome, ')
          ..write('earnedAt: $earnedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ChildProfilesTable childProfiles = $ChildProfilesTable(this);
  late final $ActivityProgressTable activityProgress = $ActivityProgressTable(
    this,
  );
  late final $SkillProgressTable skillProgress = $SkillProgressTable(this);
  late final $DailyJourneysTable dailyJourneys = $DailyJourneysTable(this);
  late final $DailyJourneyItemsTable dailyJourneyItems =
      $DailyJourneyItemsTable(this);
  late final $RewardsTable rewards = $RewardsTable(this);
  late final $PracticeDaysTable practiceDays = $PracticeDaysTable(this);
  late final $EntitlementCacheEntriesTable entitlementCacheEntries =
      $EntitlementCacheEntriesTable(this);
  late final $LocalSettingsTable localSettings = $LocalSettingsTable(this);
  late final $RecentGeneratedLevelsTable recentGeneratedLevels =
      $RecentGeneratedLevelsTable(this);
  late final $ActivityCheckpointsTable activityCheckpoints =
      $ActivityCheckpointsTable(this);
  late final $LevelBadgesTable levelBadges = $LevelBadgesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    childProfiles,
    activityProgress,
    skillProgress,
    dailyJourneys,
    dailyJourneyItems,
    rewards,
    practiceDays,
    entitlementCacheEntries,
    localSettings,
    recentGeneratedLevels,
    activityCheckpoints,
    levelBadges,
  ];
}

typedef $$ChildProfilesTableCreateCompanionBuilder =
    ChildProfilesCompanion Function({
      Value<int> id,
      Value<String?> nickname,
      required String avatarId,
      required String ageBand,
      required int createdAt,
      Value<bool> active,
    });
typedef $$ChildProfilesTableUpdateCompanionBuilder =
    ChildProfilesCompanion Function({
      Value<int> id,
      Value<String?> nickname,
      Value<String> avatarId,
      Value<String> ageBand,
      Value<int> createdAt,
      Value<bool> active,
    });

final class $$ChildProfilesTableReferences
    extends BaseReferences<_$AppDatabase, $ChildProfilesTable, ChildProfile> {
  $$ChildProfilesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$ActivityProgressTable, List<ActivityProgressData>>
  _activityProgressRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.activityProgress,
    aliasName: 'child_profiles__id__activity_progress__profile_id',
  );

  $$ActivityProgressTableProcessedTableManager get activityProgressRefs {
    final manager = $$ActivityProgressTableTableManager(
      $_db,
      $_db.activityProgress,
    ).filter((f) => f.profileId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _activityProgressRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SkillProgressTable, List<SkillProgressData>>
  _skillProgressRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.skillProgress,
    aliasName: 'child_profiles__id__skill_progress__profile_id',
  );

  $$SkillProgressTableProcessedTableManager get skillProgressRefs {
    final manager = $$SkillProgressTableTableManager(
      $_db,
      $_db.skillProgress,
    ).filter((f) => f.profileId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_skillProgressRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$DailyJourneysTable, List<DailyJourney>>
  _dailyJourneysRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.dailyJourneys,
    aliasName: 'child_profiles__id__daily_journeys__profile_id',
  );

  $$DailyJourneysTableProcessedTableManager get dailyJourneysRefs {
    final manager = $$DailyJourneysTableTableManager(
      $_db,
      $_db.dailyJourneys,
    ).filter((f) => f.profileId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_dailyJourneysRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RewardsTable, List<Reward>> _rewardsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.rewards,
    aliasName: 'child_profiles__id__rewards__profile_id',
  );

  $$RewardsTableProcessedTableManager get rewardsRefs {
    final manager = $$RewardsTableTableManager(
      $_db,
      $_db.rewards,
    ).filter((f) => f.profileId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_rewardsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PracticeDaysTable, List<PracticeDay>>
  _practiceDaysRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.practiceDays,
    aliasName: 'child_profiles__id__practice_days__profile_id',
  );

  $$PracticeDaysTableProcessedTableManager get practiceDaysRefs {
    final manager = $$PracticeDaysTableTableManager(
      $_db,
      $_db.practiceDays,
    ).filter((f) => f.profileId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_practiceDaysRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $RecentGeneratedLevelsTable,
    List<RecentGeneratedLevel>
  >
  _recentGeneratedLevelsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.recentGeneratedLevels,
        aliasName: 'child_profiles__id__recent_generated_levels__profile_id',
      );

  $$RecentGeneratedLevelsTableProcessedTableManager
  get recentGeneratedLevelsRefs {
    final manager = $$RecentGeneratedLevelsTableTableManager(
      $_db,
      $_db.recentGeneratedLevels,
    ).filter((f) => f.profileId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _recentGeneratedLevelsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $ActivityCheckpointsTable,
    List<ActivityCheckpoint>
  >
  _activityCheckpointsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.activityCheckpoints,
        aliasName: 'child_profiles__id__activity_checkpoints__profile_id',
      );

  $$ActivityCheckpointsTableProcessedTableManager get activityCheckpointsRefs {
    final manager = $$ActivityCheckpointsTableTableManager(
      $_db,
      $_db.activityCheckpoints,
    ).filter((f) => f.profileId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _activityCheckpointsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$LevelBadgesTable, List<LevelBadge>>
  _levelBadgesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.levelBadges,
    aliasName: 'child_profiles__id__level_badges__profile_id',
  );

  $$LevelBadgesTableProcessedTableManager get levelBadgesRefs {
    final manager = $$LevelBadgesTableTableManager(
      $_db,
      $_db.levelBadges,
    ).filter((f) => f.profileId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_levelBadgesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ChildProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $ChildProfilesTable> {
  $$ChildProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nickname => $composableBuilder(
    column: $table.nickname,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get avatarId => $composableBuilder(
    column: $table.avatarId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ageBand => $composableBuilder(
    column: $table.ageBand,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> activityProgressRefs(
    Expression<bool> Function($$ActivityProgressTableFilterComposer f) f,
  ) {
    final $$ActivityProgressTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.activityProgress,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActivityProgressTableFilterComposer(
            $db: $db,
            $table: $db.activityProgress,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> skillProgressRefs(
    Expression<bool> Function($$SkillProgressTableFilterComposer f) f,
  ) {
    final $$SkillProgressTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.skillProgress,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SkillProgressTableFilterComposer(
            $db: $db,
            $table: $db.skillProgress,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> dailyJourneysRefs(
    Expression<bool> Function($$DailyJourneysTableFilterComposer f) f,
  ) {
    final $$DailyJourneysTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.dailyJourneys,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DailyJourneysTableFilterComposer(
            $db: $db,
            $table: $db.dailyJourneys,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> rewardsRefs(
    Expression<bool> Function($$RewardsTableFilterComposer f) f,
  ) {
    final $$RewardsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.rewards,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RewardsTableFilterComposer(
            $db: $db,
            $table: $db.rewards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> practiceDaysRefs(
    Expression<bool> Function($$PracticeDaysTableFilterComposer f) f,
  ) {
    final $$PracticeDaysTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.practiceDays,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PracticeDaysTableFilterComposer(
            $db: $db,
            $table: $db.practiceDays,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> recentGeneratedLevelsRefs(
    Expression<bool> Function($$RecentGeneratedLevelsTableFilterComposer f) f,
  ) {
    final $$RecentGeneratedLevelsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.recentGeneratedLevels,
          getReferencedColumn: (t) => t.profileId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RecentGeneratedLevelsTableFilterComposer(
                $db: $db,
                $table: $db.recentGeneratedLevels,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> activityCheckpointsRefs(
    Expression<bool> Function($$ActivityCheckpointsTableFilterComposer f) f,
  ) {
    final $$ActivityCheckpointsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.activityCheckpoints,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActivityCheckpointsTableFilterComposer(
            $db: $db,
            $table: $db.activityCheckpoints,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> levelBadgesRefs(
    Expression<bool> Function($$LevelBadgesTableFilterComposer f) f,
  ) {
    final $$LevelBadgesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.levelBadges,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LevelBadgesTableFilterComposer(
            $db: $db,
            $table: $db.levelBadges,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ChildProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $ChildProfilesTable> {
  $$ChildProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nickname => $composableBuilder(
    column: $table.nickname,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get avatarId => $composableBuilder(
    column: $table.avatarId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ageBand => $composableBuilder(
    column: $table.ageBand,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ChildProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChildProfilesTable> {
  $$ChildProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nickname =>
      $composableBuilder(column: $table.nickname, builder: (column) => column);

  GeneratedColumn<String> get avatarId =>
      $composableBuilder(column: $table.avatarId, builder: (column) => column);

  GeneratedColumn<String> get ageBand =>
      $composableBuilder(column: $table.ageBand, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);

  Expression<T> activityProgressRefs<T extends Object>(
    Expression<T> Function($$ActivityProgressTableAnnotationComposer a) f,
  ) {
    final $$ActivityProgressTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.activityProgress,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActivityProgressTableAnnotationComposer(
            $db: $db,
            $table: $db.activityProgress,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> skillProgressRefs<T extends Object>(
    Expression<T> Function($$SkillProgressTableAnnotationComposer a) f,
  ) {
    final $$SkillProgressTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.skillProgress,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SkillProgressTableAnnotationComposer(
            $db: $db,
            $table: $db.skillProgress,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> dailyJourneysRefs<T extends Object>(
    Expression<T> Function($$DailyJourneysTableAnnotationComposer a) f,
  ) {
    final $$DailyJourneysTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.dailyJourneys,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DailyJourneysTableAnnotationComposer(
            $db: $db,
            $table: $db.dailyJourneys,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> rewardsRefs<T extends Object>(
    Expression<T> Function($$RewardsTableAnnotationComposer a) f,
  ) {
    final $$RewardsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.rewards,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RewardsTableAnnotationComposer(
            $db: $db,
            $table: $db.rewards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> practiceDaysRefs<T extends Object>(
    Expression<T> Function($$PracticeDaysTableAnnotationComposer a) f,
  ) {
    final $$PracticeDaysTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.practiceDays,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PracticeDaysTableAnnotationComposer(
            $db: $db,
            $table: $db.practiceDays,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> recentGeneratedLevelsRefs<T extends Object>(
    Expression<T> Function($$RecentGeneratedLevelsTableAnnotationComposer a) f,
  ) {
    final $$RecentGeneratedLevelsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.recentGeneratedLevels,
          getReferencedColumn: (t) => t.profileId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RecentGeneratedLevelsTableAnnotationComposer(
                $db: $db,
                $table: $db.recentGeneratedLevels,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> activityCheckpointsRefs<T extends Object>(
    Expression<T> Function($$ActivityCheckpointsTableAnnotationComposer a) f,
  ) {
    final $$ActivityCheckpointsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.activityCheckpoints,
          getReferencedColumn: (t) => t.profileId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ActivityCheckpointsTableAnnotationComposer(
                $db: $db,
                $table: $db.activityCheckpoints,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> levelBadgesRefs<T extends Object>(
    Expression<T> Function($$LevelBadgesTableAnnotationComposer a) f,
  ) {
    final $$LevelBadgesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.levelBadges,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LevelBadgesTableAnnotationComposer(
            $db: $db,
            $table: $db.levelBadges,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ChildProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ChildProfilesTable,
          ChildProfile,
          $$ChildProfilesTableFilterComposer,
          $$ChildProfilesTableOrderingComposer,
          $$ChildProfilesTableAnnotationComposer,
          $$ChildProfilesTableCreateCompanionBuilder,
          $$ChildProfilesTableUpdateCompanionBuilder,
          (ChildProfile, $$ChildProfilesTableReferences),
          ChildProfile,
          PrefetchHooks Function({
            bool activityProgressRefs,
            bool skillProgressRefs,
            bool dailyJourneysRefs,
            bool rewardsRefs,
            bool practiceDaysRefs,
            bool recentGeneratedLevelsRefs,
            bool activityCheckpointsRefs,
            bool levelBadgesRefs,
          })
        > {
  $$ChildProfilesTableTableManager(_$AppDatabase db, $ChildProfilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChildProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChildProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChildProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> nickname = const Value.absent(),
                Value<String> avatarId = const Value.absent(),
                Value<String> ageBand = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<bool> active = const Value.absent(),
              }) => ChildProfilesCompanion(
                id: id,
                nickname: nickname,
                avatarId: avatarId,
                ageBand: ageBand,
                createdAt: createdAt,
                active: active,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> nickname = const Value.absent(),
                required String avatarId,
                required String ageBand,
                required int createdAt,
                Value<bool> active = const Value.absent(),
              }) => ChildProfilesCompanion.insert(
                id: id,
                nickname: nickname,
                avatarId: avatarId,
                ageBand: ageBand,
                createdAt: createdAt,
                active: active,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ChildProfilesTable, ChildProfile>(table),
                  $$ChildProfilesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                activityProgressRefs = false,
                skillProgressRefs = false,
                dailyJourneysRefs = false,
                rewardsRefs = false,
                practiceDaysRefs = false,
                recentGeneratedLevelsRefs = false,
                activityCheckpointsRefs = false,
                levelBadgesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (activityProgressRefs) db.activityProgress,
                    if (skillProgressRefs) db.skillProgress,
                    if (dailyJourneysRefs) db.dailyJourneys,
                    if (rewardsRefs) db.rewards,
                    if (practiceDaysRefs) db.practiceDays,
                    if (recentGeneratedLevelsRefs) db.recentGeneratedLevels,
                    if (activityCheckpointsRefs) db.activityCheckpoints,
                    if (levelBadgesRefs) db.levelBadges,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (activityProgressRefs)
                        await $_getPrefetchedData<
                          ChildProfile,
                          $ChildProfilesTable,
                          ActivityProgressData
                        >(
                          currentTable: table,
                          referencedTable: $$ChildProfilesTableReferences
                              ._activityProgressRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ChildProfilesTableReferences(
                                db,
                                table,
                                p0,
                              ).activityProgressRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.profileId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (skillProgressRefs)
                        await $_getPrefetchedData<
                          ChildProfile,
                          $ChildProfilesTable,
                          SkillProgressData
                        >(
                          currentTable: table,
                          referencedTable: $$ChildProfilesTableReferences
                              ._skillProgressRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ChildProfilesTableReferences(
                                db,
                                table,
                                p0,
                              ).skillProgressRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.profileId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (dailyJourneysRefs)
                        await $_getPrefetchedData<
                          ChildProfile,
                          $ChildProfilesTable,
                          DailyJourney
                        >(
                          currentTable: table,
                          referencedTable: $$ChildProfilesTableReferences
                              ._dailyJourneysRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ChildProfilesTableReferences(
                                db,
                                table,
                                p0,
                              ).dailyJourneysRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.profileId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (rewardsRefs)
                        await $_getPrefetchedData<
                          ChildProfile,
                          $ChildProfilesTable,
                          Reward
                        >(
                          currentTable: table,
                          referencedTable: $$ChildProfilesTableReferences
                              ._rewardsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ChildProfilesTableReferences(
                                db,
                                table,
                                p0,
                              ).rewardsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.profileId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (practiceDaysRefs)
                        await $_getPrefetchedData<
                          ChildProfile,
                          $ChildProfilesTable,
                          PracticeDay
                        >(
                          currentTable: table,
                          referencedTable: $$ChildProfilesTableReferences
                              ._practiceDaysRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ChildProfilesTableReferences(
                                db,
                                table,
                                p0,
                              ).practiceDaysRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.profileId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (recentGeneratedLevelsRefs)
                        await $_getPrefetchedData<
                          ChildProfile,
                          $ChildProfilesTable,
                          RecentGeneratedLevel
                        >(
                          currentTable: table,
                          referencedTable: $$ChildProfilesTableReferences
                              ._recentGeneratedLevelsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ChildProfilesTableReferences(
                                db,
                                table,
                                p0,
                              ).recentGeneratedLevelsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.profileId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (activityCheckpointsRefs)
                        await $_getPrefetchedData<
                          ChildProfile,
                          $ChildProfilesTable,
                          ActivityCheckpoint
                        >(
                          currentTable: table,
                          referencedTable: $$ChildProfilesTableReferences
                              ._activityCheckpointsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ChildProfilesTableReferences(
                                db,
                                table,
                                p0,
                              ).activityCheckpointsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.profileId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (levelBadgesRefs)
                        await $_getPrefetchedData<
                          ChildProfile,
                          $ChildProfilesTable,
                          LevelBadge
                        >(
                          currentTable: table,
                          referencedTable: $$ChildProfilesTableReferences
                              ._levelBadgesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ChildProfilesTableReferences(
                                db,
                                table,
                                p0,
                              ).levelBadgesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.profileId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ChildProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ChildProfilesTable,
      ChildProfile,
      $$ChildProfilesTableFilterComposer,
      $$ChildProfilesTableOrderingComposer,
      $$ChildProfilesTableAnnotationComposer,
      $$ChildProfilesTableCreateCompanionBuilder,
      $$ChildProfilesTableUpdateCompanionBuilder,
      (ChildProfile, $$ChildProfilesTableReferences),
      ChildProfile,
      PrefetchHooks Function({
        bool activityProgressRefs,
        bool skillProgressRefs,
        bool dailyJourneysRefs,
        bool rewardsRefs,
        bool practiceDaysRefs,
        bool recentGeneratedLevelsRefs,
        bool activityCheckpointsRefs,
        bool levelBadgesRefs,
      })
    >;
typedef $$ActivityProgressTableCreateCompanionBuilder =
    ActivityProgressCompanion Function({
      required int profileId,
      required String activityId,
      required String engineType,
      Value<int> attempts,
      Value<int> completions,
      Value<int> bestStars,
      Value<int> hintsUsed,
      required int lastPlayedAt,
      Value<double> masteryContribution,
      Value<bool> countedAsFree,
      Value<String?> generatorType,
      Value<String?> generatorVersion,
      Value<int?> seed,
      Value<String?> skillId,
      Value<String?> resultSummary,
      Value<int> bestScore,
      Value<int> rowid,
    });
typedef $$ActivityProgressTableUpdateCompanionBuilder =
    ActivityProgressCompanion Function({
      Value<int> profileId,
      Value<String> activityId,
      Value<String> engineType,
      Value<int> attempts,
      Value<int> completions,
      Value<int> bestStars,
      Value<int> hintsUsed,
      Value<int> lastPlayedAt,
      Value<double> masteryContribution,
      Value<bool> countedAsFree,
      Value<String?> generatorType,
      Value<String?> generatorVersion,
      Value<int?> seed,
      Value<String?> skillId,
      Value<String?> resultSummary,
      Value<int> bestScore,
      Value<int> rowid,
    });

final class $$ActivityProgressTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ActivityProgressTable,
          ActivityProgressData
        > {
  $$ActivityProgressTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ChildProfilesTable _profileIdTable(_$AppDatabase db) => db
      .childProfiles
      .createAlias('activity_progress__profile_id__child_profiles__id');

  $$ChildProfilesTableProcessedTableManager get profileId {
    final $_column = $_itemColumn<int>('profile_id')!;

    final manager = $$ChildProfilesTableTableManager(
      $_db,
      $_db.childProfiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_profileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ActivityProgressTableFilterComposer
    extends Composer<_$AppDatabase, $ActivityProgressTable> {
  $$ActivityProgressTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get activityId => $composableBuilder(
    column: $table.activityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get engineType => $composableBuilder(
    column: $table.engineType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get completions => $composableBuilder(
    column: $table.completions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get bestStars => $composableBuilder(
    column: $table.bestStars,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hintsUsed => $composableBuilder(
    column: $table.hintsUsed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastPlayedAt => $composableBuilder(
    column: $table.lastPlayedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get masteryContribution => $composableBuilder(
    column: $table.masteryContribution,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get countedAsFree => $composableBuilder(
    column: $table.countedAsFree,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get generatorType => $composableBuilder(
    column: $table.generatorType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get generatorVersion => $composableBuilder(
    column: $table.generatorVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get seed => $composableBuilder(
    column: $table.seed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get skillId => $composableBuilder(
    column: $table.skillId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get resultSummary => $composableBuilder(
    column: $table.resultSummary,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get bestScore => $composableBuilder(
    column: $table.bestScore,
    builder: (column) => ColumnFilters(column),
  );

  $$ChildProfilesTableFilterComposer get profileId {
    final $$ChildProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.childProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChildProfilesTableFilterComposer(
            $db: $db,
            $table: $db.childProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ActivityProgressTableOrderingComposer
    extends Composer<_$AppDatabase, $ActivityProgressTable> {
  $$ActivityProgressTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get activityId => $composableBuilder(
    column: $table.activityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get engineType => $composableBuilder(
    column: $table.engineType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get completions => $composableBuilder(
    column: $table.completions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bestStars => $composableBuilder(
    column: $table.bestStars,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hintsUsed => $composableBuilder(
    column: $table.hintsUsed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastPlayedAt => $composableBuilder(
    column: $table.lastPlayedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get masteryContribution => $composableBuilder(
    column: $table.masteryContribution,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get countedAsFree => $composableBuilder(
    column: $table.countedAsFree,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get generatorType => $composableBuilder(
    column: $table.generatorType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get generatorVersion => $composableBuilder(
    column: $table.generatorVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get seed => $composableBuilder(
    column: $table.seed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get skillId => $composableBuilder(
    column: $table.skillId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get resultSummary => $composableBuilder(
    column: $table.resultSummary,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bestScore => $composableBuilder(
    column: $table.bestScore,
    builder: (column) => ColumnOrderings(column),
  );

  $$ChildProfilesTableOrderingComposer get profileId {
    final $$ChildProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.childProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChildProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.childProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ActivityProgressTableAnnotationComposer
    extends Composer<_$AppDatabase, $ActivityProgressTable> {
  $$ActivityProgressTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get activityId => $composableBuilder(
    column: $table.activityId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get engineType => $composableBuilder(
    column: $table.engineType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get attempts =>
      $composableBuilder(column: $table.attempts, builder: (column) => column);

  GeneratedColumn<int> get completions => $composableBuilder(
    column: $table.completions,
    builder: (column) => column,
  );

  GeneratedColumn<int> get bestStars =>
      $composableBuilder(column: $table.bestStars, builder: (column) => column);

  GeneratedColumn<int> get hintsUsed =>
      $composableBuilder(column: $table.hintsUsed, builder: (column) => column);

  GeneratedColumn<int> get lastPlayedAt => $composableBuilder(
    column: $table.lastPlayedAt,
    builder: (column) => column,
  );

  GeneratedColumn<double> get masteryContribution => $composableBuilder(
    column: $table.masteryContribution,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get countedAsFree => $composableBuilder(
    column: $table.countedAsFree,
    builder: (column) => column,
  );

  GeneratedColumn<String> get generatorType => $composableBuilder(
    column: $table.generatorType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get generatorVersion => $composableBuilder(
    column: $table.generatorVersion,
    builder: (column) => column,
  );

  GeneratedColumn<int> get seed =>
      $composableBuilder(column: $table.seed, builder: (column) => column);

  GeneratedColumn<String> get skillId =>
      $composableBuilder(column: $table.skillId, builder: (column) => column);

  GeneratedColumn<String> get resultSummary => $composableBuilder(
    column: $table.resultSummary,
    builder: (column) => column,
  );

  GeneratedColumn<int> get bestScore =>
      $composableBuilder(column: $table.bestScore, builder: (column) => column);

  $$ChildProfilesTableAnnotationComposer get profileId {
    final $$ChildProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.childProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChildProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.childProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ActivityProgressTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ActivityProgressTable,
          ActivityProgressData,
          $$ActivityProgressTableFilterComposer,
          $$ActivityProgressTableOrderingComposer,
          $$ActivityProgressTableAnnotationComposer,
          $$ActivityProgressTableCreateCompanionBuilder,
          $$ActivityProgressTableUpdateCompanionBuilder,
          (ActivityProgressData, $$ActivityProgressTableReferences),
          ActivityProgressData,
          PrefetchHooks Function({bool profileId})
        > {
  $$ActivityProgressTableTableManager(
    _$AppDatabase db,
    $ActivityProgressTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ActivityProgressTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ActivityProgressTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ActivityProgressTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> profileId = const Value.absent(),
                Value<String> activityId = const Value.absent(),
                Value<String> engineType = const Value.absent(),
                Value<int> attempts = const Value.absent(),
                Value<int> completions = const Value.absent(),
                Value<int> bestStars = const Value.absent(),
                Value<int> hintsUsed = const Value.absent(),
                Value<int> lastPlayedAt = const Value.absent(),
                Value<double> masteryContribution = const Value.absent(),
                Value<bool> countedAsFree = const Value.absent(),
                Value<String?> generatorType = const Value.absent(),
                Value<String?> generatorVersion = const Value.absent(),
                Value<int?> seed = const Value.absent(),
                Value<String?> skillId = const Value.absent(),
                Value<String?> resultSummary = const Value.absent(),
                Value<int> bestScore = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ActivityProgressCompanion(
                profileId: profileId,
                activityId: activityId,
                engineType: engineType,
                attempts: attempts,
                completions: completions,
                bestStars: bestStars,
                hintsUsed: hintsUsed,
                lastPlayedAt: lastPlayedAt,
                masteryContribution: masteryContribution,
                countedAsFree: countedAsFree,
                generatorType: generatorType,
                generatorVersion: generatorVersion,
                seed: seed,
                skillId: skillId,
                resultSummary: resultSummary,
                bestScore: bestScore,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int profileId,
                required String activityId,
                required String engineType,
                Value<int> attempts = const Value.absent(),
                Value<int> completions = const Value.absent(),
                Value<int> bestStars = const Value.absent(),
                Value<int> hintsUsed = const Value.absent(),
                required int lastPlayedAt,
                Value<double> masteryContribution = const Value.absent(),
                Value<bool> countedAsFree = const Value.absent(),
                Value<String?> generatorType = const Value.absent(),
                Value<String?> generatorVersion = const Value.absent(),
                Value<int?> seed = const Value.absent(),
                Value<String?> skillId = const Value.absent(),
                Value<String?> resultSummary = const Value.absent(),
                Value<int> bestScore = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ActivityProgressCompanion.insert(
                profileId: profileId,
                activityId: activityId,
                engineType: engineType,
                attempts: attempts,
                completions: completions,
                bestStars: bestStars,
                hintsUsed: hintsUsed,
                lastPlayedAt: lastPlayedAt,
                masteryContribution: masteryContribution,
                countedAsFree: countedAsFree,
                generatorType: generatorType,
                generatorVersion: generatorVersion,
                seed: seed,
                skillId: skillId,
                resultSummary: resultSummary,
                bestScore: bestScore,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ActivityProgressTable, ActivityProgressData>(
                    table,
                  ),
                  $$ActivityProgressTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({profileId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (profileId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.profileId,
                        referencedTable: $$ActivityProgressTableReferences
                            ._profileIdTable(db),
                        referencedColumn: $$ActivityProgressTableReferences
                            ._profileIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ActivityProgressTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ActivityProgressTable,
      ActivityProgressData,
      $$ActivityProgressTableFilterComposer,
      $$ActivityProgressTableOrderingComposer,
      $$ActivityProgressTableAnnotationComposer,
      $$ActivityProgressTableCreateCompanionBuilder,
      $$ActivityProgressTableUpdateCompanionBuilder,
      (ActivityProgressData, $$ActivityProgressTableReferences),
      ActivityProgressData,
      PrefetchHooks Function({bool profileId})
    >;
typedef $$SkillProgressTableCreateCompanionBuilder =
    SkillProgressCompanion Function({
      required int profileId,
      required String skillId,
      Value<double> mastery,
      Value<int> attemptCount,
      required int lastUpdatedAt,
      Value<int> currentDifficulty,
      Value<int> correctFirstTry,
      Value<int> correctAfterHint,
      Value<int> incorrectCount,
      Value<String> recentOutcomes,
      Value<String> recentActivityIds,
      Value<int> rowid,
    });
typedef $$SkillProgressTableUpdateCompanionBuilder =
    SkillProgressCompanion Function({
      Value<int> profileId,
      Value<String> skillId,
      Value<double> mastery,
      Value<int> attemptCount,
      Value<int> lastUpdatedAt,
      Value<int> currentDifficulty,
      Value<int> correctFirstTry,
      Value<int> correctAfterHint,
      Value<int> incorrectCount,
      Value<String> recentOutcomes,
      Value<String> recentActivityIds,
      Value<int> rowid,
    });

final class $$SkillProgressTableReferences
    extends
        BaseReferences<_$AppDatabase, $SkillProgressTable, SkillProgressData> {
  $$SkillProgressTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ChildProfilesTable _profileIdTable(_$AppDatabase db) => db
      .childProfiles
      .createAlias('skill_progress__profile_id__child_profiles__id');

  $$ChildProfilesTableProcessedTableManager get profileId {
    final $_column = $_itemColumn<int>('profile_id')!;

    final manager = $$ChildProfilesTableTableManager(
      $_db,
      $_db.childProfiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_profileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SkillProgressTableFilterComposer
    extends Composer<_$AppDatabase, $SkillProgressTable> {
  $$SkillProgressTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get skillId => $composableBuilder(
    column: $table.skillId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get mastery => $composableBuilder(
    column: $table.mastery,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attemptCount => $composableBuilder(
    column: $table.attemptCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastUpdatedAt => $composableBuilder(
    column: $table.lastUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentDifficulty => $composableBuilder(
    column: $table.currentDifficulty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get correctFirstTry => $composableBuilder(
    column: $table.correctFirstTry,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get correctAfterHint => $composableBuilder(
    column: $table.correctAfterHint,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get incorrectCount => $composableBuilder(
    column: $table.incorrectCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recentOutcomes => $composableBuilder(
    column: $table.recentOutcomes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recentActivityIds => $composableBuilder(
    column: $table.recentActivityIds,
    builder: (column) => ColumnFilters(column),
  );

  $$ChildProfilesTableFilterComposer get profileId {
    final $$ChildProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.childProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChildProfilesTableFilterComposer(
            $db: $db,
            $table: $db.childProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SkillProgressTableOrderingComposer
    extends Composer<_$AppDatabase, $SkillProgressTable> {
  $$SkillProgressTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get skillId => $composableBuilder(
    column: $table.skillId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get mastery => $composableBuilder(
    column: $table.mastery,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attemptCount => $composableBuilder(
    column: $table.attemptCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastUpdatedAt => $composableBuilder(
    column: $table.lastUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentDifficulty => $composableBuilder(
    column: $table.currentDifficulty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get correctFirstTry => $composableBuilder(
    column: $table.correctFirstTry,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get correctAfterHint => $composableBuilder(
    column: $table.correctAfterHint,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get incorrectCount => $composableBuilder(
    column: $table.incorrectCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recentOutcomes => $composableBuilder(
    column: $table.recentOutcomes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recentActivityIds => $composableBuilder(
    column: $table.recentActivityIds,
    builder: (column) => ColumnOrderings(column),
  );

  $$ChildProfilesTableOrderingComposer get profileId {
    final $$ChildProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.childProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChildProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.childProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SkillProgressTableAnnotationComposer
    extends Composer<_$AppDatabase, $SkillProgressTable> {
  $$SkillProgressTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get skillId =>
      $composableBuilder(column: $table.skillId, builder: (column) => column);

  GeneratedColumn<double> get mastery =>
      $composableBuilder(column: $table.mastery, builder: (column) => column);

  GeneratedColumn<int> get attemptCount => $composableBuilder(
    column: $table.attemptCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lastUpdatedAt => $composableBuilder(
    column: $table.lastUpdatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get currentDifficulty => $composableBuilder(
    column: $table.currentDifficulty,
    builder: (column) => column,
  );

  GeneratedColumn<int> get correctFirstTry => $composableBuilder(
    column: $table.correctFirstTry,
    builder: (column) => column,
  );

  GeneratedColumn<int> get correctAfterHint => $composableBuilder(
    column: $table.correctAfterHint,
    builder: (column) => column,
  );

  GeneratedColumn<int> get incorrectCount => $composableBuilder(
    column: $table.incorrectCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get recentOutcomes => $composableBuilder(
    column: $table.recentOutcomes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get recentActivityIds => $composableBuilder(
    column: $table.recentActivityIds,
    builder: (column) => column,
  );

  $$ChildProfilesTableAnnotationComposer get profileId {
    final $$ChildProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.childProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChildProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.childProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SkillProgressTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SkillProgressTable,
          SkillProgressData,
          $$SkillProgressTableFilterComposer,
          $$SkillProgressTableOrderingComposer,
          $$SkillProgressTableAnnotationComposer,
          $$SkillProgressTableCreateCompanionBuilder,
          $$SkillProgressTableUpdateCompanionBuilder,
          (SkillProgressData, $$SkillProgressTableReferences),
          SkillProgressData,
          PrefetchHooks Function({bool profileId})
        > {
  $$SkillProgressTableTableManager(_$AppDatabase db, $SkillProgressTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SkillProgressTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SkillProgressTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SkillProgressTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> profileId = const Value.absent(),
                Value<String> skillId = const Value.absent(),
                Value<double> mastery = const Value.absent(),
                Value<int> attemptCount = const Value.absent(),
                Value<int> lastUpdatedAt = const Value.absent(),
                Value<int> currentDifficulty = const Value.absent(),
                Value<int> correctFirstTry = const Value.absent(),
                Value<int> correctAfterHint = const Value.absent(),
                Value<int> incorrectCount = const Value.absent(),
                Value<String> recentOutcomes = const Value.absent(),
                Value<String> recentActivityIds = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SkillProgressCompanion(
                profileId: profileId,
                skillId: skillId,
                mastery: mastery,
                attemptCount: attemptCount,
                lastUpdatedAt: lastUpdatedAt,
                currentDifficulty: currentDifficulty,
                correctFirstTry: correctFirstTry,
                correctAfterHint: correctAfterHint,
                incorrectCount: incorrectCount,
                recentOutcomes: recentOutcomes,
                recentActivityIds: recentActivityIds,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int profileId,
                required String skillId,
                Value<double> mastery = const Value.absent(),
                Value<int> attemptCount = const Value.absent(),
                required int lastUpdatedAt,
                Value<int> currentDifficulty = const Value.absent(),
                Value<int> correctFirstTry = const Value.absent(),
                Value<int> correctAfterHint = const Value.absent(),
                Value<int> incorrectCount = const Value.absent(),
                Value<String> recentOutcomes = const Value.absent(),
                Value<String> recentActivityIds = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SkillProgressCompanion.insert(
                profileId: profileId,
                skillId: skillId,
                mastery: mastery,
                attemptCount: attemptCount,
                lastUpdatedAt: lastUpdatedAt,
                currentDifficulty: currentDifficulty,
                correctFirstTry: correctFirstTry,
                correctAfterHint: correctAfterHint,
                incorrectCount: incorrectCount,
                recentOutcomes: recentOutcomes,
                recentActivityIds: recentActivityIds,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SkillProgressTable, SkillProgressData>(table),
                  $$SkillProgressTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({profileId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (profileId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.profileId,
                        referencedTable: $$SkillProgressTableReferences
                            ._profileIdTable(db),
                        referencedColumn: $$SkillProgressTableReferences
                            ._profileIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SkillProgressTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SkillProgressTable,
      SkillProgressData,
      $$SkillProgressTableFilterComposer,
      $$SkillProgressTableOrderingComposer,
      $$SkillProgressTableAnnotationComposer,
      $$SkillProgressTableCreateCompanionBuilder,
      $$SkillProgressTableUpdateCompanionBuilder,
      (SkillProgressData, $$SkillProgressTableReferences),
      SkillProgressData,
      PrefetchHooks Function({bool profileId})
    >;
typedef $$DailyJourneysTableCreateCompanionBuilder =
    DailyJourneysCompanion Function({
      Value<int> id,
      required int profileId,
      required String localDateKey,
      Value<int> currentIndex,
      Value<int> completedCount,
      Value<int> starsEarned,
    });
typedef $$DailyJourneysTableUpdateCompanionBuilder =
    DailyJourneysCompanion Function({
      Value<int> id,
      Value<int> profileId,
      Value<String> localDateKey,
      Value<int> currentIndex,
      Value<int> completedCount,
      Value<int> starsEarned,
    });

final class $$DailyJourneysTableReferences
    extends BaseReferences<_$AppDatabase, $DailyJourneysTable, DailyJourney> {
  $$DailyJourneysTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ChildProfilesTable _profileIdTable(_$AppDatabase db) => db
      .childProfiles
      .createAlias('daily_journeys__profile_id__child_profiles__id');

  $$ChildProfilesTableProcessedTableManager get profileId {
    final $_column = $_itemColumn<int>('profile_id')!;

    final manager = $$ChildProfilesTableTableManager(
      $_db,
      $_db.childProfiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_profileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$DailyJourneyItemsTable, List<DailyJourneyItem>>
  _dailyJourneyItemsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.dailyJourneyItems,
        aliasName: 'daily_journeys__id__daily_journey_items__journey_id',
      );

  $$DailyJourneyItemsTableProcessedTableManager get dailyJourneyItemsRefs {
    final manager = $$DailyJourneyItemsTableTableManager(
      $_db,
      $_db.dailyJourneyItems,
    ).filter((f) => f.journeyId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _dailyJourneyItemsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$DailyJourneysTableFilterComposer
    extends Composer<_$AppDatabase, $DailyJourneysTable> {
  $$DailyJourneysTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localDateKey => $composableBuilder(
    column: $table.localDateKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentIndex => $composableBuilder(
    column: $table.currentIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get completedCount => $composableBuilder(
    column: $table.completedCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get starsEarned => $composableBuilder(
    column: $table.starsEarned,
    builder: (column) => ColumnFilters(column),
  );

  $$ChildProfilesTableFilterComposer get profileId {
    final $$ChildProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.childProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChildProfilesTableFilterComposer(
            $db: $db,
            $table: $db.childProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> dailyJourneyItemsRefs(
    Expression<bool> Function($$DailyJourneyItemsTableFilterComposer f) f,
  ) {
    final $$DailyJourneyItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.dailyJourneyItems,
      getReferencedColumn: (t) => t.journeyId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DailyJourneyItemsTableFilterComposer(
            $db: $db,
            $table: $db.dailyJourneyItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DailyJourneysTableOrderingComposer
    extends Composer<_$AppDatabase, $DailyJourneysTable> {
  $$DailyJourneysTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localDateKey => $composableBuilder(
    column: $table.localDateKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentIndex => $composableBuilder(
    column: $table.currentIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get completedCount => $composableBuilder(
    column: $table.completedCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get starsEarned => $composableBuilder(
    column: $table.starsEarned,
    builder: (column) => ColumnOrderings(column),
  );

  $$ChildProfilesTableOrderingComposer get profileId {
    final $$ChildProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.childProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChildProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.childProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DailyJourneysTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailyJourneysTable> {
  $$DailyJourneysTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get localDateKey => $composableBuilder(
    column: $table.localDateKey,
    builder: (column) => column,
  );

  GeneratedColumn<int> get currentIndex => $composableBuilder(
    column: $table.currentIndex,
    builder: (column) => column,
  );

  GeneratedColumn<int> get completedCount => $composableBuilder(
    column: $table.completedCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get starsEarned => $composableBuilder(
    column: $table.starsEarned,
    builder: (column) => column,
  );

  $$ChildProfilesTableAnnotationComposer get profileId {
    final $$ChildProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.childProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChildProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.childProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> dailyJourneyItemsRefs<T extends Object>(
    Expression<T> Function($$DailyJourneyItemsTableAnnotationComposer a) f,
  ) {
    final $$DailyJourneyItemsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.dailyJourneyItems,
          getReferencedColumn: (t) => t.journeyId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$DailyJourneyItemsTableAnnotationComposer(
                $db: $db,
                $table: $db.dailyJourneyItems,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$DailyJourneysTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DailyJourneysTable,
          DailyJourney,
          $$DailyJourneysTableFilterComposer,
          $$DailyJourneysTableOrderingComposer,
          $$DailyJourneysTableAnnotationComposer,
          $$DailyJourneysTableCreateCompanionBuilder,
          $$DailyJourneysTableUpdateCompanionBuilder,
          (DailyJourney, $$DailyJourneysTableReferences),
          DailyJourney,
          PrefetchHooks Function({bool profileId, bool dailyJourneyItemsRefs})
        > {
  $$DailyJourneysTableTableManager(_$AppDatabase db, $DailyJourneysTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyJourneysTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailyJourneysTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DailyJourneysTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> profileId = const Value.absent(),
                Value<String> localDateKey = const Value.absent(),
                Value<int> currentIndex = const Value.absent(),
                Value<int> completedCount = const Value.absent(),
                Value<int> starsEarned = const Value.absent(),
              }) => DailyJourneysCompanion(
                id: id,
                profileId: profileId,
                localDateKey: localDateKey,
                currentIndex: currentIndex,
                completedCount: completedCount,
                starsEarned: starsEarned,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int profileId,
                required String localDateKey,
                Value<int> currentIndex = const Value.absent(),
                Value<int> completedCount = const Value.absent(),
                Value<int> starsEarned = const Value.absent(),
              }) => DailyJourneysCompanion.insert(
                id: id,
                profileId: profileId,
                localDateKey: localDateKey,
                currentIndex: currentIndex,
                completedCount: completedCount,
                starsEarned: starsEarned,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DailyJourneysTable, DailyJourney>(table),
                  $$DailyJourneysTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({profileId = false, dailyJourneyItemsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (dailyJourneyItemsRefs) db.dailyJourneyItems,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (profileId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.profileId,
                            referencedTable: $$DailyJourneysTableReferences
                                ._profileIdTable(db),
                            referencedColumn: $$DailyJourneysTableReferences
                                ._profileIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (dailyJourneyItemsRefs)
                        await $_getPrefetchedData<
                          DailyJourney,
                          $DailyJourneysTable,
                          DailyJourneyItem
                        >(
                          currentTable: table,
                          referencedTable: $$DailyJourneysTableReferences
                              ._dailyJourneyItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$DailyJourneysTableReferences(
                                db,
                                table,
                                p0,
                              ).dailyJourneyItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.journeyId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$DailyJourneysTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DailyJourneysTable,
      DailyJourney,
      $$DailyJourneysTableFilterComposer,
      $$DailyJourneysTableOrderingComposer,
      $$DailyJourneysTableAnnotationComposer,
      $$DailyJourneysTableCreateCompanionBuilder,
      $$DailyJourneysTableUpdateCompanionBuilder,
      (DailyJourney, $$DailyJourneysTableReferences),
      DailyJourney,
      PrefetchHooks Function({bool profileId, bool dailyJourneyItemsRefs})
    >;
typedef $$DailyJourneyItemsTableCreateCompanionBuilder =
    DailyJourneyItemsCompanion Function({
      required int journeyId,
      required int position,
      required String activityId,
      Value<String> role,
      Value<bool> done,
      Value<int> rowid,
    });
typedef $$DailyJourneyItemsTableUpdateCompanionBuilder =
    DailyJourneyItemsCompanion Function({
      Value<int> journeyId,
      Value<int> position,
      Value<String> activityId,
      Value<String> role,
      Value<bool> done,
      Value<int> rowid,
    });

final class $$DailyJourneyItemsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $DailyJourneyItemsTable,
          DailyJourneyItem
        > {
  $$DailyJourneyItemsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $DailyJourneysTable _journeyIdTable(_$AppDatabase db) => db
      .dailyJourneys
      .createAlias('daily_journey_items__journey_id__daily_journeys__id');

  $$DailyJourneysTableProcessedTableManager get journeyId {
    final $_column = $_itemColumn<int>('journey_id')!;

    final manager = $$DailyJourneysTableTableManager(
      $_db,
      $_db.dailyJourneys,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_journeyIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$DailyJourneyItemsTableFilterComposer
    extends Composer<_$AppDatabase, $DailyJourneyItemsTable> {
  $$DailyJourneyItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get activityId => $composableBuilder(
    column: $table.activityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get done => $composableBuilder(
    column: $table.done,
    builder: (column) => ColumnFilters(column),
  );

  $$DailyJourneysTableFilterComposer get journeyId {
    final $$DailyJourneysTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.journeyId,
      referencedTable: $db.dailyJourneys,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DailyJourneysTableFilterComposer(
            $db: $db,
            $table: $db.dailyJourneys,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DailyJourneyItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $DailyJourneyItemsTable> {
  $$DailyJourneyItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get activityId => $composableBuilder(
    column: $table.activityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get done => $composableBuilder(
    column: $table.done,
    builder: (column) => ColumnOrderings(column),
  );

  $$DailyJourneysTableOrderingComposer get journeyId {
    final $$DailyJourneysTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.journeyId,
      referencedTable: $db.dailyJourneys,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DailyJourneysTableOrderingComposer(
            $db: $db,
            $table: $db.dailyJourneys,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DailyJourneyItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailyJourneyItemsTable> {
  $$DailyJourneyItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get activityId => $composableBuilder(
    column: $table.activityId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<bool> get done =>
      $composableBuilder(column: $table.done, builder: (column) => column);

  $$DailyJourneysTableAnnotationComposer get journeyId {
    final $$DailyJourneysTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.journeyId,
      referencedTable: $db.dailyJourneys,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DailyJourneysTableAnnotationComposer(
            $db: $db,
            $table: $db.dailyJourneys,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DailyJourneyItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DailyJourneyItemsTable,
          DailyJourneyItem,
          $$DailyJourneyItemsTableFilterComposer,
          $$DailyJourneyItemsTableOrderingComposer,
          $$DailyJourneyItemsTableAnnotationComposer,
          $$DailyJourneyItemsTableCreateCompanionBuilder,
          $$DailyJourneyItemsTableUpdateCompanionBuilder,
          (DailyJourneyItem, $$DailyJourneyItemsTableReferences),
          DailyJourneyItem,
          PrefetchHooks Function({bool journeyId})
        > {
  $$DailyJourneyItemsTableTableManager(
    _$AppDatabase db,
    $DailyJourneyItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyJourneyItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailyJourneyItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DailyJourneyItemsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> journeyId = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<String> activityId = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<bool> done = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DailyJourneyItemsCompanion(
                journeyId: journeyId,
                position: position,
                activityId: activityId,
                role: role,
                done: done,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int journeyId,
                required int position,
                required String activityId,
                Value<String> role = const Value.absent(),
                Value<bool> done = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DailyJourneyItemsCompanion.insert(
                journeyId: journeyId,
                position: position,
                activityId: activityId,
                role: role,
                done: done,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DailyJourneyItemsTable, DailyJourneyItem>(table),
                  $$DailyJourneyItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({journeyId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (journeyId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.journeyId,
                        referencedTable: $$DailyJourneyItemsTableReferences
                            ._journeyIdTable(db),
                        referencedColumn: $$DailyJourneyItemsTableReferences
                            ._journeyIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$DailyJourneyItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DailyJourneyItemsTable,
      DailyJourneyItem,
      $$DailyJourneyItemsTableFilterComposer,
      $$DailyJourneyItemsTableOrderingComposer,
      $$DailyJourneyItemsTableAnnotationComposer,
      $$DailyJourneyItemsTableCreateCompanionBuilder,
      $$DailyJourneyItemsTableUpdateCompanionBuilder,
      (DailyJourneyItem, $$DailyJourneyItemsTableReferences),
      DailyJourneyItem,
      PrefetchHooks Function({bool journeyId})
    >;
typedef $$RewardsTableCreateCompanionBuilder = RewardsCompanion Function({
  required int profileId,
  required String rewardId,
  required int unlockedAt,
  Value<int> rowid,
});
typedef $$RewardsTableUpdateCompanionBuilder = RewardsCompanion Function({
  Value<int> profileId,
  Value<String> rewardId,
  Value<int> unlockedAt,
  Value<int> rowid,
});

final class $$RewardsTableReferences
    extends BaseReferences<_$AppDatabase, $RewardsTable, Reward> {
  $$RewardsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ChildProfilesTable _profileIdTable(_$AppDatabase db) =>
      db.childProfiles.createAlias('rewards__profile_id__child_profiles__id');

  $$ChildProfilesTableProcessedTableManager get profileId {
    final $_column = $_itemColumn<int>('profile_id')!;

    final manager = $$ChildProfilesTableTableManager(
      $_db,
      $_db.childProfiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_profileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RewardsTableFilterComposer
    extends Composer<_$AppDatabase, $RewardsTable> {
  $$RewardsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get rewardId => $composableBuilder(
    column: $table.rewardId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get unlockedAt => $composableBuilder(
    column: $table.unlockedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ChildProfilesTableFilterComposer get profileId {
    final $$ChildProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.childProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChildProfilesTableFilterComposer(
            $db: $db,
            $table: $db.childProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RewardsTableOrderingComposer
    extends Composer<_$AppDatabase, $RewardsTable> {
  $$RewardsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get rewardId => $composableBuilder(
    column: $table.rewardId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get unlockedAt => $composableBuilder(
    column: $table.unlockedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ChildProfilesTableOrderingComposer get profileId {
    final $$ChildProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.childProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChildProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.childProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RewardsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RewardsTable> {
  $$RewardsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get rewardId =>
      $composableBuilder(column: $table.rewardId, builder: (column) => column);

  GeneratedColumn<int> get unlockedAt => $composableBuilder(
    column: $table.unlockedAt,
    builder: (column) => column,
  );

  $$ChildProfilesTableAnnotationComposer get profileId {
    final $$ChildProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.childProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChildProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.childProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RewardsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RewardsTable,
          Reward,
          $$RewardsTableFilterComposer,
          $$RewardsTableOrderingComposer,
          $$RewardsTableAnnotationComposer,
          $$RewardsTableCreateCompanionBuilder,
          $$RewardsTableUpdateCompanionBuilder,
          (Reward, $$RewardsTableReferences),
          Reward,
          PrefetchHooks Function({bool profileId})
        > {
  $$RewardsTableTableManager(_$AppDatabase db, $RewardsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RewardsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RewardsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RewardsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> profileId = const Value.absent(),
                Value<String> rewardId = const Value.absent(),
                Value<int> unlockedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RewardsCompanion(
                profileId: profileId,
                rewardId: rewardId,
                unlockedAt: unlockedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int profileId,
                required String rewardId,
                required int unlockedAt,
                Value<int> rowid = const Value.absent(),
              }) => RewardsCompanion.insert(
                profileId: profileId,
                rewardId: rewardId,
                unlockedAt: unlockedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RewardsTable, Reward>(table),
                  $$RewardsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({profileId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (profileId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.profileId,
                        referencedTable: $$RewardsTableReferences
                            ._profileIdTable(db),
                        referencedColumn: $$RewardsTableReferences
                            ._profileIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$RewardsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RewardsTable,
      Reward,
      $$RewardsTableFilterComposer,
      $$RewardsTableOrderingComposer,
      $$RewardsTableAnnotationComposer,
      $$RewardsTableCreateCompanionBuilder,
      $$RewardsTableUpdateCompanionBuilder,
      (Reward, $$RewardsTableReferences),
      Reward,
      PrefetchHooks Function({bool profileId})
    >;
typedef $$PracticeDaysTableCreateCompanionBuilder =
    PracticeDaysCompanion Function({
      required int profileId,
      required String localDateKey,
      Value<int> rowid,
    });
typedef $$PracticeDaysTableUpdateCompanionBuilder =
    PracticeDaysCompanion Function({
      Value<int> profileId,
      Value<String> localDateKey,
      Value<int> rowid,
    });

final class $$PracticeDaysTableReferences
    extends BaseReferences<_$AppDatabase, $PracticeDaysTable, PracticeDay> {
  $$PracticeDaysTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ChildProfilesTable _profileIdTable(_$AppDatabase db) => db
      .childProfiles
      .createAlias('practice_days__profile_id__child_profiles__id');

  $$ChildProfilesTableProcessedTableManager get profileId {
    final $_column = $_itemColumn<int>('profile_id')!;

    final manager = $$ChildProfilesTableTableManager(
      $_db,
      $_db.childProfiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_profileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PracticeDaysTableFilterComposer
    extends Composer<_$AppDatabase, $PracticeDaysTable> {
  $$PracticeDaysTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get localDateKey => $composableBuilder(
    column: $table.localDateKey,
    builder: (column) => ColumnFilters(column),
  );

  $$ChildProfilesTableFilterComposer get profileId {
    final $$ChildProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.childProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChildProfilesTableFilterComposer(
            $db: $db,
            $table: $db.childProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PracticeDaysTableOrderingComposer
    extends Composer<_$AppDatabase, $PracticeDaysTable> {
  $$PracticeDaysTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get localDateKey => $composableBuilder(
    column: $table.localDateKey,
    builder: (column) => ColumnOrderings(column),
  );

  $$ChildProfilesTableOrderingComposer get profileId {
    final $$ChildProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.childProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChildProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.childProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PracticeDaysTableAnnotationComposer
    extends Composer<_$AppDatabase, $PracticeDaysTable> {
  $$PracticeDaysTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get localDateKey => $composableBuilder(
    column: $table.localDateKey,
    builder: (column) => column,
  );

  $$ChildProfilesTableAnnotationComposer get profileId {
    final $$ChildProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.childProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChildProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.childProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PracticeDaysTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PracticeDaysTable,
          PracticeDay,
          $$PracticeDaysTableFilterComposer,
          $$PracticeDaysTableOrderingComposer,
          $$PracticeDaysTableAnnotationComposer,
          $$PracticeDaysTableCreateCompanionBuilder,
          $$PracticeDaysTableUpdateCompanionBuilder,
          (PracticeDay, $$PracticeDaysTableReferences),
          PracticeDay,
          PrefetchHooks Function({bool profileId})
        > {
  $$PracticeDaysTableTableManager(_$AppDatabase db, $PracticeDaysTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PracticeDaysTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PracticeDaysTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PracticeDaysTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> profileId = const Value.absent(),
                Value<String> localDateKey = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PracticeDaysCompanion(
                profileId: profileId,
                localDateKey: localDateKey,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int profileId,
                required String localDateKey,
                Value<int> rowid = const Value.absent(),
              }) => PracticeDaysCompanion.insert(
                profileId: profileId,
                localDateKey: localDateKey,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PracticeDaysTable, PracticeDay>(table),
                  $$PracticeDaysTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({profileId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (profileId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.profileId,
                        referencedTable: $$PracticeDaysTableReferences
                            ._profileIdTable(db),
                        referencedColumn: $$PracticeDaysTableReferences
                            ._profileIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PracticeDaysTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PracticeDaysTable,
      PracticeDay,
      $$PracticeDaysTableFilterComposer,
      $$PracticeDaysTableOrderingComposer,
      $$PracticeDaysTableAnnotationComposer,
      $$PracticeDaysTableCreateCompanionBuilder,
      $$PracticeDaysTableUpdateCompanionBuilder,
      (PracticeDay, $$PracticeDaysTableReferences),
      PracticeDay,
      PrefetchHooks Function({bool profileId})
    >;
typedef $$EntitlementCacheEntriesTableCreateCompanionBuilder =
    EntitlementCacheEntriesCompanion Function({
      Value<int> id,
      Value<String?> productId,
      required String status,
      Value<int?> expiryMillis,
      Value<int?> lastReconciledAt,
    });
typedef $$EntitlementCacheEntriesTableUpdateCompanionBuilder =
    EntitlementCacheEntriesCompanion Function({
      Value<int> id,
      Value<String?> productId,
      Value<String> status,
      Value<int?> expiryMillis,
      Value<int?> lastReconciledAt,
    });

class $$EntitlementCacheEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $EntitlementCacheEntriesTable> {
  $$EntitlementCacheEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get expiryMillis => $composableBuilder(
    column: $table.expiryMillis,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastReconciledAt => $composableBuilder(
    column: $table.lastReconciledAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$EntitlementCacheEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $EntitlementCacheEntriesTable> {
  $$EntitlementCacheEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get expiryMillis => $composableBuilder(
    column: $table.expiryMillis,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastReconciledAt => $composableBuilder(
    column: $table.lastReconciledAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EntitlementCacheEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $EntitlementCacheEntriesTable> {
  $$EntitlementCacheEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get expiryMillis => $composableBuilder(
    column: $table.expiryMillis,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lastReconciledAt => $composableBuilder(
    column: $table.lastReconciledAt,
    builder: (column) => column,
  );
}

class $$EntitlementCacheEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EntitlementCacheEntriesTable,
          EntitlementCacheEntry,
          $$EntitlementCacheEntriesTableFilterComposer,
          $$EntitlementCacheEntriesTableOrderingComposer,
          $$EntitlementCacheEntriesTableAnnotationComposer,
          $$EntitlementCacheEntriesTableCreateCompanionBuilder,
          $$EntitlementCacheEntriesTableUpdateCompanionBuilder,
          (
            EntitlementCacheEntry,
            BaseReferences<
              _$AppDatabase,
              $EntitlementCacheEntriesTable,
              EntitlementCacheEntry
            >,
          ),
          EntitlementCacheEntry,
          PrefetchHooks Function()
        > {
  $$EntitlementCacheEntriesTableTableManager(
    _$AppDatabase db,
    $EntitlementCacheEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EntitlementCacheEntriesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$EntitlementCacheEntriesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$EntitlementCacheEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> productId = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int?> expiryMillis = const Value.absent(),
                Value<int?> lastReconciledAt = const Value.absent(),
              }) => EntitlementCacheEntriesCompanion(
                id: id,
                productId: productId,
                status: status,
                expiryMillis: expiryMillis,
                lastReconciledAt: lastReconciledAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> productId = const Value.absent(),
                required String status,
                Value<int?> expiryMillis = const Value.absent(),
                Value<int?> lastReconciledAt = const Value.absent(),
              }) => EntitlementCacheEntriesCompanion.insert(
                id: id,
                productId: productId,
                status: status,
                expiryMillis: expiryMillis,
                lastReconciledAt: lastReconciledAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $EntitlementCacheEntriesTable,
                    EntitlementCacheEntry
                  >(table),
                  BaseReferences<
                    _$AppDatabase,
                    $EntitlementCacheEntriesTable,
                    EntitlementCacheEntry
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$EntitlementCacheEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EntitlementCacheEntriesTable,
      EntitlementCacheEntry,
      $$EntitlementCacheEntriesTableFilterComposer,
      $$EntitlementCacheEntriesTableOrderingComposer,
      $$EntitlementCacheEntriesTableAnnotationComposer,
      $$EntitlementCacheEntriesTableCreateCompanionBuilder,
      $$EntitlementCacheEntriesTableUpdateCompanionBuilder,
      (
        EntitlementCacheEntry,
        BaseReferences<
          _$AppDatabase,
          $EntitlementCacheEntriesTable,
          EntitlementCacheEntry
        >,
      ),
      EntitlementCacheEntry,
      PrefetchHooks Function()
    >;
typedef $$LocalSettingsTableCreateCompanionBuilder =
    LocalSettingsCompanion Function({
      Value<int> id,
      Value<bool> soundEffectsEnabled,
      Value<bool> musicEnabled,
      Value<bool> narrationEnabled,
      Value<bool> onboardingComplete,
      Value<int> onboardingStep,
      Value<String?> draftAgeBand,
      Value<String?> draftAvatarId,
      Value<String?> draftNickname,
      Value<bool> remindersEnabled,
      Value<int> reminderMinutes,
      Value<bool> reducedMotion,
      Value<int> sessionLimitMinutes,
    });
typedef $$LocalSettingsTableUpdateCompanionBuilder =
    LocalSettingsCompanion Function({
      Value<int> id,
      Value<bool> soundEffectsEnabled,
      Value<bool> musicEnabled,
      Value<bool> narrationEnabled,
      Value<bool> onboardingComplete,
      Value<int> onboardingStep,
      Value<String?> draftAgeBand,
      Value<String?> draftAvatarId,
      Value<String?> draftNickname,
      Value<bool> remindersEnabled,
      Value<int> reminderMinutes,
      Value<bool> reducedMotion,
      Value<int> sessionLimitMinutes,
    });

class $$LocalSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $LocalSettingsTable> {
  $$LocalSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get soundEffectsEnabled => $composableBuilder(
    column: $table.soundEffectsEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get musicEnabled => $composableBuilder(
    column: $table.musicEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get narrationEnabled => $composableBuilder(
    column: $table.narrationEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get onboardingComplete => $composableBuilder(
    column: $table.onboardingComplete,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get onboardingStep => $composableBuilder(
    column: $table.onboardingStep,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get draftAgeBand => $composableBuilder(
    column: $table.draftAgeBand,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get draftAvatarId => $composableBuilder(
    column: $table.draftAvatarId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get draftNickname => $composableBuilder(
    column: $table.draftNickname,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get remindersEnabled => $composableBuilder(
    column: $table.remindersEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reminderMinutes => $composableBuilder(
    column: $table.reminderMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get reducedMotion => $composableBuilder(
    column: $table.reducedMotion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sessionLimitMinutes => $composableBuilder(
    column: $table.sessionLimitMinutes,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalSettingsTable> {
  $$LocalSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get soundEffectsEnabled => $composableBuilder(
    column: $table.soundEffectsEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get musicEnabled => $composableBuilder(
    column: $table.musicEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get narrationEnabled => $composableBuilder(
    column: $table.narrationEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get onboardingComplete => $composableBuilder(
    column: $table.onboardingComplete,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get onboardingStep => $composableBuilder(
    column: $table.onboardingStep,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get draftAgeBand => $composableBuilder(
    column: $table.draftAgeBand,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get draftAvatarId => $composableBuilder(
    column: $table.draftAvatarId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get draftNickname => $composableBuilder(
    column: $table.draftNickname,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get remindersEnabled => $composableBuilder(
    column: $table.remindersEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reminderMinutes => $composableBuilder(
    column: $table.reminderMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get reducedMotion => $composableBuilder(
    column: $table.reducedMotion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sessionLimitMinutes => $composableBuilder(
    column: $table.sessionLimitMinutes,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalSettingsTable> {
  $$LocalSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<bool> get soundEffectsEnabled => $composableBuilder(
    column: $table.soundEffectsEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get musicEnabled => $composableBuilder(
    column: $table.musicEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get narrationEnabled => $composableBuilder(
    column: $table.narrationEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get onboardingComplete => $composableBuilder(
    column: $table.onboardingComplete,
    builder: (column) => column,
  );

  GeneratedColumn<int> get onboardingStep => $composableBuilder(
    column: $table.onboardingStep,
    builder: (column) => column,
  );

  GeneratedColumn<String> get draftAgeBand => $composableBuilder(
    column: $table.draftAgeBand,
    builder: (column) => column,
  );

  GeneratedColumn<String> get draftAvatarId => $composableBuilder(
    column: $table.draftAvatarId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get draftNickname => $composableBuilder(
    column: $table.draftNickname,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get remindersEnabled => $composableBuilder(
    column: $table.remindersEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<int> get reminderMinutes => $composableBuilder(
    column: $table.reminderMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get reducedMotion => $composableBuilder(
    column: $table.reducedMotion,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sessionLimitMinutes => $composableBuilder(
    column: $table.sessionLimitMinutes,
    builder: (column) => column,
  );
}

class $$LocalSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalSettingsTable,
          LocalSetting,
          $$LocalSettingsTableFilterComposer,
          $$LocalSettingsTableOrderingComposer,
          $$LocalSettingsTableAnnotationComposer,
          $$LocalSettingsTableCreateCompanionBuilder,
          $$LocalSettingsTableUpdateCompanionBuilder,
          (
            LocalSetting,
            BaseReferences<_$AppDatabase, $LocalSettingsTable, LocalSetting>,
          ),
          LocalSetting,
          PrefetchHooks Function()
        > {
  $$LocalSettingsTableTableManager(_$AppDatabase db, $LocalSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<bool> soundEffectsEnabled = const Value.absent(),
                Value<bool> musicEnabled = const Value.absent(),
                Value<bool> narrationEnabled = const Value.absent(),
                Value<bool> onboardingComplete = const Value.absent(),
                Value<int> onboardingStep = const Value.absent(),
                Value<String?> draftAgeBand = const Value.absent(),
                Value<String?> draftAvatarId = const Value.absent(),
                Value<String?> draftNickname = const Value.absent(),
                Value<bool> remindersEnabled = const Value.absent(),
                Value<int> reminderMinutes = const Value.absent(),
                Value<bool> reducedMotion = const Value.absent(),
                Value<int> sessionLimitMinutes = const Value.absent(),
              }) => LocalSettingsCompanion(
                id: id,
                soundEffectsEnabled: soundEffectsEnabled,
                musicEnabled: musicEnabled,
                narrationEnabled: narrationEnabled,
                onboardingComplete: onboardingComplete,
                onboardingStep: onboardingStep,
                draftAgeBand: draftAgeBand,
                draftAvatarId: draftAvatarId,
                draftNickname: draftNickname,
                remindersEnabled: remindersEnabled,
                reminderMinutes: reminderMinutes,
                reducedMotion: reducedMotion,
                sessionLimitMinutes: sessionLimitMinutes,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<bool> soundEffectsEnabled = const Value.absent(),
                Value<bool> musicEnabled = const Value.absent(),
                Value<bool> narrationEnabled = const Value.absent(),
                Value<bool> onboardingComplete = const Value.absent(),
                Value<int> onboardingStep = const Value.absent(),
                Value<String?> draftAgeBand = const Value.absent(),
                Value<String?> draftAvatarId = const Value.absent(),
                Value<String?> draftNickname = const Value.absent(),
                Value<bool> remindersEnabled = const Value.absent(),
                Value<int> reminderMinutes = const Value.absent(),
                Value<bool> reducedMotion = const Value.absent(),
                Value<int> sessionLimitMinutes = const Value.absent(),
              }) => LocalSettingsCompanion.insert(
                id: id,
                soundEffectsEnabled: soundEffectsEnabled,
                musicEnabled: musicEnabled,
                narrationEnabled: narrationEnabled,
                onboardingComplete: onboardingComplete,
                onboardingStep: onboardingStep,
                draftAgeBand: draftAgeBand,
                draftAvatarId: draftAvatarId,
                draftNickname: draftNickname,
                remindersEnabled: remindersEnabled,
                reminderMinutes: reminderMinutes,
                reducedMotion: reducedMotion,
                sessionLimitMinutes: sessionLimitMinutes,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LocalSettingsTable, LocalSetting>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $LocalSettingsTable,
                    LocalSetting
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalSettingsTable,
      LocalSetting,
      $$LocalSettingsTableFilterComposer,
      $$LocalSettingsTableOrderingComposer,
      $$LocalSettingsTableAnnotationComposer,
      $$LocalSettingsTableCreateCompanionBuilder,
      $$LocalSettingsTableUpdateCompanionBuilder,
      (
        LocalSetting,
        BaseReferences<_$AppDatabase, $LocalSettingsTable, LocalSetting>,
      ),
      LocalSetting,
      PrefetchHooks Function()
    >;
typedef $$RecentGeneratedLevelsTableCreateCompanionBuilder =
    RecentGeneratedLevelsCompanion Function({
      Value<int> id,
      required int profileId,
      required String engineType,
      required String instanceId,
      required int playedAt,
    });
typedef $$RecentGeneratedLevelsTableUpdateCompanionBuilder =
    RecentGeneratedLevelsCompanion Function({
      Value<int> id,
      Value<int> profileId,
      Value<String> engineType,
      Value<String> instanceId,
      Value<int> playedAt,
    });

final class $$RecentGeneratedLevelsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $RecentGeneratedLevelsTable,
          RecentGeneratedLevel
        > {
  $$RecentGeneratedLevelsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ChildProfilesTable _profileIdTable(_$AppDatabase db) => db
      .childProfiles
      .createAlias('recent_generated_levels__profile_id__child_profiles__id');

  $$ChildProfilesTableProcessedTableManager get profileId {
    final $_column = $_itemColumn<int>('profile_id')!;

    final manager = $$ChildProfilesTableTableManager(
      $_db,
      $_db.childProfiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_profileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RecentGeneratedLevelsTableFilterComposer
    extends Composer<_$AppDatabase, $RecentGeneratedLevelsTable> {
  $$RecentGeneratedLevelsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get engineType => $composableBuilder(
    column: $table.engineType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get instanceId => $composableBuilder(
    column: $table.instanceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get playedAt => $composableBuilder(
    column: $table.playedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ChildProfilesTableFilterComposer get profileId {
    final $$ChildProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.childProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChildProfilesTableFilterComposer(
            $db: $db,
            $table: $db.childProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecentGeneratedLevelsTableOrderingComposer
    extends Composer<_$AppDatabase, $RecentGeneratedLevelsTable> {
  $$RecentGeneratedLevelsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get engineType => $composableBuilder(
    column: $table.engineType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get instanceId => $composableBuilder(
    column: $table.instanceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get playedAt => $composableBuilder(
    column: $table.playedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ChildProfilesTableOrderingComposer get profileId {
    final $$ChildProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.childProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChildProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.childProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecentGeneratedLevelsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecentGeneratedLevelsTable> {
  $$RecentGeneratedLevelsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get engineType => $composableBuilder(
    column: $table.engineType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get instanceId => $composableBuilder(
    column: $table.instanceId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get playedAt =>
      $composableBuilder(column: $table.playedAt, builder: (column) => column);

  $$ChildProfilesTableAnnotationComposer get profileId {
    final $$ChildProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.childProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChildProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.childProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecentGeneratedLevelsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecentGeneratedLevelsTable,
          RecentGeneratedLevel,
          $$RecentGeneratedLevelsTableFilterComposer,
          $$RecentGeneratedLevelsTableOrderingComposer,
          $$RecentGeneratedLevelsTableAnnotationComposer,
          $$RecentGeneratedLevelsTableCreateCompanionBuilder,
          $$RecentGeneratedLevelsTableUpdateCompanionBuilder,
          (RecentGeneratedLevel, $$RecentGeneratedLevelsTableReferences),
          RecentGeneratedLevel,
          PrefetchHooks Function({bool profileId})
        > {
  $$RecentGeneratedLevelsTableTableManager(
    _$AppDatabase db,
    $RecentGeneratedLevelsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecentGeneratedLevelsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$RecentGeneratedLevelsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$RecentGeneratedLevelsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> profileId = const Value.absent(),
                Value<String> engineType = const Value.absent(),
                Value<String> instanceId = const Value.absent(),
                Value<int> playedAt = const Value.absent(),
              }) => RecentGeneratedLevelsCompanion(
                id: id,
                profileId: profileId,
                engineType: engineType,
                instanceId: instanceId,
                playedAt: playedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int profileId,
                required String engineType,
                required String instanceId,
                required int playedAt,
              }) => RecentGeneratedLevelsCompanion.insert(
                id: id,
                profileId: profileId,
                engineType: engineType,
                instanceId: instanceId,
                playedAt: playedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $RecentGeneratedLevelsTable,
                    RecentGeneratedLevel
                  >(table),
                  $$RecentGeneratedLevelsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({profileId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (profileId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.profileId,
                        referencedTable: $$RecentGeneratedLevelsTableReferences
                            ._profileIdTable(db),
                        referencedColumn: $$RecentGeneratedLevelsTableReferences
                            ._profileIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$RecentGeneratedLevelsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecentGeneratedLevelsTable,
      RecentGeneratedLevel,
      $$RecentGeneratedLevelsTableFilterComposer,
      $$RecentGeneratedLevelsTableOrderingComposer,
      $$RecentGeneratedLevelsTableAnnotationComposer,
      $$RecentGeneratedLevelsTableCreateCompanionBuilder,
      $$RecentGeneratedLevelsTableUpdateCompanionBuilder,
      (RecentGeneratedLevel, $$RecentGeneratedLevelsTableReferences),
      RecentGeneratedLevel,
      PrefetchHooks Function({bool profileId})
    >;
typedef $$ActivityCheckpointsTableCreateCompanionBuilder =
    ActivityCheckpointsCompanion Function({
      required int profileId,
      required String activityId,
      required int payloadVersion,
      required String payload,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$ActivityCheckpointsTableUpdateCompanionBuilder =
    ActivityCheckpointsCompanion Function({
      Value<int> profileId,
      Value<String> activityId,
      Value<int> payloadVersion,
      Value<String> payload,
      Value<int> updatedAt,
      Value<int> rowid,
    });

final class $$ActivityCheckpointsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ActivityCheckpointsTable,
          ActivityCheckpoint
        > {
  $$ActivityCheckpointsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ChildProfilesTable _profileIdTable(_$AppDatabase db) => db
      .childProfiles
      .createAlias('activity_checkpoints__profile_id__child_profiles__id');

  $$ChildProfilesTableProcessedTableManager get profileId {
    final $_column = $_itemColumn<int>('profile_id')!;

    final manager = $$ChildProfilesTableTableManager(
      $_db,
      $_db.childProfiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_profileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ActivityCheckpointsTableFilterComposer
    extends Composer<_$AppDatabase, $ActivityCheckpointsTable> {
  $$ActivityCheckpointsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get activityId => $composableBuilder(
    column: $table.activityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get payloadVersion => $composableBuilder(
    column: $table.payloadVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ChildProfilesTableFilterComposer get profileId {
    final $$ChildProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.childProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChildProfilesTableFilterComposer(
            $db: $db,
            $table: $db.childProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ActivityCheckpointsTableOrderingComposer
    extends Composer<_$AppDatabase, $ActivityCheckpointsTable> {
  $$ActivityCheckpointsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get activityId => $composableBuilder(
    column: $table.activityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get payloadVersion => $composableBuilder(
    column: $table.payloadVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ChildProfilesTableOrderingComposer get profileId {
    final $$ChildProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.childProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChildProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.childProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ActivityCheckpointsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ActivityCheckpointsTable> {
  $$ActivityCheckpointsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get activityId => $composableBuilder(
    column: $table.activityId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get payloadVersion => $composableBuilder(
    column: $table.payloadVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$ChildProfilesTableAnnotationComposer get profileId {
    final $$ChildProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.childProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChildProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.childProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ActivityCheckpointsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ActivityCheckpointsTable,
          ActivityCheckpoint,
          $$ActivityCheckpointsTableFilterComposer,
          $$ActivityCheckpointsTableOrderingComposer,
          $$ActivityCheckpointsTableAnnotationComposer,
          $$ActivityCheckpointsTableCreateCompanionBuilder,
          $$ActivityCheckpointsTableUpdateCompanionBuilder,
          (ActivityCheckpoint, $$ActivityCheckpointsTableReferences),
          ActivityCheckpoint,
          PrefetchHooks Function({bool profileId})
        > {
  $$ActivityCheckpointsTableTableManager(
    _$AppDatabase db,
    $ActivityCheckpointsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ActivityCheckpointsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ActivityCheckpointsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ActivityCheckpointsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> profileId = const Value.absent(),
                Value<String> activityId = const Value.absent(),
                Value<int> payloadVersion = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ActivityCheckpointsCompanion(
                profileId: profileId,
                activityId: activityId,
                payloadVersion: payloadVersion,
                payload: payload,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int profileId,
                required String activityId,
                required int payloadVersion,
                required String payload,
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => ActivityCheckpointsCompanion.insert(
                profileId: profileId,
                activityId: activityId,
                payloadVersion: payloadVersion,
                payload: payload,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ActivityCheckpointsTable, ActivityCheckpoint>(
                    table,
                  ),
                  $$ActivityCheckpointsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({profileId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (profileId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.profileId,
                        referencedTable: $$ActivityCheckpointsTableReferences
                            ._profileIdTable(db),
                        referencedColumn: $$ActivityCheckpointsTableReferences
                            ._profileIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ActivityCheckpointsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ActivityCheckpointsTable,
      ActivityCheckpoint,
      $$ActivityCheckpointsTableFilterComposer,
      $$ActivityCheckpointsTableOrderingComposer,
      $$ActivityCheckpointsTableAnnotationComposer,
      $$ActivityCheckpointsTableCreateCompanionBuilder,
      $$ActivityCheckpointsTableUpdateCompanionBuilder,
      (ActivityCheckpoint, $$ActivityCheckpointsTableReferences),
      ActivityCheckpoint,
      PrefetchHooks Function({bool profileId})
    >;
typedef $$LevelBadgesTableCreateCompanionBuilder =
    LevelBadgesCompanion Function({
      required int profileId,
      required String activityId,
      required String engineType,
      required int score,
      required int stars,
      required String outcome,
      required int earnedAt,
      Value<int> rowid,
    });
typedef $$LevelBadgesTableUpdateCompanionBuilder =
    LevelBadgesCompanion Function({
      Value<int> profileId,
      Value<String> activityId,
      Value<String> engineType,
      Value<int> score,
      Value<int> stars,
      Value<String> outcome,
      Value<int> earnedAt,
      Value<int> rowid,
    });

final class $$LevelBadgesTableReferences
    extends BaseReferences<_$AppDatabase, $LevelBadgesTable, LevelBadge> {
  $$LevelBadgesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ChildProfilesTable _profileIdTable(_$AppDatabase db) => db
      .childProfiles
      .createAlias('level_badges__profile_id__child_profiles__id');

  $$ChildProfilesTableProcessedTableManager get profileId {
    final $_column = $_itemColumn<int>('profile_id')!;

    final manager = $$ChildProfilesTableTableManager(
      $_db,
      $_db.childProfiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_profileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$LevelBadgesTableFilterComposer
    extends Composer<_$AppDatabase, $LevelBadgesTable> {
  $$LevelBadgesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get activityId => $composableBuilder(
    column: $table.activityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get engineType => $composableBuilder(
    column: $table.engineType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get stars => $composableBuilder(
    column: $table.stars,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get outcome => $composableBuilder(
    column: $table.outcome,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get earnedAt => $composableBuilder(
    column: $table.earnedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ChildProfilesTableFilterComposer get profileId {
    final $$ChildProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.childProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChildProfilesTableFilterComposer(
            $db: $db,
            $table: $db.childProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LevelBadgesTableOrderingComposer
    extends Composer<_$AppDatabase, $LevelBadgesTable> {
  $$LevelBadgesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get activityId => $composableBuilder(
    column: $table.activityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get engineType => $composableBuilder(
    column: $table.engineType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get stars => $composableBuilder(
    column: $table.stars,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get outcome => $composableBuilder(
    column: $table.outcome,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get earnedAt => $composableBuilder(
    column: $table.earnedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ChildProfilesTableOrderingComposer get profileId {
    final $$ChildProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.childProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChildProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.childProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LevelBadgesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LevelBadgesTable> {
  $$LevelBadgesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get activityId => $composableBuilder(
    column: $table.activityId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get engineType => $composableBuilder(
    column: $table.engineType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get score =>
      $composableBuilder(column: $table.score, builder: (column) => column);

  GeneratedColumn<int> get stars =>
      $composableBuilder(column: $table.stars, builder: (column) => column);

  GeneratedColumn<String> get outcome =>
      $composableBuilder(column: $table.outcome, builder: (column) => column);

  GeneratedColumn<int> get earnedAt =>
      $composableBuilder(column: $table.earnedAt, builder: (column) => column);

  $$ChildProfilesTableAnnotationComposer get profileId {
    final $$ChildProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.childProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChildProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.childProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LevelBadgesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LevelBadgesTable,
          LevelBadge,
          $$LevelBadgesTableFilterComposer,
          $$LevelBadgesTableOrderingComposer,
          $$LevelBadgesTableAnnotationComposer,
          $$LevelBadgesTableCreateCompanionBuilder,
          $$LevelBadgesTableUpdateCompanionBuilder,
          (LevelBadge, $$LevelBadgesTableReferences),
          LevelBadge,
          PrefetchHooks Function({bool profileId})
        > {
  $$LevelBadgesTableTableManager(_$AppDatabase db, $LevelBadgesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LevelBadgesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LevelBadgesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LevelBadgesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> profileId = const Value.absent(),
                Value<String> activityId = const Value.absent(),
                Value<String> engineType = const Value.absent(),
                Value<int> score = const Value.absent(),
                Value<int> stars = const Value.absent(),
                Value<String> outcome = const Value.absent(),
                Value<int> earnedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LevelBadgesCompanion(
                profileId: profileId,
                activityId: activityId,
                engineType: engineType,
                score: score,
                stars: stars,
                outcome: outcome,
                earnedAt: earnedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int profileId,
                required String activityId,
                required String engineType,
                required int score,
                required int stars,
                required String outcome,
                required int earnedAt,
                Value<int> rowid = const Value.absent(),
              }) => LevelBadgesCompanion.insert(
                profileId: profileId,
                activityId: activityId,
                engineType: engineType,
                score: score,
                stars: stars,
                outcome: outcome,
                earnedAt: earnedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LevelBadgesTable, LevelBadge>(table),
                  $$LevelBadgesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({profileId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (profileId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.profileId,
                        referencedTable: $$LevelBadgesTableReferences
                            ._profileIdTable(db),
                        referencedColumn: $$LevelBadgesTableReferences
                            ._profileIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$LevelBadgesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LevelBadgesTable,
      LevelBadge,
      $$LevelBadgesTableFilterComposer,
      $$LevelBadgesTableOrderingComposer,
      $$LevelBadgesTableAnnotationComposer,
      $$LevelBadgesTableCreateCompanionBuilder,
      $$LevelBadgesTableUpdateCompanionBuilder,
      (LevelBadge, $$LevelBadgesTableReferences),
      LevelBadge,
      PrefetchHooks Function({bool profileId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ChildProfilesTableTableManager get childProfiles =>
      $$ChildProfilesTableTableManager(_db, _db.childProfiles);
  $$ActivityProgressTableTableManager get activityProgress =>
      $$ActivityProgressTableTableManager(_db, _db.activityProgress);
  $$SkillProgressTableTableManager get skillProgress =>
      $$SkillProgressTableTableManager(_db, _db.skillProgress);
  $$DailyJourneysTableTableManager get dailyJourneys =>
      $$DailyJourneysTableTableManager(_db, _db.dailyJourneys);
  $$DailyJourneyItemsTableTableManager get dailyJourneyItems =>
      $$DailyJourneyItemsTableTableManager(_db, _db.dailyJourneyItems);
  $$RewardsTableTableManager get rewards =>
      $$RewardsTableTableManager(_db, _db.rewards);
  $$PracticeDaysTableTableManager get practiceDays =>
      $$PracticeDaysTableTableManager(_db, _db.practiceDays);
  $$EntitlementCacheEntriesTableTableManager get entitlementCacheEntries =>
      $$EntitlementCacheEntriesTableTableManager(
        _db,
        _db.entitlementCacheEntries,
      );
  $$LocalSettingsTableTableManager get localSettings =>
      $$LocalSettingsTableTableManager(_db, _db.localSettings);
  $$RecentGeneratedLevelsTableTableManager get recentGeneratedLevels =>
      $$RecentGeneratedLevelsTableTableManager(_db, _db.recentGeneratedLevels);
  $$ActivityCheckpointsTableTableManager get activityCheckpoints =>
      $$ActivityCheckpointsTableTableManager(_db, _db.activityCheckpoints);
  $$LevelBadgesTableTableManager get levelBadges =>
      $$LevelBadgesTableTableManager(_db, _db.levelBadges);
}
