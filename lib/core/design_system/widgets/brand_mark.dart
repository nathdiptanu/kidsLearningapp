import 'package:flutter/material.dart';

import '../../../app/app_identity.dart';
import '../sprout_tokens.dart';

class BrandMark extends StatelessWidget {
  const BrandMark({this.size = 128, super.key});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      image: true,
      label: '${AppIdentity.visibleName} fox reading a book with a sprout',
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(SproutRadius.card)),
        child: Image.asset(
          AppIdentity.brandImage,
          width: size,
          height: size,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.medium,
          excludeFromSemantics: true,
          errorBuilder: (context, error, stackTrace) =>
              SizedBox.square(dimension: size),
        ),
      ),
    );
  }
}
