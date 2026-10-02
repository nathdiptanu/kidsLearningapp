import 'package:flutter/material.dart';

import '../sprout_tokens.dart';
import 'chevron_badge.dart';
import 'fox_mascot.dart';
import 'sprout_card.dart';

/// Explore tile: illustration, title, short subtitle and an arrow. The whole
/// card is one button.
class CategoryCard extends StatelessWidget {
  const CategoryCard({
    required this.title,
    required this.subtitle,
    required this.art,
    required this.tint,
    required this.onTap,
    this.footnote,
    this.wide = false,
    super.key,
  });

  final String title;
  final String subtitle;
  final String art;
  final Color tint;
  final VoidCallback onTap;
  final String? footnote;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final label = [title, subtitle, ?footnote].join('. ');
    final words = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(title, style: text.titleMedium?.copyWith(fontSize: 20)),
        const SizedBox(height: 2),
        Text(subtitle, style: text.bodyMedium),
        if (footnote != null) ...[
          const SizedBox(height: SproutSpace.xs),
          Text(
            footnote!,
            style: text.bodySmall?.copyWith(
              color: SproutColors.ink,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ],
    );
    return Semantics(
      button: true,
      label: label,
      onTap: onTap,
      excludeSemantics: true,
      child: TappableCard(
        onTap: onTap,
        padding: const EdgeInsets.all(12),
        child: wide
            ? Row(
                children: [
                  SizedBox(
                    width: 120,
                    child: AspectRatio(
                      aspectRatio: 4 / 3,
                      child: ArtTile(art: art, tint: tint, radius: 16),
                    ),
                  ),
                  const SizedBox(width: SproutSpace.md),
                  Expanded(child: words),
                  const SizedBox(width: SproutSpace.sm),
                  const ChevronBadge(),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 10,
                    child: ArtTile(art: art, tint: tint, radius: 16),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(child: words),
                      const SizedBox(width: SproutSpace.sm),
                      const ChevronBadge(size: 36),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}
