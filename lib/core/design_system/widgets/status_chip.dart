import 'package:flutter/material.dart';

import '../sprout_tokens.dart';

enum StatusTone { ready, inProgress, done, locked, info }

class StatusChip extends StatelessWidget {
  const StatusChip({
    required this.label,
    this.tone = StatusTone.info,
    this.icon,
    super.key,
  });

  final String label;
  final StatusTone tone;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final (fill, ink, fallbackIcon) = switch (tone) {
      StatusTone.ready => (
        SproutColors.primarySoft,
        SproutColors.primary,
        Icons.play_arrow_rounded,
      ),
      StatusTone.inProgress => (
        SproutColors.englishSurface,
        SproutColors.accent,
        Icons.timelapse,
      ),
      StatusTone.done => (
        SproutColors.successSoft,
        SproutColors.success,
        Icons.check_circle,
      ),
      StatusTone.locked => (
        SproutColors.disabledFill,
        SproutColors.lock,
        Icons.lock,
      ),
      StatusTone.info => (
        SproutColors.surface,
        SproutColors.ink,
        null,
      ),
    };
    final shownIcon = icon ?? fallbackIcon;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: fill,
        borderRadius: const BorderRadius.all(Radius.circular(SproutRadius.pill)),
        border: tone == StatusTone.info
            ? Border.all(color: SproutColors.line)
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: SproutSpace.xs + 2,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (shownIcon != null) ...[
              ExcludeSemantics(child: Icon(shownIcon, size: 18, color: ink)),
              const SizedBox(width: SproutSpace.xs),
            ],
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  fontFamily: SproutType.family,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: ink,
                  height: 1.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
