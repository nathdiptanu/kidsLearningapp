import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/design_system/sprout_tokens.dart';
import '../../core/design_system/widgets/app_page_scaffold.dart';
import '../../core/design_system/widgets/game_header.dart';
import '../../core/design_system/widgets/primary_kid_button.dart';
import '../../domain/games/play/activity_definition.dart';
import '../../domain/games/tictactoe/tic_tac_toe.dart';
import '../../domain/models/age_band.dart';
import '../../domain/scoring/activity_score.dart';
import 'open_activity.dart';
import 'play_chrome.dart';
import 'save_completion.dart';

class TicTacToeScreen extends ConsumerStatefulWidget {
  const TicTacToeScreen({required this.activity, this.journeyDate, super.key});

  final ActivityDefinition activity;
  final String? journeyDate;

  @override
  ConsumerState<TicTacToeScreen> createState() => _TicTacToeScreenState();
}

class _TicTacToeScreenState extends ConsumerState<TicTacToeScreen> {
  final TicTacToeEngine _engine = const TicTacToeEngine();
  late TicState _state;
  bool _saved = false;
  bool _ready = false;
  Timer? _opponent;

  @override
  void initState() {
    super.initState();
    _state = _engine.create(
      variant: widget.activity.variant,
      seed: widget.activity.seed,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCheckpoint();
    });
  }

  @override
  void dispose() {
    _opponent?.cancel();
    super.dispose();
  }

  Future<void> _loadCheckpoint() async {
    final payload = await loadCheckpoint(ref, widget.activity.id);
    if (!mounted) {
      return;
    }
    final restored = payload == null
        ? null
        : parseTicCheckpoint(
            payload,
            seed: widget.activity.seed,
            variant: widget.activity.variant,
          );
    if (payload != null && restored == null) {
      await deleteCheckpoint(ref, widget.activity.id);
    }
    if (restored != null) {
      _state = restored;
    }
    if (mounted) {
      setState(() => _ready = true);
    }
  }

  Future<void> _storeCheckpoint() async {
    if (!_ready || _state.finished || _saved) {
      return;
    }
    await storeCheckpoint(
      ref,
      widget.activity.id,
      ticCheckpointPayload(
        seed: widget.activity.seed,
        variant: widget.activity.variant,
        state: _state,
      ),
    );
  }

  void _apply(TicAction action) {
    final next = _engine.reduce(_state, action);
    if (identical(next, _state)) {
      return;
    }
    setState(() => _state = next);
    if (next.finished) {
      _opponent?.cancel();
      _save();
      return;
    }
    if (!next.childTurn) {
      _scheduleOpponent();
    } else {
      _storeCheckpoint();
    }
  }

  void _scheduleOpponent() {
    _opponent?.cancel();
    final delay = SproutMotion.resolve(context, SproutMotion.small);
    _opponent = Timer(delay == Duration.zero ? Duration.zero : delay, () {
      if (!mounted) {
        return;
      }
      _apply(const TicAction.opponent());
    });
  }

  Future<void> _save() async {
    if (_saved || !_state.finished) {
      return;
    }
    _saved = true;
    final outcome = switch (_state.outcome) {
      TicOutcome.childWin => RoundOutcome.win,
      TicOutcome.draw => RoundOutcome.draw,
      TicOutcome.opponentWin || TicOutcome.ongoing => RoundOutcome.loss,
    };
    final scored = scoreRound(
      category: widget.activity.category,
      wrongCount: outcome == RoundOutcome.win ? 0 : 1,
      hintsUsed: _state.hintsUsed,
      outcome: outcome,
    );
    await saveFinishedActivity(
      ref,
      activity: widget.activity,
      hintsUsed: _state.hintsUsed,
      firstAttemptCorrect: scored.mastery,
      stars: scored.stars,
      wrongCount: outcome == RoundOutcome.win ? 0 : 1,
      journeyDate: widget.journeyDate,
      outcome: outcome,
    );
    await deleteCheckpoint(ref, widget.activity.id);
  }

  void _replay() {
    _opponent?.cancel();
    _saved = false;
    setState(() {
      _state = _engine.reduce(_state, const TicAction.reset());
    });
  }

  String _headline() {
    return switch (_state.outcome) {
      TicOutcome.childWin => 'Three in a line!',
      TicOutcome.draw => 'A draw is a fine game.',
      TicOutcome.opponentWin => 'Good try.',
      TicOutcome.ongoing => 'You finished!',
    };
  }

  @override
  Widget build(BuildContext context) {
    final scored = scoreRound(
      category: widget.activity.category,
      wrongCount: _state.outcome == TicOutcome.childWin ? 0 : 1,
      hintsUsed: _state.hintsUsed,
      outcome: switch (_state.outcome) {
        TicOutcome.childWin => RoundOutcome.win,
        TicOutcome.draw => RoundOutcome.draw,
        _ => RoundOutcome.loss,
      },
    );
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          confirmLeaveActivity(context, finished: _state.finished);
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: !_ready
              ? const Center(child: CircularProgressIndicator())
              : _state.finished
              ? FinishedBanner(
                  headline: _headline(),
                  stars: scored.stars,
                  points: scored.points,
                  badgeLabel: levelBadgeLabel(widget.activity),
                  onReplay: _replay,
                  onNext: widget.journeyDate == null
                      ? null
                      : () => openNextJourneyActivity(
                          context,
                          ref,
                          activity: widget.activity,
                          journeyDate: widget.journeyDate,
                        ),
                  onDone: () => Navigator.of(context).pop(),
                )
              : PageWidth(
                  child: ListView(
                  padding: const EdgeInsets.all(SproutSpace.md),
                  children: [
                    GameHeader(
                      title: widget.activity.title,
                      activity: widget.activity,
                      onClose: () => confirmLeaveActivity(
                        context,
                        finished: _state.finished,
                      ),
                    ),
                    Semantics(
                      liveRegion: true,
                      child: PlayInstruction(
                        text: _state.childTurn
                            ? 'Your turn. You are the cross.'
                            : 'Circle is thinking.',
                        detail: widget.activity.band == AgeBand.a
                            ? 'Get three crosses in a line. The circle plays on this device.'
                            : null,
                      ),
                    ),
                    const SizedBox(height: SproutSpace.md),
                    Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 420),
                        child: DecoratedBox(
                          decoration: const BoxDecoration(
                            color: SproutColors.ticTacToeSurface,
                            borderRadius: BorderRadius.all(
                              Radius.circular(SproutRadius.card),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: _Board(
                              state: _state,
                              onTap: (index) => _apply(TicAction.play(index)),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: SproutSpace.md),
                    SecondaryKidButton(
                      label: _state.hintsUsed == 0
                          ? 'Show a good square'
                          : 'Hint used',
                      onPressed: _state.hintsUsed == 0 && _state.childTurn
                          ? () => _apply(const TicAction.hint())
                          : null,
                    ),
                  ],
                  ),
                ),
        ),
      ),
    );
  }
}

