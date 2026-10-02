import 'package:flutter/material.dart';

import '../sprout_tokens.dart';

class ChoiceCard extends StatelessWidget {
  const ChoiceCard({
    required this.label,
    required this.selected,
    required this.onPressed,
    this.leading,
    this.highlighted = false,
    this.showText = true,
    super.key,
  });

  final String label;
  final bool selected;
  final VoidCallback? onPressed;
  final Widget? leading;
  final bool highlighted;
  final bool showText;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: highlighted ? '$label. Hint' : label,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: SproutSize.childTarget),
        child: Material(
          color: selected ? SproutColors.primarySoft : SproutColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(SproutRadius.tile),
            ),
            side: BorderSide(
              color: highlighted
                  ? SproutColors.accent
                  : selected
                  ? SproutColors.seed
                  : SproutColors.line,
              width: highlighted || selected ? 3 : 1.5,
            ),
          ),
          child: InkWell(
            onTap: onPressed,
            borderRadius: const BorderRadius.all(
              Radius.circular(SproutRadius.tile),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: SproutSpace.md,
                vertical: 12,
              ),
              child: Row(
                children: [
                  if (leading != null) ...[
                    ExcludeSemantics(child: leading!),
                    const SizedBox(width: SproutSpace.sm),
                  ],
                  Icon(
                    highlighted
                        ? Icons.lightbulb_outline
                        : selected
                        ? Icons.check_circle
                        : Icons.circle_outlined,
                    color: highlighted
                        ? SproutColors.accent
                        : selected
                        ? SproutColors.seed
                        : SproutColors.inkMuted,
                    size: SproutSize.childIcon,
                  ),
                  const SizedBox(width: SproutSpace.sm),
                  Expanded(
                    child: showText
                        ? Text(
                            label,
                            style: Theme.of(context).textTheme.bodyLarge,
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
