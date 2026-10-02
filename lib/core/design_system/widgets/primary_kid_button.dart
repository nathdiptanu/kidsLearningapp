import 'package:flutter/material.dart';

import '../sprout_tokens.dart';

/// Main purple action. [trailingIcon] adds an arrow after the label.
class PrimaryKidButton extends StatelessWidget {
  const PrimaryKidButton({
    required this.label,
    required this.onPressed,
    this.trailingIcon,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? trailingIcon;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        minimumSize: const Size(
          SproutSize.childTarget * 2,
          SproutSize.childTarget - 8,
        ),
        textStyle: const TextStyle(
          fontFamily: SproutType.family,
          fontSize: SproutType.childLabel + 2,
          fontWeight: FontWeight.w800,
        ),
      ),
      child: _ButtonLabel(label: label, icon: trailingIcon),
    );
  }
}

/// White button with a purple edge for the second choice on a screen.
class SecondaryKidButton extends StatelessWidget {
  const SecondaryKidButton({
    required this.label,
    required this.onPressed,
    this.trailingIcon,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? trailingIcon;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(
          SproutSize.childTarget * 2,
          SproutSize.childTarget - 8,
        ),
      ),
      child: _ButtonLabel(label: label, icon: trailingIcon),
    );
  }
}

class _ButtonLabel extends StatelessWidget {
  const _ButtonLabel({required this.label, this.icon});

  final String label;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    if (icon == null) {
      return Text(label, textAlign: TextAlign.center);
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(child: Text(label, textAlign: TextAlign.center)),
        const SizedBox(width: SproutSpace.sm),
        ExcludeSemantics(child: Icon(icon, size: 24)),
      ],
    );
  }
}
