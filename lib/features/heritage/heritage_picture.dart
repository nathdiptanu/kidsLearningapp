import 'package:flutter/material.dart';

/// Original drawings for heritage sites. These are not photographs and
/// are not copied from a third-party image.
class HeritagePicture extends StatelessWidget {
  const HeritagePicture({
    required this.pictureId,
    this.size = 120,
    super.key,
  });

  final String pictureId;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Drawing of a historic place',
      child: ExcludeSemantics(
        child: SizedBox(
          width: size,
          height: size,
          child: CustomPaint(painter: _HeritagePainter(pictureId)),
        ),
      ),
    );
  }
}

class _HeritagePainter extends CustomPainter {
  const _HeritagePainter(this.pictureId);

  final String pictureId;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.shortestSide;
    switch (pictureId) {
      case 'heritage-sanchi':
        _sanchi(canvas, s);
      case 'heritage-konark':
        _konark(canvas, s);
      case 'heritage-mahabalipuram':
        _mahabalipuram(canvas, s);
      case 'heritage-taj':
        _taj(canvas, s);
      default:
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(s * 0.2, s * 0.2, s * 0.6, s * 0.6),
            Radius.circular(s * 0.08),
          ),
          Paint()..color = const Color(0xFFCBD5E1),
        );
    }
  }

  void _sanchi(Canvas canvas, double s) {
    final stone = Paint()..color = const Color(0xFFC4A574);
    final dark = Paint()..color = const Color(0xFF8A6A3E);
    canvas.drawOval(Rect.fromLTWH(s * 0.18, s * 0.32, s * 0.64, s * 0.46), stone);
    canvas.drawCircle(Offset(s * 0.5, s * 0.46), s * 0.26, stone);
    canvas.drawRect(Rect.fromLTWH(s * 0.44, s * 0.16, s * 0.12, s * 0.1), dark);
    canvas.drawRect(Rect.fromLTWH(s * 0.47, s * 0.08, s * 0.06, s * 0.1), dark);
    final rail = Paint()
      ..color = const Color(0xFF6B4F2A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = s * 0.03;
    canvas.drawOval(Rect.fromLTWH(s * 0.16, s * 0.58, s * 0.68, s * 0.22), rail);
  }

  void _konark(Canvas canvas, double s) {
    final stone = Paint()..color = const Color(0xFFD08A3A);
    final path = Path()
      ..moveTo(s * 0.2, s * 0.78)
      ..lineTo(s * 0.32, s * 0.5)
      ..lineTo(s * 0.42, s * 0.5)
      ..lineTo(s * 0.5, s * 0.18)
      ..lineTo(s * 0.58, s * 0.5)
      ..lineTo(s * 0.68, s * 0.5)
      ..lineTo(s * 0.8, s * 0.78)
      ..close();
    canvas.drawPath(path, stone);
    final wheel = Paint()
      ..color = const Color(0xFF8A4300)
      ..style = PaintingStyle.stroke
      ..strokeWidth = s * 0.035;
    canvas.drawCircle(Offset(s * 0.34, s * 0.78), s * 0.1, wheel);
    canvas.drawCircle(Offset(s * 0.66, s * 0.78), s * 0.1, wheel);
  }

  void _mahabalipuram(Canvas canvas, double s) {
    final water = Paint()..color = const Color(0xFF7EB6D4);
    canvas.drawRect(Rect.fromLTWH(0, s * 0.72, s, s * 0.28), water);
    final stone = Paint()..color = const Color(0xFFB7C0C8);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(s * 0.18, s * 0.38, s * 0.28, s * 0.36),
        Radius.circular(s * 0.04),
      ),
      stone,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(s * 0.5, s * 0.28, s * 0.3, s * 0.46),
        Radius.circular(s * 0.04),
      ),
      stone,
    );
    final cap = Paint()..color = const Color(0xFF7A8794);
    canvas.drawRect(Rect.fromLTWH(s * 0.24, s * 0.3, s * 0.16, s * 0.08), cap);
    canvas.drawRect(Rect.fromLTWH(s * 0.56, s * 0.2, s * 0.18, s * 0.08), cap);
  }

  void _taj(Canvas canvas, double s) {
    final sky = Paint()..color = const Color(0xFFD7E7F5);
    canvas.drawRect(Rect.fromLTWH(0, 0, s, s * 0.72), sky);
    final water = Paint()..color = const Color(0xFF9EC4D8);
    canvas.drawRect(Rect.fromLTWH(0, s * 0.78, s, s * 0.22), water);
    final marble = Paint()..color = const Color(0xFFF4F7FA);
    final edge = Paint()
      ..color = const Color(0xFF7A8794)
      ..style = PaintingStyle.stroke
      ..strokeWidth = s * 0.012;
    final accent = Paint()..color = const Color(0xFF9AA7B4);
    void minaret(double x) {
      canvas.drawRect(Rect.fromLTWH(x - s * 0.025, s * 0.34, s * 0.05, s * 0.4), marble);
      canvas.drawRect(Rect.fromLTWH(x - s * 0.025, s * 0.34, s * 0.05, s * 0.4), edge);
      canvas.drawOval(
        Rect.fromCenter(center: Offset(x, s * 0.32), width: s * 0.07, height: s * 0.08),
        marble,
      );
      canvas.drawOval(
        Rect.fromCenter(center: Offset(x, s * 0.32), width: s * 0.07, height: s * 0.08),
        edge,
      );
      canvas.drawCircle(Offset(x, s * 0.275), s * 0.012, accent);
    }

    canvas.drawRect(Rect.fromLTWH(s * 0.12, s * 0.72, s * 0.76, s * 0.08), marble);
    canvas.drawRect(Rect.fromLTWH(s * 0.12, s * 0.72, s * 0.76, s * 0.08), edge);
    minaret(s * 0.18);
    minaret(s * 0.82);
    minaret(s * 0.3);
    minaret(s * 0.7);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(s * 0.26, s * 0.46, s * 0.48, s * 0.28),
        Radius.circular(s * 0.02),
      ),
      marble,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(s * 0.26, s * 0.46, s * 0.48, s * 0.28),
        Radius.circular(s * 0.02),
      ),
      edge,
    );
    final arch = Path()
      ..moveTo(s * 0.42, s * 0.74)
      ..lineTo(s * 0.42, s * 0.58)
      ..quadraticBezierTo(s * 0.5, s * 0.46, s * 0.58, s * 0.58)
      ..lineTo(s * 0.58, s * 0.74)
      ..close();
    canvas.drawPath(arch, accent);
    final dome = Path()
      ..moveTo(s * 0.32, s * 0.48)
      ..quadraticBezierTo(s * 0.5, s * 0.12, s * 0.68, s * 0.48)
      ..close();
    canvas.drawPath(dome, marble);
    canvas.drawPath(dome, edge);
    canvas.drawCircle(Offset(s * 0.5, s * 0.16), s * 0.016, accent);
    canvas.drawLine(Offset(s * 0.5, s * 0.14), Offset(s * 0.5, s * 0.08), edge);
    void chhatri(double x) {
      canvas.drawOval(
        Rect.fromCenter(center: Offset(x, s * 0.44), width: s * 0.1, height: s * 0.08),
        marble,
      );
      canvas.drawOval(
        Rect.fromCenter(center: Offset(x, s * 0.44), width: s * 0.1, height: s * 0.08),
        edge,
      );
    }

    chhatri(s * 0.34);
    chhatri(s * 0.66);
  }

  @override
  bool shouldRepaint(covariant _HeritagePainter oldDelegate) {
    return oldDelegate.pictureId != pictureId;
  }
}
