import 'package:flutter/material.dart';

import '../sprout_theme.dart';
import '../sprout_tokens.dart';

class ParentCard extends StatelessWidget {
  const ParentCard({required this.title, required this.body, super.key});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: SproutTheme.parent(),
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: SproutColors.surface,
          borderRadius: BorderRadius.all(Radius.circular(SproutRadius.card)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(SproutSpace.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: SproutTheme.parent().textTheme.headlineMedium),
              const SizedBox(height: SproutSpace.sm),
              Text(body, style: SproutTheme.parent().textTheme.bodyLarge),
            ],
          ),
        ),
      ),
    );
  }
}
