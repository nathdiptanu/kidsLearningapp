import 'package:flutter/widgets.dart';

abstract final class SproutColors {
  /// Main action. White labels are checked against this fill.
  static const Color primary = Color(0xFF5B3FCB);
  static const Color primaryPressed = Color(0xFF3C278F);
  static const Color seed = primary;
  static const Color primarySoft = Color(0xFFEEE9FF);
  static const Color background = Color(0xFFF7F8FC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color ink = Color(0xFF172033);
  static const Color inkMuted = Color(0xFF475569);
  static const Color accent = Color(0xFF7A4B00);
  static const Color success = Color(0xFF146C43);
  static const Color successSoft = Color(0xFFE3F5EA);
  static const Color retry = Color(0xFF8A4300);
  static const Color parentSurface = Color(0xFFF7F8FC);
  static const Color lock = Color(0xFF334155);
  static const Color line = Color(0xFF5C6B82);

  /// Card edge only. Cards are also marked by their shadow, text and a
  /// primary chevron, so this soft edge is decoration.
  static const Color cardEdge = Color(0xFFE3E7F0);
  static const Color disabledFill = Color(0xFFE2E8F0);
  static const Color disabledInk = Color(0xFF334155);

  /// Dark marks for icons. Pale tints are surfaces only, with [ink] labels.
  static const Color maths = Color(0xFF0B4A73);
  static const Color mathsSurface = Color(0xFFE5F3FF);
  static const Color english = Color(0xFF7A4E00);
  static const Color englishSurface = Color(0xFFFFF0D9);
  static const Color logic = Color(0xFF3D2A8A);
  static const Color logicSurface = Color(0xFFEEE9FF);
  static const Color observation = Color(0xFF0F5C45);
  static const Color observationSurface = Color(0xFFE0F4EE);
  static const Color knowledge = Color(0xFF8A2340);
  static const Color knowledgeSurface = Color(0xFFFFE8EE);
  static const Color maze = Color(0xFF1F6B4A);
  static const Color mazeSurface = Color(0xFFE3F6E8);
  static const Color difference = Color(0xFF8A3A2A);
  static const Color ticTacToeSurface = Color(0xFFF1EDFF);
}

abstract final class SproutSpace {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double page = 20;
  static const double lg = 24;
  static const double xl = 32;
}

abstract final class SproutRadius {
  static const double card = 24;
  static const double tile = 20;
  static const double button = 28;
  static const double pill = 999;
}

abstract final class SproutSize {
  static const double childTarget = 64;
  static const double parentTarget = 48;
  static const double childIcon = 28;
  static const double parentIcon = 22;
  static const double pageMaxWidth = 720;
}

abstract final class SproutType {
  static const String family = 'Nunito';
  static const double childTitle = 30;
  static const double childBody = 18;
  static const double childLabel = 16;
  static const double childSection = 22;
  static const double parentTitle = 24;
  static const double parentBody = 16;
}

/// Bundled illustrations. See docs/asset_licenses.md.
abstract final class SproutArt {
  static const String fox = 'assets/art/fox_wave.png';
  static const String maths = 'assets/art/category_maths.jpg';
  static const String english = 'assets/art/category_english.jpg';
  static const String logic = 'assets/art/category_logic.jpg';
  static const String observation = 'assets/art/category_observation.jpg';
  static const String knowledge = 'assets/art/category_knowledge.jpg';
  static const String ticTacToe = 'assets/art/category_tictactoe.jpg';
  static const String maze = 'assets/art/category_maze.jpg';
}

abstract final class SproutMotion {
  static const Duration tap = Duration(milliseconds: 150);
  static const Duration small = Duration(milliseconds: 250);
  static const Duration success = Duration(milliseconds: 1500);

  static Duration resolve(BuildContext context, Duration duration) {
    if (MediaQuery.disableAnimationsOf(context)) {
      return Duration.zero;
    }
    return duration;
  }
}
