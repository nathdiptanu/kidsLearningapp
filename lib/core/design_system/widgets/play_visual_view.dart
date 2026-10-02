import 'package:flutter/material.dart';

import '../../../domain/games/play/play_question.dart';
import '../sprout_tokens.dart';
import 'word_picture.dart';

class PlayVisualView extends StatelessWidget {
  const PlayVisualView({required this.visual, super.key, this.size = 36});

  final ChoiceVisual visual;
  final double size;

  @override
  Widget build(BuildContext context) {
    return switch (visual) {
      NumeralVisual(:final value) => Text(
        '$value',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
      CountGroupVisual(:final count, :final glyph) => Wrap(
        spacing: 4,
        runSpacing: 4,
        children: [
          for (var index = 0; index < count; index++)
            _Dot(glyph: glyph, size: size * 0.45),
        ],
      ),
      SymbolVisual(:final symbol, :final scale, :final heading) => _Shape(
        symbol: symbol,
        size: size,
        scale: scale,
        heading: heading,
      ),
      PictureVisual(:final id) => _Picture(id: id, size: size),
      WordPictureVisual(:final wordId) => WordPicture(
        wordId: wordId,
        size: size,
      ),
      LetterVisual(:final letter) => Text(
        letter,
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    };
  }
}

class PromptVisualRow extends StatelessWidget {
  const PromptVisualRow({required this.visuals, super.key});

  final List<ChoiceVisual> visuals;

  @override
  Widget build(BuildContext context) {
    if (visuals.isEmpty) {
      return const SizedBox.shrink();
    }
    return Wrap(
      spacing: SproutSpace.sm,
      runSpacing: SproutSpace.sm,
      alignment: WrapAlignment.center,
      children: [
        for (final visual in visuals)
          PlayVisualView(
            visual: visual,
            size: visual is WordPictureVisual ? 96 : 28,
          ),
      ],
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.glyph, required this.size});

  final CountGlyph glyph;
  final double size;

  @override
  Widget build(BuildContext context) {
    final color = switch (glyph) {
      CountGlyph.leaf => SproutColors.seed,
      CountGlyph.star => SproutColors.accent,
      CountGlyph.pebble => const Color(0xFF6B7C72),
    };
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: glyph == CountGlyph.pebble
            ? BoxShape.circle
            : BoxShape.rectangle,
        borderRadius: glyph == CountGlyph.leaf
            ? const BorderRadius.all(Radius.circular(10))
            : null,
      ),
    );
  }
}

class _Shape extends StatelessWidget {
  const _Shape({
    required this.symbol,
    required this.size,
    required this.scale,
    required this.heading,
  });

  final PatternSymbol symbol;
  final double size;
  final PatternScale scale;
  final PatternHeading heading;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: _ShapePainter(symbol, scale: scale, heading: heading),
    );
  }
}

class _ShapePainter extends CustomPainter {
  _ShapePainter(this.symbol, {required this.scale, required this.heading});

  final PatternSymbol symbol;
  final PatternScale scale;
  final PatternHeading heading;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = switch (symbol) {
        PatternSymbol.circle => SproutColors.seed,
        PatternSymbol.square => SproutColors.accent,
        PatternSymbol.triangle => const Color(0xFF3D7EA6),
        PatternSymbol.star => const Color(0xFFC45C26),
      };
    final inset = scale == PatternScale.small ? size.shortestSide * 0.22 : 2.0;
    final rect = (Offset.zero & size).deflate(inset);
    canvas.save();
    if (heading != PatternHeading.up) {
      final turns = switch (heading) {
        PatternHeading.up => 0,
        PatternHeading.right => 1,
        PatternHeading.down => 2,
        PatternHeading.left => 3,
      };
      canvas.translate(size.width / 2, size.height / 2);
      canvas.rotate(turns * 1.5707963267948966);
      canvas.translate(-size.width / 2, -size.height / 2);
    }
    switch (symbol) {
      case PatternSymbol.circle:
        canvas.drawOval(rect, paint);
      case PatternSymbol.square:
        canvas.drawRRect(
          RRect.fromRectAndRadius(rect, const Radius.circular(6)),
          paint,
        );
      case PatternSymbol.triangle:
        final path = Path()
          ..moveTo(rect.center.dx, rect.top)
          ..lineTo(rect.right, rect.bottom)
          ..lineTo(rect.left, rect.bottom)
          ..close();
        canvas.drawPath(path, paint);
      case PatternSymbol.star:
        canvas.drawCircle(rect.center, rect.shortestSide * 0.28, paint);
        canvas.drawRect(
          Rect.fromCenter(
            center: rect.center,
            width: rect.width * 0.22,
            height: rect.height * 0.9,
          ),
          paint,
        );
        canvas.drawRect(
          Rect.fromCenter(
            center: rect.center,
            width: rect.width * 0.9,
            height: rect.height * 0.22,
          ),
          paint,
        );
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _ShapePainter oldDelegate) {
    return oldDelegate.symbol != symbol ||
        oldDelegate.scale != scale ||
        oldDelegate.heading != heading;
  }
}

class _Picture extends StatelessWidget {
  const _Picture({required this.id, required this.size});

  final PictureId id;
  final double size;

  @override
  Widget build(BuildContext context) {
    final item = pictureById(id);
    final color = switch (item.kind) {
      PictureKind.fruit => const Color(0xFFC45C26),
      PictureKind.animal => const Color(0xFF8A5A2B),
      PictureKind.vehicle => const Color(0xFF3D7EA6),
      PictureKind.sky => const Color(0xFFC47B2B),
      PictureKind.clothing => const Color(0xFF6B4C9A),
      PictureKind.home => const Color(0xFF6B7C72),
      PictureKind.flower => const Color(0xFFB84C6A),
    };
    final icon = switch (item.kind) {
      PictureKind.fruit => Icons.eco_rounded,
      PictureKind.animal => Icons.pets,
      PictureKind.vehicle => Icons.directions_bus_rounded,
      PictureKind.sky => Icons.wb_sunny_rounded,
      PictureKind.clothing => Icons.checkroom,
      PictureKind.home => Icons.chair,
      PictureKind.flower => Icons.local_florist_rounded,
    };
    return Icon(icon, color: color, size: size);
  }
}
