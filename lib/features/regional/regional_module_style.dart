import 'package:flutter/material.dart';

import '../../core/design_system/sprout_tokens.dart';
import '../../domain/regional/regional_availability.dart';

/// One step of a regional learning journey.
class RegionalJourneyStep {
  const RegionalJourneyStep(this.title, this.detail, this.icon);

  final String title;
  final String detail;
  final IconData icon;
}

/// Card and screen presentation for a regional module.
extension RegionalModuleStyle on RegionalModule {
  String get title => switch (this) {
    RegionalModule.hindi => 'Hindi',
    RegionalModule.discoverIndia => 'Discover India',
  };

  String get subtitle => switch (this) {
    RegionalModule.hindi => 'Letters and words',
    RegionalModule.discoverIndia => 'Places and heritage',
  };

  String get art => switch (this) {
    RegionalModule.hindi => SproutArt.hindi,
    RegionalModule.discoverIndia => SproutArt.discoverIndia,
  };

  Color get tint => switch (this) {
    RegionalModule.hindi => SproutColors.hindiSurface,
    RegionalModule.discoverIndia => SproutColors.indiaSurface,
  };

  Color get mark => switch (this) {
    RegionalModule.hindi => SproutColors.hindi,
    RegionalModule.discoverIndia => SproutColors.india,
  };

  /// Real Devanagari drawn by the bundled font over the picture.
  String? get scriptSample => switch (this) {
    RegionalModule.hindi => 'अ आ',
    RegionalModule.discoverIndia => null,
  };

  /// Grown-up explanation of what must happen before lessons appear.
  String get reviewNote => switch (this) {
    RegionalModule.hindi => 'Lessons appear here after a Hindi teacher has checked the letters, words, pictures and recordings.',
    RegionalModule.discoverIndia => 'Lessons appear here after maps, places, heritage drawings and facts have been checked against official sources.',
  };

  List<RegionalJourneyStep> get journey => switch (this) {
    RegionalModule.hindi => const [
      RegionalJourneyStep(
        'Listen',
        'Hear a letter or word',
        Icons.hearing_rounded,
      ),
      RegionalJourneyStep(
        'Find',
        'Spot the one you heard',
        Icons.search_rounded,
      ),
      RegionalJourneyStep(
        'Match',
        'Pair letters and pictures',
        Icons.join_inner_rounded,
      ),
      RegionalJourneyStep(
        'Trace',
        'Follow the dots with a finger',
        Icons.gesture_rounded,
      ),
      RegionalJourneyStep(
        'Build a word',
        'Put the pieces together',
        Icons.extension_rounded,
      ),
      RegionalJourneyStep(
        'Review',
        'Visit old friends again',
        Icons.replay_rounded,
      ),
    ],
    RegionalModule.discoverIndia => const [
      RegionalJourneyStep(
        'My India',
        'Pictures of familiar places',
        Icons.favorite_rounded,
      ),
      RegionalJourneyStep(
        'States and places',
        'Where places are on the map',
        Icons.place_rounded,
      ),
      RegionalJourneyStep(
        'Capitals',
        'For older learners, step by step',
        Icons.location_city_rounded,
      ),
      RegionalJourneyStep(
        'Heritage',
        'Buildings, crafts and stories',
        Icons.museum_rounded,
      ),
    ],
  };
}
