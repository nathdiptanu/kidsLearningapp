import 'package:flutter_test/flutter_test.dart';
import 'package:sproutlab/data/content/loaders/bundled_content_loader.dart';
import 'package:sproutlab/data/content/validators/content_validator.dart';
import 'package:sproutlab/domain/models/content_pack.dart';

void main() {
  const validator = ContentValidator();
  const loader = BundledContentLoader();

  test('placeholder bundled pack is usable and has no playable facts', () {
    final manifest = loader.parse('''
{
  "packId": "bundled_core",
  "schemaVersion": 1,
  "contentVersion": 1,
  "minimumAppVersion": "0.1.0",
  "reviewStatus": "PLACEHOLDER",
  "activities": []
}
''');
    final result = validator.validate(manifest);
    expect(result.usable, isTrue);
    expect(result.playable, isEmpty);
    expect(manifest.reviewStatus, ReviewStatus.placeholder);
  });

  test('unsupported schema is not usable', () {
    final manifest = loader.parse('''
{
  "packId": "bundled_core",
  "schemaVersion": 99,
  "contentVersion": 1,
  "reviewStatus": "PLACEHOLDER",
  "activities": []
}
''');
    expect(validator.validate(manifest).usable, isFalse);
  });

  test('duplicate ids make the pack unusable', () {
    final manifest = loader.parse('''
{
  "packId": "bundled_core",
  "schemaVersion": 1,
  "contentVersion": 1,
  "reviewStatus": "PLACEHOLDER",
  "activities": [
    {
      "id": "maze_1",
      "engine": "maze",
      "skill": "logic",
      "difficulty": 1,
      "ageBands": ["A"],
      "premium": false,
      "contentVersion": 1,
      "reviewStatus": "APPROVED"
    },
    {
      "id": "maze_1",
      "engine": "maze",
      "skill": "logic",
      "difficulty": 1,
      "ageBands": ["A"],
      "premium": false,
      "contentVersion": 1,
      "reviewStatus": "APPROVED"
    }
  ]
}
''');
    expect(validator.validate(manifest).usable, isFalse);
  });

  test('invalid activity is skipped and approved activity stays playable', () {
    final manifest = loader.parse('''
{
  "packId": "bundled_core",
  "schemaVersion": 1,
  "contentVersion": 1,
  "reviewStatus": "PLACEHOLDER",
  "activities": [
    {
      "id": "bad",
      "engine": "not_an_engine",
      "skill": "logic",
      "difficulty": 1,
      "ageBands": ["A"],
      "premium": false,
      "contentVersion": 1,
      "reviewStatus": "APPROVED"
    },
    {
      "id": "maze_1",
      "engine": "maze",
      "skill": "logic",
      "difficulty": 1,
      "ageBands": ["A"],
      "premium": false,
      "contentVersion": 1,
      "reviewStatus": "APPROVED"
    },
    {
      "id": "draft",
      "engine": "maze",
      "skill": "logic",
      "difficulty": 1,
      "ageBands": ["A"],
      "premium": false,
      "contentVersion": 1,
      "reviewStatus": "PLACEHOLDER"
    }
  ]
}
''');
    final result = validator.validate(manifest);
    expect(result.usable, isTrue);
    expect(result.playable.map((activity) => activity.id), ['maze_1']);
  });

  test('malformed json is rejected', () {
    expect(() => loader.parse('[]'), throwsA(isA<ContentPackParseException>()));
  });
}
