import 'package:flutter/material.dart';

import '../../../app/app_identity.dart';
import '../sprout_tokens.dart';

/// Wordmark with a drawn sprout. The name is real text.
class SproutWordmark extends StatelessWidget {
  const SproutWordmark({this.size = 26, super.key});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      header: true,
      label: AppIdentity.visibleName,
      child: ExcludeSemantics(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            CustomPaint(
              size: Size.square(size * 0.95),
              painter: const _SproutPainter(),
            ),
            const SizedBox(width: 2),
            Flexible(
              child: Text(
                AppIdentity.visibleName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: SproutType.family,
                  fontSize: size,
                  height: 1.1,
                  fontWeight: FontWeight.w900,
                  color: SproutColors.primary,
                  letterSpacing: -0.3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SproutPainter extends CustomPainter {
  const _SproutPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final stem = Paint()
      ..color = const Color(0xFF2E8B57)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.11
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(w * 0.5, h * 0.95), Offset(w * 0.5, h * 0.45), stem);
    final leaf = Paint()..color = const Color(0xFF3FAE6A);
    final left = Path()
      ..moveTo(w * 0.5, h * 0.55)
      ..quadraticBezierTo(w * 0.02, h * 0.55, w * 0.06, h * 0.12)
      ..quadraticBezierTo(w * 0.46, h * 0.14, w * 0.5, h * 0.55)
      ..close();
    final right = Path()
      ..moveTo(w * 0.5, h * 0.48)
      ..quadraticBezierTo(w * 0.98, h * 0.46, w * 0.94, h * 0.02)
      ..quadraticBezierTo(w * 0.54, h * 0.04, w * 0.5, h * 0.48)
      ..close();
    canvas.drawPath(left, leaf);
    canvas.drawPath(right, leaf..color = const Color(0xFF58C27D));
  }

  @override
  bool shouldRepaint(covariant _SproutPainter oldDelegate) => false;
}

/// White pill that opens the grown-up area. The gate itself is the
/// three-second hold on the next screen.
class ParentEntryButton extends StatelessWidget {
  const ParentEntryButton({required this.onPressed, super.key});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Parents. Opens the grown-up area.',
      onTap: onPressed,
      excludeSemantics: true,
      child: Material(
        color: SproutColors.surface,
        shape: const StadiumBorder(
          side: BorderSide(color: SproutColors.line),
        ),
        child: InkWell(
          onTap: onPressed,
          customBorder: const StadiumBorder(),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: SproutSize.parentTarget,
              minWidth: SproutSize.parentTarget,
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: SproutSpace.md),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.lock_outline_rounded, color: SproutColors.primary, size: 20),
                  SizedBox(width: SproutSpace.xs),
                  Text(
                    'Parents',
                    style: TextStyle(
                      fontFamily: SproutType.family,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: SproutColors.primary,
                    ),
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

/// Top row of the child tabs: wordmark on the left, Parents on the right.
class BrandHeader extends StatelessWidget {
  const BrandHeader({required this.onParents, super.key});

  final VoidCallback onParents;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: SproutWordmark(),
          ),
        ),
        const SizedBox(width: SproutSpace.sm),
        ParentEntryButton(onPressed: onParents),
      ],
    );
  }
}
