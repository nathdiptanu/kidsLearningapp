import 'package:flutter/material.dart';

import '../sprout_tokens.dart';

/// Round arrow that marks a whole card as tappable.
class ChevronBadge extends StatelessWidget {
  const ChevronBadge({this.size = 40, this.icon = Icons.chevron_right, super.key});

  final double size;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          color: SproutColors.primary,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: SproutColors.surface, size: size * 0.7),
      ),
    );
  }
}
