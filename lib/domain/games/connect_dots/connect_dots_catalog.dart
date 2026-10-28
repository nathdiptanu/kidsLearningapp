import 'dart:math';
import 'dart:ui';

/// Ordered star points in unit space. The child draws one free-flow line.
class ConnectDotsLevel {
  const ConnectDotsLevel({
    required this.title,
    required this.dots,
    required this.teaching,
  });

  final String title;
  final List<Offset> dots;
  final String teaching;
}

String connectDotsTitle(int variant) {
  return connectDotsLevel(variant).title;
}

ConnectDotsLevel connectDotsLevel(int variant) {
  final base = _levels[variant % _levels.length];
  if (variant < _levels.length) {
    return base;
  }
  final shift = ((variant ~/ _levels.length) % 3) * 0.03;
  return ConnectDotsLevel(
    title: '${base.title} · another path',
    teaching: base.teaching,
    dots: [
      for (final dot in base.dots)
        Offset(
          (dot.dx + shift).clamp(0.12, 0.88),
          (dot.dy - shift * 0.4).clamp(0.12, 0.88),
        ),
    ],
  );
}

bool pathVisitsDotsInOrder(List<Offset> stroke, List<Offset> dots, {double radius = 28}) {
  if (stroke.length < 2 || dots.length < 2) {
    return false;
  }
  var index = 0;
  for (final point in stroke) {
    if ((point - dots[index]).distance <= radius) {
      index++;
      if (index == dots.length) {
        return true;
      }
    }
  }
  return false;
}

double nearestMiss(List<Offset> stroke, List<Offset> dots) {
  var worst = 0.0;
  for (final dot in dots) {
    var best = double.infinity;
    for (final point in stroke) {
      best = min(best, (point - dot).distance);
    }
    worst = max(worst, best);
  }
  return worst;
}

const _levels = <ConnectDotsLevel>[
  ConnectDotsLevel(
    title: 'A little star',
    teaching: 'Draw one smooth line from 1 to 2 to 3. Do not lift and tap each star. Keep the line going.',
    dots: [Offset(0.50, 0.18), Offset(0.22, 0.72), Offset(0.78, 0.72)],
  ),
  ConnectDotsLevel(
    title: 'A kite of stars',
    teaching: 'Start at the top star. Sweep down the kite, then across, then up. One flowing line.',
    dots: [Offset(0.50, 0.14), Offset(0.78, 0.42), Offset(0.50, 0.82), Offset(0.22, 0.42)],
  ),
  ConnectDotsLevel(
    title: 'House outline',
    teaching: 'Join the roof, then the walls. Keep your finger down while you travel.',
    dots: [Offset(0.50, 0.16), Offset(0.82, 0.40), Offset(0.82, 0.84), Offset(0.18, 0.84), Offset(0.18, 0.40)],
  ),
  ConnectDotsLevel(
    title: 'A smile of stars',
    teaching: 'Start on the left. Curve through the middle stars to the right, like a smile.',
    dots: [Offset(0.16, 0.38), Offset(0.34, 0.62), Offset(0.50, 0.70), Offset(0.66, 0.62), Offset(0.84, 0.38)],
  ),
  ConnectDotsLevel(
    title: 'Five-point star',
    teaching: 'Follow 1 to 5 in order. A star is five points. Keep one continuous line.',
    dots: [Offset(0.50, 0.12), Offset(0.80, 0.38), Offset(0.70, 0.82), Offset(0.30, 0.82), Offset(0.20, 0.38)],
  ),
  ConnectDotsLevel(
    title: 'A tall triangle',
    teaching: 'Start at the top, sweep to one base corner, then the other, then home. One line.',
    dots: [Offset(0.50, 0.14), Offset(0.82, 0.82), Offset(0.18, 0.82)],
  ),
  ConnectDotsLevel(
    title: 'A square window',
    teaching: 'Join the four corners around the square. Keep your finger down.',
    dots: [Offset(0.22, 0.20), Offset(0.78, 0.20), Offset(0.78, 0.80), Offset(0.22, 0.80)],
  ),
  ConnectDotsLevel(
    title: 'A gentle wave',
    teaching: 'Start on the left. Rise and fall through each star like a small wave.',
    dots: [Offset(0.14, 0.62), Offset(0.32, 0.28), Offset(0.50, 0.62), Offset(0.68, 0.28), Offset(0.86, 0.62)],
  ),
  ConnectDotsLevel(
    title: 'A mountain path',
    teaching: 'Climb up, then down, then up again. Do not tap each peak. Draw through them.',
    dots: [Offset(0.12, 0.78), Offset(0.32, 0.28), Offset(0.50, 0.70), Offset(0.68, 0.22), Offset(0.88, 0.78)],
  ),
  ConnectDotsLevel(
    title: 'A diamond jewel',
    teaching: 'Start at the top point. Travel around the diamond and finish at the start side.',
    dots: [Offset(0.50, 0.14), Offset(0.82, 0.50), Offset(0.50, 0.86), Offset(0.18, 0.50)],
  ),
  ConnectDotsLevel(
    title: 'A rainbow arch',
    teaching: 'Begin low on the left. Arc up through the middle, then down to the right.',
    dots: [Offset(0.16, 0.78), Offset(0.30, 0.42), Offset(0.50, 0.20), Offset(0.70, 0.42), Offset(0.84, 0.78)],
  ),
  ConnectDotsLevel(
    title: 'A plus of stars',
    teaching: 'Go top, middle, bottom, then across the arms. Keep one flowing stroke.',
    dots: [Offset(0.50, 0.14), Offset(0.50, 0.50), Offset(0.50, 0.86), Offset(0.18, 0.50), Offset(0.82, 0.50)],
  ),
  ConnectDotsLevel(
    title: 'A boat outline',
    teaching: 'Draw the sail point, then the deck, then the hull. One continuous line.',
    dots: [Offset(0.50, 0.16), Offset(0.50, 0.52), Offset(0.82, 0.52), Offset(0.70, 0.82), Offset(0.30, 0.82), Offset(0.18, 0.52)],
  ),
  ConnectDotsLevel(
    title: 'A flower loop',
    teaching: 'Visit each petal star in order. Sweep, do not poke each one.',
    dots: [Offset(0.50, 0.18), Offset(0.78, 0.38), Offset(0.70, 0.72), Offset(0.30, 0.72), Offset(0.22, 0.38)],
  ),
  ConnectDotsLevel(
    title: 'A zigzag trail',
    teaching: 'Zig left and right down the page. Keep the line moving.',
    dots: [Offset(0.22, 0.18), Offset(0.78, 0.32), Offset(0.22, 0.50), Offset(0.78, 0.68), Offset(0.22, 0.84)],
  ),
];
