import 'package:flutter/material.dart';

import '../sprout_tokens.dart';

class SkillCard extends StatelessWidget {
  const SkillCard({required this.title, required this.detail, super.key});

  final String title;
  final String detail;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: SproutColors.surface,
        borderRadius: BorderRadius.all(Radius.circular(SproutRadius.card)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(SproutSpace.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: SproutSpace.xs),
            Text(detail, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
