import '../models/age_band.dart';
import '../regional/learning_preferences.dart';

class LocalSettings {
  static const defaultReminderMinutes = 16 * 60;
  const LocalSettings({
    required this.soundEffectsEnabled,
    required this.musicEnabled,
    required this.narrationEnabled,
    required this.onboardingComplete,
    required this.onboardingStep,
    required this.draftAgeBand,
    required this.draftAvatarId,
    required this.draftNickname,
    this.remindersEnabled = false,
    this.reminderMinutes = defaultReminderMinutes,
    this.reducedMotion = false,
    this.sessionLimitMinutes = 0,
    this.learningRegion,
    this.interfaceLanguage = InterfaceLanguage.english,
    this.teachingLanguage = TeachingLanguage.english,
    this.hindiEnabled = true,
    this.discoverIndiaEnabled = true,
  });

  static const defaults = LocalSettings(
    soundEffectsEnabled: true,
    musicEnabled: false,
    narrationEnabled: true,
    onboardingComplete: false,
    onboardingStep: 0,
    draftAgeBand: null,
    draftAvatarId: null,
    draftNickname: null,
  );

  final bool soundEffectsEnabled;
  final bool musicEnabled;
  final bool narrationEnabled;
  final bool onboardingComplete;
  final int onboardingStep;
  final AgeBand? draftAgeBand;
  final String? draftAvatarId;
  final String? draftNickname;
  final bool remindersEnabled;
  final int reminderMinutes;
  final bool reducedMotion;
  final int sessionLimitMinutes;

  /// Null until a grown-up chooses. Null shows the global activities only.
  final LearningRegion? learningRegion;
  final InterfaceLanguage interfaceLanguage;
  final TeachingLanguage teachingLanguage;

  /// Grown-up switches. They only apply when [learningRegion] is India.
  final bool hindiEnabled;
  final bool discoverIndiaEnabled;

  LocalSettings copyWith({
    bool? soundEffectsEnabled,
    bool? musicEnabled,
    bool? narrationEnabled,
    bool? onboardingComplete,
    int? onboardingStep,
    AgeBand? draftAgeBand,
    String? draftAvatarId,
    String? draftNickname,
    bool? remindersEnabled,
    int? reminderMinutes,
    bool? reducedMotion,
    int? sessionLimitMinutes,
    LearningRegion? learningRegion,
    InterfaceLanguage? interfaceLanguage,
    TeachingLanguage? teachingLanguage,
    bool? hindiEnabled,
    bool? discoverIndiaEnabled,
    bool clearDraftAgeBand = false,
    bool clearDraftAvatar = false,
    bool clearDraftNickname = false,
  }) {
    return LocalSettings(
      soundEffectsEnabled: soundEffectsEnabled ?? this.soundEffectsEnabled,
      musicEnabled: musicEnabled ?? this.musicEnabled,
      narrationEnabled: narrationEnabled ?? this.narrationEnabled,
      onboardingComplete: onboardingComplete ?? this.onboardingComplete,
      onboardingStep: onboardingStep ?? this.onboardingStep,
      draftAgeBand: clearDraftAgeBand
          ? null
          : (draftAgeBand ?? this.draftAgeBand),
      draftAvatarId: clearDraftAvatar
          ? null
          : (draftAvatarId ?? this.draftAvatarId),
      draftNickname: clearDraftNickname
          ? null
          : (draftNickname ?? this.draftNickname),
      remindersEnabled: remindersEnabled ?? this.remindersEnabled,
      reminderMinutes: reminderMinutes ?? this.reminderMinutes,
      reducedMotion: reducedMotion ?? this.reducedMotion,
      sessionLimitMinutes: sessionLimitMinutes ?? this.sessionLimitMinutes,
      learningRegion: learningRegion ?? this.learningRegion,
      interfaceLanguage: interfaceLanguage ?? this.interfaceLanguage,
      teachingLanguage: teachingLanguage ?? this.teachingLanguage,
      hindiEnabled: hindiEnabled ?? this.hindiEnabled,
      discoverIndiaEnabled: discoverIndiaEnabled ?? this.discoverIndiaEnabled,
    );
  }
}
