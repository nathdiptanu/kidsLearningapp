import 'package:flutter/material.dart';

import '../sprout_tokens.dart';

class RewardChip extends StatelessWidget {
  const RewardChip({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: SproutColors.surface,
          borderRadius: BorderRadius.all(Radius.circular(SproutRadius.pill)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: SproutSpace.md,
            vertical: SproutSpace.sm,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.star_rounded,
                color: SproutColors.accent,
                size: SproutSize.childIcon,
              ),
              const SizedBox(width: SproutSpace.xs),
              Text(label, style: Theme.of(context).textTheme.bodyLarge),
            ],
          ),
        ),
      ),
    );
  }
}
