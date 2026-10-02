import 'package:flutter/foundation.dart';

/// Debug-only notes that stay on the development machine.
///
/// Release and profile builds do not print these. Messages that look like a
/// nickname, purchase token, or verification payload are dropped.
abstract final class LocalLog {
  static const maxLength = 240;

  static void debug(String message) {
    if (!kDebugMode) {
      return;
    }
    final lower = message.toLowerCase();
    if (lower.contains('nickname') ||
        lower.contains('purchasetoken') ||
        lower.contains('purchase token') ||
        lower.contains('serververification') ||
        lower.contains('verificationdata')) {
      debugPrint('Diagnostic omitted.');
      return;
    }
    debugPrint(
      message.length > maxLength ? message.substring(0, maxLength) : message,
    );
  }
}
