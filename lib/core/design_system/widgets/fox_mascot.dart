import 'package:flutter/material.dart';

import '../sprout_tokens.dart';

/// Decorative fox. Kept out of the accessibility tree; nearby text carries
/// the meaning.
class FoxMascot extends StatelessWidget {
  const FoxMascot({this.size = 120, super.key});

  final double size;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: Image.asset(
        SproutArt.fox,
        width: size,
        height: size,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.medium,
        excludeFromSemantics: true,
        errorBuilder: (context, error, stackTrace) =>
            SizedBox.square(dimension: size),
      ),
    );
  }
}

/// Rounded pastel tile holding one category illustration.
class ArtTile extends StatelessWidget {
  const ArtTile({
    required this.art,
    required this.tint,
    this.width,
    this.height,
    this.radius = SproutRadius.tile,
    this.dimmed = false,
    super.key,
  });

  final String art;
  final Color tint;
  final double? width;
  final double? height;
  final double radius;
  final bool dimmed;

  @override
  Widget build(BuildContext context) {
    final image = Image.asset(
      art,
      width: width,
      height: height,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.medium,
      excludeFromSemantics: true,
      cacheWidth: 640,
      errorBuilder: (context, error, stackTrace) =>
          SizedBox(width: width, height: height),
    );
    return ExcludeSemantics(
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(radius)),
        child: ColoredBox(
          color: tint,
          child: dimmed
              ? Opacity(opacity: 0.45, child: image)
              : image,
        ),
      ),
    );
  }
}
