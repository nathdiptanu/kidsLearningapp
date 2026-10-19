import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/design_system/sprout_tokens.dart';
import '../../core/design_system/widgets/app_page_scaffold.dart';
import '../../core/design_system/widgets/feedback_overlay.dart';
import '../../core/design_system/widgets/game_header.dart';
import '../../domain/games/hints/hint_stage.dart';
import '../../domain/games/maze/maze_generator.dart';
import '../../domain/games/play/activity_definition.dart';
import '../../domain/games/play/play_checkpoint.dart';
import '../../domain/models/age_band.dart';
import 'maze_board.dart';
import 'maze_palette.dart';
import '../../core/design_system/widgets/primary_kid_button.dart';
import 'open_activity.dart';
import '../../domain/scoring/activity_score.dart';
import 'play_chrome.dart';
import 'play_sounds.dart';
import 'save_completion.dart';

class MazeScreen extends ConsumerStatefulWidget {
  const MazeScreen({
    required this.activity,
    this.journeyDate,
    this.idleAfter = const Duration(seconds: 30),
    super.key,
  });

  final ActivityDefinition activity;
  final String? journeyDate;
  final Duration idleAfter;

  @override
  ConsumerState<MazeScreen> createState() => _MazeScreenState();
}

class _MazeScreenState extends ConsumerState<MazeScreen>
    with WidgetsBindingObserver {
  late final MazeLevel _maze;
  late MazePoint _player;
  Timer? _idle;
  bool _paused = false;
  bool _saved = false;
  bool _finished = false;
  bool _ready = false;
  bool _pulse = false;
  int _wrong = 0;
  int _hintsUsed = 0;
  FeedbackKind? _kind;
  MazePoint? _dragMissCell;
  Set<MazePoint> _visited = {const MazePoint(0, 0)};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _maze = const MazeGenerator().generate(
      band: widget.activity.band,
      seed: widget.activity.seed,
      variant: widget.activity.variant,
    );
    _player = _maze.start;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCheckpoint();
    });
    _armIdle();
  }

  @override
  void dispose() {
    _idle?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _paused = true;
      _idle?.cancel();
      _storeCheckpoint();
    } else if (state == AppLifecycleState.resumed) {
      _paused = false;
      _armIdle();
    }
  }

  void _armIdle() {
    _idle?.cancel();
    if (_paused || _finished) {
      return;
    }
    _idle = Timer(widget.idleAfter, () {
      if (!mounted) {
        return;
      }
      setState(() => _pulse = true);
    });
  }

  MazePoint? _hintPlayer;
  int? _hintWrong;
  int? _hintUsed;
  List<MazePoint> _hintCache = const [];

  List<MazePoint> get _hintCells {
    if (_hintPlayer == _player &&
        _hintWrong == _wrong &&
        _hintUsed == _hintsUsed) {
      return _hintCache;
    }
    final stage = hintStageForWrongCount(_wrong);
    final cells = switch (stage) {
      HintStage.firstHint => _maze.stepsTowardGoal(_player, 1),
      HintStage.strongerHint => _maze.stepsTowardGoal(_player, 3),
      HintStage.none || HintStage.retryOnly =>
        _hintsUsed > 0
            ? _maze.stepsTowardGoal(_player, 1)
            : const <MazePoint>[],
    };
    _hintPlayer = _player;
    _hintWrong = _wrong;
    _hintUsed = _hintsUsed;
    _hintCache = cells;
    return cells;
  }

  void _noteHints() {
    final stage = hintStageForWrongCount(_wrong);
    if (stage == HintStage.firstHint) {
      _hintsUsed = _hintsUsed < 1 ? 1 : _hintsUsed;
    } else if (stage == HintStage.strongerHint) {
      _hintsUsed = 2;
    }
  }

  void _tryMove(MazePoint target, {required bool fromDrag}) {
    if (_finished || target == _player) {
      return;
    }
    if (_maze.canStep(_player, target)) {
      _dragMissCell = null;
      setState(() {
        _player = target;
        _visited = {..._visited, target};
        _kind = null;
        _pulse = false;
        if (_player == _maze.goal) {
          _finished = true;
          _kind = FeedbackKind.correct;
        }
      });
      if (_finished) {
        _save();
      } else {
        _storeCheckpoint();
      }
      _armIdle();
      return;
    }
    final adjacent =
        (target.row - _player.row).abs() + (target.col - _player.col).abs() ==
        1;
    if (!adjacent) {
      return;
    }
    if (fromDrag && _dragMissCell == target) {
      return;
    }
    _dragMissCell = fromDrag ? target : null;
    playFeedback(ref, FeedbackKind.retry);
    setState(() {
      _wrong++;
      _noteHints();
      _pulse = false;
      final stage = hintStageForWrongCount(_wrong);
      if (stage == HintStage.retryOnly) {
        _kind = FeedbackKind.retry;
      } else {
        _kind = FeedbackKind.hint;
      }
    });
    _storeCheckpoint();
    _armIdle();
  }

  Future<void> _save() async {
    if (!_finished || _saved) {
      return;
    }
    _saved = true;
    await saveFinishedActivity(
      ref,
      activity: widget.activity,
      hintsUsed: _hintsUsed,
      firstAttemptCorrect: _wrong == 0 && _hintsUsed == 0,
      stars: starsForPlay(wrongCount: _wrong, hintsUsed: _hintsUsed),
      wrongCount: _wrong,
      journeyDate: widget.journeyDate,
    );
  }

  Future<void> _loadCheckpoint() async {
    final payload = await loadCheckpoint(ref, widget.activity.id);
    if (!mounted) {
      return;
    }
    final parsed = payload == null
        ? null
        : parseBoardCheckpoint(
            payload,
            seed: widget.activity.seed,
            generatorVersion: MazeGenerator.generatorVersion,
            kind: 'maze',
          );
    final restored = parsed == null ? null : MazePoint(parsed.row, parsed.col);
    if (payload != null &&
        (parsed == null || restored == null || !_maze.contains(restored))) {
      await deleteCheckpoint(ref, widget.activity.id);
    } else if (restored != null) {
      _player = restored;
      _visited = {_maze.start, restored};
      _wrong = parsed!.wrong;
      _hintsUsed = parsed.hintsUsed;
    }
    if (mounted) {
      setState(() => _ready = true);
    }
  }

  Future<void> _storeCheckpoint() async {
    if (!_ready || _finished || _saved) {
      return;
    }
    await storeCheckpoint(
      ref,
      widget.activity.id,
      boardCheckpointPayload(
        seed: widget.activity.seed,
        generatorVersion: MazeGenerator.generatorVersion,
        state: BoardCheckpoint(
          kind: 'maze',
          row: _player.row,
          col: _player.col,
          wrong: _wrong,
          hintsUsed: _hintsUsed,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 700;
    final garden = MazePalette.forVariant(widget.activity.variant);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          confirmLeaveActivity(context, finished: _finished);
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: !_ready
              ? const Center(child: CircularProgressIndicator())
              : _finished
              ? FinishedBanner(
                  headline: 'You found the flower! Lovely exploring.',
                  stars: scoreRound(
                    category: widget.activity.category,
                    wrongCount: _wrong,
                    hintsUsed: _hintsUsed,
                  ).stars,
                  points: scoreRound(
                    category: widget.activity.category,
                    wrongCount: _wrong,
                    hintsUsed: _hintsUsed,
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
                        onClose: () =>
                            confirmLeaveActivity(context, finished: _finished),
                      ),
                      PlayInstruction(
                        text: widget.activity.band == AgeBand.a
                            ? 'Help your smiling friend reach the flower. Tap the next open square.'
                            : 'Help your smiling friend find a path to the flower.',
                        detail: _pulse
                            ? 'Take your time. Tap an open square beside your friend.'
                            : _wrong > 0
                            ? 'Every explorer tries different paths. You can do it!'
                            : 'Take your time. Each little step is an adventure!',
                      ),
                      const SizedBox(height: SproutSpace.sm),
                      Row(
                        children: [
                          Icon(garden.icon, color: garden.wall),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              garden.name,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                        ],
                      ),
                      if (_kind != null) ...[
                        const SizedBox(height: SproutSpace.sm),
                        FeedbackOverlay(kind: _kind!),
                      ],
                      const SizedBox(height: SproutSpace.md),
                      Center(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: wide ? 560 : 420,
                          ),
                          child: MazeBoard(
                            variant: widget.activity.variant,
                            visitedCells: _visited,
                            maze: _maze,
                            player: _player,
                            hintCells: _hintCells,
                            onTapCell: (cell) =>
                                _tryMove(cell, fromDrag: false),
                            onDragCell: (cell) =>
                                _tryMove(cell, fromDrag: true),
                          ),
                        ),
                      ),
                      const SizedBox(height: SproutSpace.md),
                      SecondaryKidButton(
                        label: 'Show a little clue',
                        trailingIcon: Icons.lightbulb_outline_rounded,
                        onPressed: () {
                          setState(() {
                            _hintsUsed = _hintsUsed < 1 ? 1 : _hintsUsed;
                            _kind = FeedbackKind.hint;
                          });
                          _storeCheckpoint();
                        },
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
