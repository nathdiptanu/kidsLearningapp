import 'package:flutter/material.dart';

import '../features/foundation/root_screen.dart';

abstract final class SproutRouter {
  static const root = '/';

  static Route<void> onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute<void>(
      settings: settings,
      builder: (context) => const RootScreen(),
    );
  }
}
