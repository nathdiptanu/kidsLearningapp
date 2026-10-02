import '../../models/age_band.dart';
import '../find_difference/difference_catalog.dart';
import '../matching/matching_generator.dart';
import '../play/play_question.dart';
import '../vocabulary/vocabulary_generator.dart';

class AuthoredContentValidator {
  const AuthoredContentValidator();

  List<String> validate() {
    return [..._matching(), ..._vocabulary(), ..._differences()];
  }

  List<String> _matching() {
    final issues = <String>[];
    final ids = <String>{};
    for (final template in oddTemplates) {
      if (template.id.trim().isEmpty || !ids.add(template.id)) {
        issues.add('matching duplicate id ${template.id}');
      }
      if (template.bands.isEmpty) {
        issues.add('${template.id} missing age band');
      }
      if (template.explanation.trim().isEmpty) {
        issues.add('${template.id} missing explanation');
      }
      if (template.itemIds.toSet().length != template.itemIds.length) {
        issues.add('${template.id} repeats an item');
      }
      for (final itemId in template.itemIds) {
        final known = pictureCatalog.any((item) => item.id == itemId);
        if (!known) {
          issues.add('${template.id} missing asset ${itemId.name}');
        }
      }
      if (!template.isUnambiguous) {
        issues.add('${template.id} does not have one partner group');
      }
      final items = template.itemIds.map(pictureById).toList();
      final odd = items[template.oddIndex];
      final partners = [
        for (var index = 0; index < items.length; index++)
          if (index != template.oddIndex) items[index],
      ];
      final sameAsOdd = partners.where((item) => item.kind == odd.kind).length;
      if (sameAsOdd != 0 || partners.length < 2) {
        issues.add('${template.id} partner count');
      }
    }
    return issues;
  }

  List<String> _vocabulary() {
    final issues = <String>[];
    final ids = <String>{};
    final labels = <String>{};
    for (final word in vocabWords) {
      if (!ids.add(word.id)) {
        issues.add('vocabulary duplicate id ${word.id}');
      }
      if (!labels.add(word.label)) {
        issues.add('vocabulary duplicate label ${word.label}');
      }
      if (word.label.toLowerCase().contains('color')) {
        issues.add('${word.id} uses color spelling');
      }
      if (word.label.isEmpty || word.label[0] != word.firstLetter) {
        issues.add('${word.id} first letter does not match');
      }
      if (word.id.contains(' ')) {
        issues.add('${word.id} is not locale-neutral');
      }
    }
    const generator = VocabularyGenerator();
    for (final band in AgeBand.values) {
      for (var variant = 0; variant < 6; variant++) {
        final questions = generator.generate(
          band: band,
          seed: 11 + variant,
          variant: variant,
        );
        for (final question in questions) {
          if (!question.isValid) {
            issues.add('vocabulary invalid ${question.explanation}');
          }
          if (question.explanation.startsWith('first-letter') &&
              band == AgeBand.a) {
            issues.add('first letter used for ages 3-4');
          }
          final wordId = _wordId(question.explanation);
          if (wordId != null && !ids.contains(wordId)) {
            issues.add('vocabulary invented $wordId');
          }
        }
      }
    }
    return issues;
  }

  String? _wordId(String explanation) {
    if (explanation.startsWith('picture-to-word ') ||
        explanation.startsWith('word-to-picture ')) {
      return explanation.split(' ').last;
    }
    if (explanation.startsWith('first-letter ')) {
      final body = explanation.substring('first-letter '.length);
      return body.split('=').first;
    }
    return null;
  }

  List<String> _differences() {
    final issues = <String>[];
    if (differenceScenes.length < 5) {
      issues.add('fewer than five difference scenes');
    }
    final ids = <String>{};
    const catalog = DifferenceCatalog();
    for (final scene in differenceScenes) {
      if (!ids.add(scene.id)) {
        issues.add('difference duplicate ${scene.id}');
      }
      if (scene.spots.length < 5) {
        issues.add('${scene.id} has fewer than five differences');
      }
      final spotIds = scene.spots.map((spot) => spot.id).toSet();
      if (spotIds.length != scene.spots.length) {
        issues.add('${scene.id} repeats a difference');
      }
      for (final spot in scene.spots) {
        final region = spot.region;
        final inside =
            region.left >= 0 &&
            region.top >= 0 &&
            region.right <= 1 &&
            region.bottom <= 1 &&
            region.width > 0 &&
            region.height > 0;
        if (!inside) {
          issues.add('${scene.id} ${spot.id} region is outside the image');
        }
      }
      if (!catalog.regionsStaySeparate(scene.spots, 0)) {
        issues.add('${scene.id} overlapping regions need review');
      }
      for (final band in AgeBand.values) {
        final active = scene.spots.take(catalog.countFor(band)).toList();
        if (!catalog.regionsStaySeparate(active, catalog.padFor(band))) {
          issues.add('${scene.id} ${band.storageKey} padded regions overlap');
        }
      }
    }
    if (DifferenceCatalog.masterWidth != 1600 ||
        DifferenceCatalog.masterHeight != 1200) {
      issues.add('difference master canvas is not 1600x1200');
    }
    return issues;
  }
}
