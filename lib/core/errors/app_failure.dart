/// Failures shown to a parent or child. [userMessage] must stay non-technical.
sealed class AppFailure implements Exception {
  const AppFailure();

  String get userMessage;
}

final class DatabaseFailure extends AppFailure {
  const DatabaseFailure();

  @override
  String get userMessage =>
      'SproutLab could not open saved progress. Please close the app and open it again. Progress was not deleted.';
}

final class ContentFailure extends AppFailure {
  const ContentFailure();

  @override
  String get userMessage =>
      'SproutLab could not read its learning pack. Please reinstall the app. Saved progress was not deleted.';
}

final class BillingUnavailableFailure extends AppFailure {
  const BillingUnavailableFailure();

  @override
  String get userMessage =>
      'Purchases are temporarily unavailable. Please try again later.';
}

final class AudioUnavailableFailure extends AppFailure {
  const AudioUnavailableFailure();

  @override
  String get userMessage =>
      'Sound is unavailable right now. You can keep playing.';
}

final class ProfileAlreadyExistsFailure extends AppFailure {
  const ProfileAlreadyExistsFailure();

  @override
  String get userMessage => 'This device already has a child profile.';
}

final class InvalidProfileInputFailure extends AppFailure {
  const InvalidProfileInputFailure();

  @override
  String get userMessage => 'That profile choice could not be saved.';
}
