import 'package:flutter/material.dart';

import '../sprout_tokens.dart';

const _cardShadow = [
  BoxShadow(color: Color(0x0F172033), blurRadius: 18, offset: Offset(0, 6)),
];

/// White rounded card. [accent] tints the edge for emphasis.
class SproutCard extends StatelessWidget {
  const SproutCard({
    required this.child,
    this.accent,
    this.color = SproutColors.surface,
    this.padding = const EdgeInsets.all(SproutSpace.md + 4),
    super.key,
  });

  final Widget child;
  final Color? accent;
  final Color color;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    const radius = BorderRadius.all(Radius.circular(SproutRadius.card));
    return DecoratedBox(
      decoration: const BoxDecoration(
        borderRadius: radius,
        boxShadow: _cardShadow,
      ),
      child: Material(
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: radius,
          side: BorderSide(
            color: accent ?? SproutColors.cardEdge,
            width: accent == null ? 1 : 2,
          ),
        ),
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}

/// [SproutCard] that is one large tap target.
class TappableCard extends StatelessWidget {
  const TappableCard({
    required this.child,
    required this.onTap,
    this.color = SproutColors.surface,
    this.borderColor,
    this.padding = const EdgeInsets.all(SproutSpace.md),
    super.key,
  });

  final Widget child;
  final VoidCallback? onTap;
  final Color color;
  final Color? borderColor;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    const radius = BorderRadius.all(Radius.circular(SproutRadius.card));
    return DecoratedBox(
      decoration: const BoxDecoration(
        borderRadius: radius,
        boxShadow: _cardShadow,
      ),
      child: Material(
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: radius,
          side: BorderSide(
            color: borderColor ?? SproutColors.cardEdge,
            width: borderColor == null ? 1 : 2,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: SproutSize.childTarget,
            ),
            child: Padding(padding: padding, child: child),
          ),
        ),
      ),
    );
  }
}
