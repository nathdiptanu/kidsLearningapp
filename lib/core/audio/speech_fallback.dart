/// Optional spoken explanations. Phonics and letter sounds never use this.
class SpeechAvailability {
  const SpeechAvailability({
    required this.english,
    required this.hindi,
    this.note,
  });

  final bool english;
  final bool hindi;
  final String? note;

  bool forLanguage(String languageCode) {
    return languageCode == 'hi' ? hindi : english;
  }
}

abstract class SpeechFallback {
  Future<SpeechAvailability> detect();

  /// Explanatory sentences only. Returns false when no voice is present.
  Future<bool> speakExplanation(String text, {String languageCode = 'en'});

  Future<void> stop();
}

/// Default: no runtime TTS dependency. The activity stays readable.
class UnavailableSpeechFallback implements SpeechFallback {
  const UnavailableSpeechFallback();

  @override
  Future<SpeechAvailability> detect() async {
    return const SpeechAvailability(
      english: false,
      hindi: false,
      note: 'No device voice is used. Text and pictures stay on the screen.',
    );
  }

  @override
  Future<bool> speakExplanation(
    String text, {
    String languageCode = 'en',
  }) async {
    return false;
  }

  @override
  Future<void> stop() async {}
}
