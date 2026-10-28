import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/design_system/sprout_tokens.dart';
import '../../core/design_system/widgets/game_header.dart';
import '../../core/design_system/widgets/primary_kid_button.dart';
import '../../core/design_system/widgets/sprout_card.dart';
import '../../domain/games/connect_dots/connect_dots_catalog.dart';
import '../../domain/games/play/activity_definition.dart';
import '../../domain/scoring/activity_score.dart';
import 'open_activity.dart';
import '../../core/design_system/widgets/feedback_overlay.dart';
import 'play_chrome.dart';
import 'play_sounds.dart';
import 'save_completion.dart';

class ConnectDotsScreen extends ConsumerStatefulWidget {
  const ConnectDotsScreen({required this.activity, this.journeyDate, super.key});

  final ActivityDefinition activity;
  final String? journeyDate;

  @override
  ConsumerState<ConnectDotsScreen> createState() => _ConnectDotsScreenState();
}

class _ConnectDotsScreenState extends ConsumerState<ConnectDotsScreen> {
  final _stroke = <Offset>[];
  bool _taught = false;
  bool _saved = false;
  bool _finished = false;
  String? _feedback;
  int _wrong = 0;

  ConnectDotsLevel get _level => connectDotsLevel(widget.activity.variant);

  void _add(Offset local, Size size) {
    if (_finished || !_taught) {
      return;
    }
    setState(() {
      _stroke.add(Offset(local.dx / size.width, local.dy / size.height));
    });
  }

  Future<void> _check() async {
    if (_finished || _stroke.length < 4) {
      setState(() => _feedback = 'Keep one long line through the stars.');
      return;
    }
    final dots = _level.dots;
    final mapped = [
      for (final point in _stroke) Offset(point.dx * 320, point.dy * 320),
    ];
    final targets = [for (final dot in dots) Offset(dot.dx * 320, dot.dy * 320)];
    final ok = pathVisitsDotsInOrder(mapped, targets);
    if (!ok) {
      setState(() {
        _wrong++;
        _stroke.clear();
        _feedback = 'Almost. Start at 1 and keep the line moving to the next star.';
      });
      playFeedback(ref, FeedbackKind.retry);
      return;
    }
    setState(() {
      _finished = true;
      _feedback = 'You joined the stars!';
    });
    playFeedback(ref, FeedbackKind.correct);
    if (_saved) {
      return;
    }
    _saved = true;
    await saveFinishedActivity(
      ref,
      activity: widget.activity,
      hintsUsed: 0,
      firstAttemptCorrect: _wrong == 0,
      stars: _wrong == 0 ? 3 : 2,
      wrongCount: _wrong,
      journeyDate: widget.journeyDate,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_finished) {
      return FinishedBanner(
        stars: _wrong == 0 ? 3 : 2,
        points: scoreRound(
          category: widget.activity.category,
          wrongCount: _wrong,
          hintsUsed: 0,
        ).points,
        badgeLabel: levelBadgeLabel(widget.activity),
        onReplay: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute<void>(
              builder: (context) => screenFor(
                widget.activity,
                journeyDate: widget.journeyDate,
              ),
            ),
          );
        },
        onDone: () => Navigator.of(context).pop(),
      );
    }
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(SproutSpace.md),
          children: [
            GameHeader(
              title: _level.title,
              activity: widget.activity,
              onClose: () => Navigator.of(context).pop(),
              progress: _taught ? 0.5 : 0.2,
              progressLabel: _taught ? 'Draw the path' : 'Lesson',
            ),
            const SizedBox(height: SproutSpace.md),
            SproutCard(
              child: Text(
                _level.teaching,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            if (!_taught) ...[
              const SizedBox(height: SproutSpace.md),
              PrimaryKidButton(
                label: 'Let’s try',
                onPressed: () => setState(() => _taught = true),
              ),
            ] else ...[
              const SizedBox(height: SproutSpace.md),
              AspectRatio(
                aspectRatio: 1,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final size = Size(constraints.maxWidth, constraints.maxHeight);
                    return GestureDetector(
                      onPanStart: (details) {
                        _stroke.clear();
                        _add(details.localPosition, size);
                      },
                      onPanUpdate: (details) => _add(details.localPosition, size),
                      onPanEnd: (_) => _check(),
                      child: CustomPaint(
                        painter: _DotsPainter(
                          dots: _level.dots,
                          stroke: _stroke,
                        ),
                        child: const SizedBox.expand(),
                      ),
                    );
                  },
                ),
              ),
              if (_feedback != null) ...[
                const SizedBox(height: SproutSpace.sm),
                Text(_feedback!, style: Theme.of(context).textTheme.bodyLarge),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

class _DotsPainter extends CustomPainter {
  _DotsPainter({required this.dots, required this.stroke});

  final List<Offset> dots;
  final List<Offset> stroke;

  @override
  void paint(Canvas canvas, Size size) {
    final line = Paint()
      ..color = SproutColors.primary
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    if (stroke.length > 1) {
      final path = Path()
        ..moveTo(stroke.first.dx * size.width, stroke.first.dy * size.height);
      for (final point in stroke.skip(1)) {
        path.lineTo(point.dx * size.width, point.dy * size.height);
      }
      canvas.drawPath(path, line);
    }
    final fill = Paint()..color = SproutColors.accent;
    final text = TextPainter(textDirection: TextDirection.ltr);
    for (var index = 0; index < dots.length; index++) {
      final center = Offset(dots[index].dx * size.width, dots[index].dy * size.height);
      canvas.drawCircle(center, 16, fill);
      text
        ..text = TextSpan(
          text: '${index + 1}',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 14,
          ),
        )
        ..layout();
      text.paint(canvas, center - Offset(text.width / 2, text.height / 2));
    }
  }

  @override
  bool shouldRepaint(covariant _DotsPainter oldDelegate) {
    return oldDelegate.stroke != stroke || oldDelegate.dots != dots;
  }
}
