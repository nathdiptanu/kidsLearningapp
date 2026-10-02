import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:sproutlab/domain/geography/geography_models.dart';
import 'package:sproutlab/domain/geography/map_geometry.dart';

IndiaMapAtlas loadAtlas() {
  final raw = File('assets/content/geography/slice_geometry.json')
      .readAsStringSync();
  return atlasFromJson(jsonDecode(raw) as Map<String, dynamic>);
}

void main() {
  final atlas = loadAtlas();
  final interactor = MapInteractor(atlas);

  test(
    'geometry names its public-domain source and is not Survey of India',
    () {
      expect(atlas.sourceName.toLowerCase(), contains('natural earth'));
      expect(atlas.license.toLowerCase(), contains('public domain'));
      expect(atlas.modifications.toLowerCase(), contains('not moved'));
      expect(atlas.sourceUrl, contains('naturalearthdata.com'));
      expect(atlas.regions.length, 36);
    },
  );

  test('pointer coordinates stay square when the canvas is letterboxed', () {
    final wide = CanvasMapTransform.fit(const Size(400, 200));
    expect(wide.width, 200);
    expect(wide.height, 200);
    final local = wide.toLocal(const OffsetPoint(0.5, 0.5));
    expect(local.dx, closeTo(100, 0.001));
    expect(local.dy, closeTo(100, 0.001));
    final back = wide.toNormalized(local);
    expect(back.x, closeTo(0.5, 0.001));
    expect(back.y, closeTo(0.5, 0.001));
  });

  test('a tap inside Kerala hits Kerala and Goa uses a list alternative', () {
    final kerala = atlas.byId('in-kerala')!;
    final goa = atlas.byId('in-goa')!;
    final delhi = atlas.byId('in-delhi')!;
    expect(interactor.contains(kerala, kerala.centroid), isTrue);
    expect(interactor.hit(kerala.centroid)?.regionId, 'in-kerala');
    expect(interactor.needsListAlternative(goa), isTrue);
    expect(interactor.needsListAlternative(delhi), isTrue);
    expect(interactor.needsListAlternative(kerala), isFalse);
    final inset = interactor.insetBounds(goa);
    expect(inset.width, greaterThan(goa.width));
    expect(inset.left, greaterThanOrEqualTo(0));
    expect(inset.right, lessThanOrEqualTo(1));
  });
}
