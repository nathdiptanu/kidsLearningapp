/// How long a Play-confirmed grant may be used when Play did not send an
/// expiry time.
///
/// Section 43 requires a deliberate offline bound. The Play Billing client
/// does not include subscription expiry, so a cached active flag with no
/// expiry must not last forever. A later verification service can store a
/// real expiry, and that expiry is then the bound instead of this window.
abstract final class OfflineEntitlementPolicy {
  static const window = Duration(days: 7);
}