class _Board extends StatelessWidget {
  const _Board({required this.state, required this.onTap});

  final TicState state;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 3,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: SproutSpace.sm,
      crossAxisSpacing: SproutSpace.sm,
      children: [
        for (var index = 0; index < 9; index++)
          _Cell(
            mark: state.cells[index],
            hinted: state.hintIndex == index,
            won:
                state.winLine != null &&
                ticLines[state.winLine!].contains(index),
            enabled:
                state.childTurn && !state.finished && state.cells[index] == 0,
            onTap: () => onTap(index),
          ),
      ],
    );
  }
}

class _Cell extends StatelessWidget {
  const _Cell({
    required this.mark,
    required this.hinted,
    required this.won,
    required this.enabled,
    required this.onTap,
  });

  final int mark;
  final bool hinted;
  final bool won;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final label = mark == TicState.child
        ? 'Cross'
        : mark == TicState.opponent
        ? 'Circle'
        : hinted
        ? 'Empty square. Hint'
        : 'Empty square';
    return Semantics(
      button: enabled,
      label: label,
      child: Material(
        color: won ? SproutColors.primarySoft : SproutColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(SproutRadius.tile),
          ),
          side: BorderSide(
            color: hinted
                ? SproutColors.accent
                : won
                ? SproutColors.primary
                : SproutColors.line,
            width: hinted || won ? 3 : 1.5,
          ),
        ),
        child: InkWell(
          onTap: enabled ? onTap : null,
          child: CustomPaint(
            painter: _MarkPainter(mark),
            child: const SizedBox.expand(),
          ),
        ),
      ),
    );
  }
}

class _MarkPainter extends CustomPainter {
  _MarkPainter(this.mark);

  final int mark;

  @override
  void paint(Canvas canvas, Size size) {
    if (mark == 0) {
      return;
    }
    final paint = Paint()
      ..color = mark == TicState.child
          ? SproutColors.maths
          : SproutColors.retry
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.shortestSide * 0.08
      ..strokeCap = StrokeCap.round;
    final inset = size.shortestSide * 0.22;
    if (mark == TicState.child) {
      canvas.drawLine(
        Offset(inset, inset),
        Offset(size.width - inset, size.height - inset),
        paint,
      );
      canvas.drawLine(
        Offset(size.width - inset, inset),
        Offset(inset, size.height - inset),
        paint,
      );
      return;
    }
    canvas.drawCircle(
      size.center(Offset.zero),
      size.shortestSide * 0.26,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _MarkPainter oldDelegate) {
    return oldDelegate.mark != mark;
  }
}

String ticCheckpointPayload({
  required int seed,
  required int variant,
  required TicState state,
}) {
  return 'v=1;kind=tic;seed=$seed;variant=$variant;cells=${state.cells.join()};turn=${state.childTurn ? 1 : 0};hints=${state.hintsUsed};ply=${state.ply}';
}

TicState? parseTicCheckpoint(
  String payload, {
  required int seed,
  required int variant,
}) {
  final fields = <String, String>{};
  for (final part in payload.split(';')) {
    final split = part.split('=');
    if (split.length == 2) {
      fields[split[0]] = split[1];
    }
  }
  if (fields['kind'] != 'tic' ||
      fields['seed'] != '$seed' ||
      fields['variant'] != '$variant') {
    return null;
  }
  final raw = fields['cells']?.split(',') ?? const [];
  if (raw.length != 9) {
    return null;
  }
  final cells = <int>[];
  for (final item in raw) {
    final value = int.tryParse(item);
    if (value == null || value < 0 || value > 2) {
      return null;
    }
    cells.add(value);
  }
  final hints = int.tryParse(fields['hints'] ?? '');
  final ply = int.tryParse(fields['ply'] ?? '');
  if (hints == null ||
      ply == null ||
      fields['turn'] != '0' && fields['turn'] != '1') {
    return null;
  }
  final opening = ticScenario(variant);
  final line = ticWinningLine(cells);
  final outcome = line != null
      ? (cells[ticLines[line][0]] == TicState.child
            ? TicOutcome.childWin
            : TicOutcome.opponentWin)
      : ticBoardFull(cells)
      ? TicOutcome.draw
      : TicOutcome.ongoing;
  return TicState(
    cells: cells,
    childTurn: fields['turn'] == '1',
    difficulty: opening.difficulty,
    seed: seed,
    opening: List<int>.of(opening.cells),
    openingChildTurn: opening.childTurn,
    ply: ply,
    hintsUsed: hints,
    winLine: line,
    outcome: outcome,
  );
}
