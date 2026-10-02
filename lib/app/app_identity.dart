/// Central product identity. Game and domain code must not hard-code the
/// visible name, and this name is not a database or entitlement key.
abstract final class AppIdentity {
  static const engineeringCodename = 'SproutLab';

  /// Temporary visible name until brand clearance.
  static const visibleName = 'SproutLab';

  /// Not approved for Google Play upload.
  static const temporaryApplicationId = 'com.sproutlab.kids';

  static const applicationIdApprovedForStore = false;

  static const appVersion = '0.1.2';

  static const learningLocale = 'en-IN';

  /// Approved fox/book/sprout artwork, also used for the launcher icon.
  static const brandImage = 'assets/brand/sproutlab_fox.png';

  static const supportingMessage =
      'Maths • English • Logic • Observation • Knowledge';
}
