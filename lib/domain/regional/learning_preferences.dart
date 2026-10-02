/// Learning region chosen by a grown-up. It only decides which activities are
/// shown. It is never inferred from location, IP address or SIM, and it says
/// nothing about nationality, religion, home language or ability.
enum LearningRegion {
  india('IN', 'India'),
  other('ZZ', 'Another country or region');

  const LearningRegion(this.storageKey, this.label);

  /// ISO 3166-1 alpha-2 code. `ZZ` is the CLDR code for an unknown region.
  final String storageKey;
  final String label;

  static LearningRegion? fromStorage(String? key) {
    for (final region in LearningRegion.values) {
      if (region.storageKey == key) {
        return region;
      }
    }
    return null;
  }
}

/// Language of buttons and instructions.
enum InterfaceLanguage {
  english('en', 'English', available: true),
  hindi('hi', 'Hindi · हिंदी', available: false);

  const InterfaceLanguage(
    this.storageKey,
    this.label, {
    required this.available,
  });

  final String storageKey;
  final String label;

  /// Hindi needs every screen translated and reviewed first.
  final bool available;

  static InterfaceLanguage fromStorage(String? key) {
    for (final language in InterfaceLanguage.values) {
      if (language.storageKey == key && language.available) {
        return language;
      }
    }
    return InterfaceLanguage.english;
  }
}

/// Language used for teaching inside lessons. Independent of region.
enum TeachingLanguage {
  english('en', 'English'),
  hindi('hi', 'Hindi · हिंदी'),
  bilingual('en_hi', 'English and Hindi');

  const TeachingLanguage(this.storageKey, this.label);

  final String storageKey;
  final String label;

  bool get includesHindi => this != TeachingLanguage.english;

  static TeachingLanguage fromStorage(String? key) {
    for (final language in TeachingLanguage.values) {
      if (language.storageKey == key) {
        return language;
      }
    }
    return TeachingLanguage.english;
  }
}
