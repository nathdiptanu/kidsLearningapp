import 'package:flutter/material.dart';

import '../feedback_copy.dart';
import '../sprout_tokens.dart';

enum FeedbackKind { correct, retry, hint }

class FeedbackOverlay extends StatelessWidget {
  const FeedbackOverlay({required this.kind, super.key});

  final FeedbackKind kind;

  @override
  Widget build(BuildContext context) {
    final message = switch (kind) {
      FeedbackKind.correct => FeedbackCopy.correct.first,
      FeedbackKind.retry => FeedbackCopy.retry.first,
      FeedbackKind.hint => FeedbackCopy.hint,
    };
    final icon = switch (kind) {
      FeedbackKind.correct => Icons.star_rounded,
      FeedbackKind.retry => Icons.refresh_rounded,
      FeedbackKind.hint => Icons.lightbulb_outline_rounded,
    };
    final color = switch (kind) {
      FeedbackKind.correct => SproutColors.success,
      FeedbackKind.retry => SproutColors.retry,
      FeedbackKind.hint => SproutColors.accent,
    };
    return Semantics(
      liveRegion: true,
      label: message,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: SproutColors.surface,
          borderRadius: BorderRadius.all(Radius.circular(SproutRadius.card)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(SproutSpace.md),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: SproutSize.childIcon),
              const SizedBox(width: SproutSpace.sm),
              Text(message, style: Theme.of(context).textTheme.bodyLarge),
            ],
          ),
        ),
      ),
    );
  }
}
