import 'dart:math' as math;

import 'package:flutter/material.dart';

/// WCAG relative-luminance contrast. 1 is no contrast.
double contrastRatio(Color foreground, Color background) {
  final lighter = math.max(
    foreground.computeLuminance(),
    background.computeLuminance(),
  );
  final darker = math.min(
    foreground.computeLuminance(),
    background.computeLuminance(),
  );
  return (lighter + 0.05) / (darker + 0.05);
}

class ContrastPair {
  const ContrastPair({
    required this.name,
    required this.foreground,
    required this.background,
    required this.minimum,
  });

  final String name;
  final Color foreground;
  final Color background;
  final double minimum;
}
