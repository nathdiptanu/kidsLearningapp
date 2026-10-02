import 'package:flutter/material.dart';

import '../sprout_tokens.dart';
import 'chevron_badge.dart';
import 'fox_mascot.dart';
import 'sprout_card.dart';

enum StepMark { done, current, upcoming }

/// One activity row: optional step number, thumbnail, title, detail, status
/// and an arrow. The whole card is one button.
class ActivityCard extends StatelessWidget {
  const ActivityCard({
    required this.title,
    required this.art,
    required this.tint,
    required this.onTap,
    required this.semanticsLabel,
    this.subtitle,
    this.status,
    this.step,
    this.stepMark = StepMark.upcoming,
    this.highlighted = false,
    this.dimmed = false,
    super.key,
  });

  final String title;
  final String? subtitle;
  final String art;
  final Color tint;
  final Widget? status;
  final int? step;
  final StepMark stepMark;
  final bool highlighted;
  final bool dimmed;
  final VoidCallback onTap;
  final String semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Semantics(
      button: true,
      label: semanticsLabel,
      onTap: onTap,
      excludeSemantics: true,
      child: TappableCard(
        onTap: onTap,
        borderColor: highlighted ? SproutColors.primary : null,
        padding: const EdgeInsets.all(12),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final roomy = constraints.maxWidth >= 300;
            return Row(
              children: [
                if (step != null) ...[
                  StepCircle(step: step!, mark: stepMark, size: 36),
                  const SizedBox(width: 12),
                ],
                if (roomy) ...[
                  ArtTile(
                    art: art,
                    tint: tint,
                    width: 76,
                    height: 58,
                    radius: 14,
                    dimmed: dimmed,
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(title, style: text.titleMedium),
                      if (subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(subtitle!, style: text.bodyMedium),
                      ],
                      if (status != null) ...[
                        const SizedBox(height: SproutSpace.xs + 2),
                        status!,
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: SproutSpace.sm),
                const ChevronBadge(size: 36),
              ],
            );
          },
        ),
      ),
    );
  }
}

class StepCircle extends StatelessWidget {
  const StepCircle({
    required this.step,
    required this.mark,
    this.size = 40,
    super.key,
  });

  final int step;
  final StepMark mark;
  final double size;

  @override
  Widget build(BuildContext context) {
    final filled = mark != StepMark.upcoming;
    return ExcludeSemantics(
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: filled ? SproutColors.primary : SproutColors.surface,
          shape: BoxShape.circle,
          border: Border.all(
            color: filled ? SproutColors.primary : SproutColors.line,
            width: 2,
          ),
          boxShadow: mark == StepMark.current
              ? const [
                  BoxShadow(
                    color: SproutColors.primarySoft,
                    spreadRadius: 4,
                  ),
                ]
              : null,
        ),
        child: mark == StepMark.done
            ? Icon(Icons.check_rounded, color: SproutColors.surface, size: size * 0.6)
            : Text(
                '$step',
                style: TextStyle(
                  fontFamily: SproutType.family,
                  fontSize: size * 0.45,
                  fontWeight: FontWeight.w900,
                  color: filled ? SproutColors.surface : SproutColors.ink,
                ),
              ),
      ),
    );
  }
}

/// Connected step circles for today's five activities.
class JourneyProgress extends StatelessWidget {
  const JourneyProgress({required this.marks, super.key});

  final List<StepMark> marks;

  @override
  Widget build(BuildContext context) {
    final words = [
      for (var index = 0; index < marks.length; index++)
        'Step ${index + 1} ${switch (marks[index]) {
          StepMark.done => 'finished',
          StepMark.current => 'is next',
          StepMark.upcoming => 'later',
        }}',
    ].join(', ');
    return Semantics(
      label: words,
      excludeSemantics: true,
      child: Row(
        children: [
          for (var index = 0; index < marks.length; index++) ...[
            StepCircle(step: index + 1, mark: marks[index]),
            if (index < marks.length - 1)
              Expanded(
                child: Container(
                  height: 4,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: marks[index] == StepMark.done
                        ? SproutColors.primary
                        : SproutColors.primarySoft,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(SproutRadius.pill),
                    ),
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }
}
