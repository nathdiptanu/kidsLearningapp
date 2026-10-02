import 'package:flutter/material.dart';

import '../sprout_tokens.dart';

/// Lock marker for a parent-gated flow. It does not show a price.
class PremiumLockBadge extends StatelessWidget {
  const PremiumLockBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Premium',
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: SproutColors.surface,
          borderRadius: BorderRadius.all(Radius.circular(SproutRadius.pill)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: SproutSpace.sm,
            vertical: SproutSpace.xs,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.lock_rounded,
                color: SproutColors.lock,
                size: SproutSize.parentIcon,
              ),
              const SizedBox(width: SproutSpace.xs),
              Text(
                'Premium',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: SproutColors.lock,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
