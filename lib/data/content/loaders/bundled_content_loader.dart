import 'dart:convert';

import 'package:flutter/services.dart';

import '../../../domain/models/content_pack.dart';

class ContentPackParseException implements Exception {
  const ContentPackParseException();
}

class BundledContentLoader {
  const BundledContentLoader();

  static const assetPath = 'assets/content/pack_manifest.json';

  Future<ContentPackManifest> loadBundled() {
    return loadFromAsset(assetPath);
  }

  Future<ContentPackManifest> loadFromAsset(String path) async {
    final raw = await rootBundle.loadString(path);
    return parse(raw);
  }

  ContentPackManifest parse(String raw) {
    final decoded = jsonDecode(raw);
    if (decoded is! Map<String, Object?>) {
      throw const ContentPackParseException();
    }
    final activitiesRaw = decoded['activities'];
    if (activitiesRaw is! List<Object?>) {
      throw const ContentPackParseException();
    }
    final reviewStatus = ReviewStatus.fromStorage('${decoded['reviewStatus']}');
    final schemaVersion = decoded['schemaVersion'];
    final contentVersion = decoded['contentVersion'];
    final packId = decoded['packId'];
    if (reviewStatus == null ||
        schemaVersion is! int ||
        contentVersion is! int ||
        packId is! String) {
      throw const ContentPackParseException();
    }
    final minimum = decoded['minimumAppVersion'];
    return ContentPackManifest(
      packId: packId,
      schemaVersion: schemaVersion,
      contentVersion: contentVersion,
      minimumAppVersion: minimum is String ? minimum : null,
      reviewStatus: reviewStatus,
      activities: activitiesRaw.map(_activity).toList(),
    );
  }

  BundledActivity _activity(Object? raw) {
    if (raw is! Map<String, Object?>) {
      throw const ContentPackParseException();
    }
    final reviewStatus = ReviewStatus.fromStorage('${raw['reviewStatus']}');
    final ageBands = raw['ageBands'];
    if (reviewStatus == null || ageBands is! List<Object?>) {
      throw const ContentPackParseException();
    }
    final id = raw['id'];
    final engine = raw['engine'];
    final skill = raw['skill'];
    final difficulty = raw['difficulty'];
    final premium = raw['premium'];
    final contentVersion = raw['contentVersion'];
    if (id is! String ||
        engine is! String ||
        skill is! String ||
        difficulty is! int ||
        premium is! bool ||
        contentVersion is! int) {
      throw const ContentPackParseException();
    }
    return BundledActivity(
      id: id,
      engine: engine,
      skill: skill,
      difficulty: difficulty,
      ageBands: ageBands.map((band) => '$band').toList(),
      premium: premium,
      contentVersion: contentVersion,
      reviewStatus: reviewStatus,
    );
  }
}
