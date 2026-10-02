import 'package:flutter/material.dart';

/// Original engineering drawings for reviewed vocabulary words.
/// These are temporary illustrations, not production-final art.
class WordPicture extends StatelessWidget {
  const WordPicture({required this.wordId, required this.size, super.key});

  final String wordId;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _WordPainter(wordId)),
    );
  }
}

class _WordPainter extends CustomPainter {
  _WordPainter(this.wordId);

  final String wordId;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final s = size.shortestSide;
    switch (wordId) {
      case 'apple':
        paint.color = const Color(0xFFD64545);
        canvas.drawCircle(Offset(s * 0.5, s * 0.55), s * 0.32, paint);
        paint.color = const Color(0xFF2F7D4A);
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset(s * 0.62, s * 0.22),
            width: s * 0.22,
            height: s * 0.12,
          ),
          paint,
        );
        paint.color = const Color(0xFF6B4A2B);
        canvas.drawRect(
          Rect.fromLTWH(s * 0.47, s * 0.08, s * 0.06, s * 0.16),
          paint,
        );
      case 'banana':
        paint.color = const Color(0xFFF2C14E);
        canvas.drawArc(
          Rect.fromLTWH(s * 0.15, s * 0.2, s * 0.7, s * 0.7),
          0.4,
          2.2,
          false,
          paint
            ..style = PaintingStyle.stroke
            ..strokeWidth = s * 0.16,
        );
        paint.style = PaintingStyle.fill;
      case 'mango':
        paint.color = const Color(0xFFE07A2F);
        canvas.drawOval(
          Rect.fromLTWH(s * 0.22, s * 0.28, s * 0.5, s * 0.58),
          paint,
        );
        paint.color = const Color(0xFF2F7D4A);
        canvas.drawOval(
          Rect.fromLTWH(s * 0.48, s * 0.12, s * 0.28, s * 0.16),
          paint,
        );
      case 'cat':
        paint.color = const Color(0xFFE39B4A);
        canvas.drawCircle(Offset(s * 0.5, s * 0.58), s * 0.28, paint);
        canvas.drawPath(
          Path()
            ..moveTo(s * 0.28, s * 0.42)
            ..lineTo(s * 0.22, s * 0.16)
            ..lineTo(s * 0.46, s * 0.36)
            ..close(),
          paint,
        );
        canvas.drawPath(
          Path()
            ..moveTo(s * 0.72, s * 0.42)
            ..lineTo(s * 0.78, s * 0.16)
            ..lineTo(s * 0.54, s * 0.36)
            ..close(),
          paint,
        );
        paint.color = const Color(0xFF2C2416);
        canvas.drawCircle(Offset(s * 0.4, s * 0.56), s * 0.04, paint);
        canvas.drawCircle(Offset(s * 0.6, s * 0.56), s * 0.04, paint);
      case 'dog':
        paint.color = const Color(0xFF8A5A2B);
        canvas.drawCircle(Offset(s * 0.5, s * 0.55), s * 0.26, paint);
        canvas.drawOval(
          Rect.fromLTWH(s * 0.08, s * 0.28, s * 0.22, s * 0.36),
          paint,
        );
        canvas.drawOval(
          Rect.fromLTWH(s * 0.7, s * 0.28, s * 0.22, s * 0.36),
          paint,
        );
        paint.color = const Color(0xFF2C2416);
        canvas.drawCircle(Offset(s * 0.42, s * 0.52), s * 0.035, paint);
        canvas.drawCircle(Offset(s * 0.58, s * 0.52), s * 0.035, paint);
      case 'bird':
        paint.color = const Color(0xFF3D7EA6);
        canvas.drawOval(
          Rect.fromLTWH(s * 0.28, s * 0.32, s * 0.4, s * 0.32),
          paint,
        );
        paint.color = const Color(0xFFE07A2F);
        canvas.drawPath(
          Path()
            ..moveTo(s * 0.62, s * 0.44)
            ..lineTo(s * 0.86, s * 0.4)
            ..lineTo(s * 0.64, s * 0.54)
            ..close(),
          paint,
        );
      case 'bus':
        paint.color = const Color(0xFFF2C14E);
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(s * 0.12, s * 0.28, s * 0.76, s * 0.4),
            const Radius.circular(4),
          ),
          paint,
        );
        paint.color = const Color(0xFF8FB8D6);
        canvas.drawRect(
          Rect.fromLTWH(s * 0.2, s * 0.36, s * 0.16, s * 0.14),
          paint,
        );
        canvas.drawRect(
          Rect.fromLTWH(s * 0.42, s * 0.36, s * 0.16, s * 0.14),
          paint,
        );
        paint.color = const Color(0xFF2C2416);
        canvas.drawCircle(Offset(s * 0.28, s * 0.72), s * 0.07, paint);
        canvas.drawCircle(Offset(s * 0.7, s * 0.72), s * 0.07, paint);
      case 'car':
        paint.color = const Color(0xFF3D6FBF);
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(s * 0.12, s * 0.48, s * 0.76, s * 0.22),
            const Radius.circular(6),
          ),
          paint,
        );
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(s * 0.28, s * 0.28, s * 0.4, s * 0.22),
            const Radius.circular(6),
          ),
          paint,
        );
        paint.color = const Color(0xFF2C2416);
        canvas.drawCircle(Offset(s * 0.3, s * 0.74), s * 0.08, paint);
        canvas.drawCircle(Offset(s * 0.7, s * 0.74), s * 0.08, paint);
      case 'sun':
        paint.color = const Color(0xFFF2C14E);
        canvas.drawCircle(Offset(s * 0.5, s * 0.5), s * 0.22, paint);
        paint.strokeWidth = s * 0.06;
        paint.style = PaintingStyle.stroke;
        canvas.drawCircle(Offset(s * 0.5, s * 0.5), s * 0.34, paint);
        paint.style = PaintingStyle.fill;
      case 'moon':
        paint.color = const Color(0xFFF4E2B0);
        canvas.drawCircle(Offset(s * 0.46, s * 0.5), s * 0.28, paint);
        paint.color = const Color(0xFFFFF8F0);
        canvas.drawCircle(Offset(s * 0.6, s * 0.42), s * 0.22, paint);
      case 'shoe':
        paint.color = const Color(0xFF6B4A2B);
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(s * 0.12, s * 0.48, s * 0.7, s * 0.22),
            const Radius.circular(8),
          ),
          paint,
        );
        canvas.drawRect(
          Rect.fromLTWH(s * 0.18, s * 0.28, s * 0.28, s * 0.24),
          paint,
        );
      case 'hat':
        paint.color = const Color(0xFF3D6FBF);
        canvas.drawRect(
          Rect.fromLTWH(s * 0.34, s * 0.22, s * 0.32, s * 0.28),
          paint,
        );
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(s * 0.12, s * 0.48, s * 0.76, s * 0.12),
            const Radius.circular(6),
          ),
          paint,
        );
      case 'flower':
        paint.color = const Color(0xFFB84C6A);
        for (final offset in const [
          Offset(0.5, 0.28),
          Offset(0.28, 0.46),
          Offset(0.72, 0.46),
          Offset(0.36, 0.68),
          Offset(0.64, 0.68),
        ]) {
          canvas.drawCircle(
            Offset(s * offset.dx, s * offset.dy),
            s * 0.12,
            paint,
          );
        }
        paint.color = const Color(0xFFF2C14E);
        canvas.drawCircle(Offset(s * 0.5, s * 0.5), s * 0.1, paint);
      case 'fish':
        paint.color = const Color(0xFFE07A2F);
        canvas.drawOval(
          Rect.fromLTWH(s * 0.22, s * 0.32, s * 0.5, s * 0.32),
          paint,
        );
        canvas.drawPath(
          Path()
            ..moveTo(s * 0.22, s * 0.48)
            ..lineTo(s * 0.08, s * 0.32)
            ..lineTo(s * 0.08, s * 0.64)
            ..close(),
          paint,
        );
        paint.color = const Color(0xFF2C2416);
        canvas.drawCircle(Offset(s * 0.58, s * 0.44), s * 0.03, paint);
      case 'tree':
        paint.color = const Color(0xFF6B4A2B);
        canvas.drawRect(
          Rect.fromLTWH(s * 0.44, s * 0.52, s * 0.12, s * 0.32),
          paint,
        );
        paint.color = const Color(0xFF2F7D4A);
        canvas.drawCircle(Offset(s * 0.5, s * 0.38), s * 0.28, paint);
      case 'book':
        paint.color = const Color(0xFF3D6FBF);
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(s * 0.22, s * 0.18, s * 0.5, s * 0.64),
            const Radius.circular(4),
          ),
          paint,
        );
        paint.color = const Color(0xFFFFF8F0);
        canvas.drawRect(
          Rect.fromLTWH(s * 0.46, s * 0.24, s * 0.2, s * 0.52),
          paint,
        );
      case 'ball':
        paint.color = const Color(0xFFD64545);
        canvas.drawCircle(Offset(s * 0.5, s * 0.5), s * 0.3, paint);
        paint.color = const Color(0xFFFFF8F0);
        paint.style = PaintingStyle.stroke;
        paint.strokeWidth = s * 0.04;
        canvas.drawArc(
          Rect.fromLTWH(s * 0.28, s * 0.22, s * 0.44, s * 0.56),
          0.5,
          2.2,
          false,
          paint,
        );
      case 'cup':
        paint
          ..style = PaintingStyle.fill
          ..color = const Color(0xFF6B7C72);
        canvas.drawPath(
          Path()
            ..moveTo(s * 0.28, s * 0.28)
            ..lineTo(s * 0.68, s * 0.28)
            ..lineTo(s * 0.6, s * 0.72)
            ..lineTo(s * 0.36, s * 0.72)
            ..close(),
          paint,
        );
        paint.style = PaintingStyle.stroke;
        paint.strokeWidth = s * 0.05;
        canvas.drawArc(
          Rect.fromLTWH(s * 0.62, s * 0.34, s * 0.22, s * 0.28),
          -1.2,
          2.4,
          false,
          paint,
        );
      default:
        paint.color = const Color(0xFF6B7C72);
        canvas.drawCircle(Offset(s * 0.5, s * 0.5), s * 0.2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _WordPainter oldDelegate) =>
      oldDelegate.wordId != wordId;
}
