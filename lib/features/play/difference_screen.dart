import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/design_system/sprout_tokens.dart';
import '../../core/design_system/widgets/feedback_overlay.dart';
import '../../core/design_system/widgets/game_header.dart';
import '../../domain/games/find_difference/difference_catalog.dart';
import '../../domain/games/hints/hint_stage.dart';
import '../../domain/games/play/activity_definition.dart';
import '../../domain/games/play/play_checkpoint.dart';
import '../../domain/scoring/activity_score.dart';
import 'difference_scene_view.dart';
import 'open_activity.dart';
import 'play_chrome.dart';
import 'play_sounds.dart';
import 'save_completion.dart';

class DifferenceScreen extends ConsumerStatefulWidget {
  const DifferenceScreen({
    required this.activity,
    this.journeyDate,
    this.idleAfter = const Duration(seconds: 30),
    super.key,
  });

  final ActivityDefinition activity;
  final String? journeyDate;
  final Duration idleAfter;

  @override
  ConsumerState<DifferenceScreen> createState() => _DifferenceScreenState();
}

class _DifferenceScreenState extends ConsumerState<DifferenceScreen>
    with WidgetsBindingObserver {
  final _catalog = const DifferenceCatalog();
  late final DifferenceScene _scene;
  late final List<DifferenceSpot> _active;
  late final double _pad;
  final _marked = <String>{};
  Timer? _idle;
  bool _paused = false;
  bool _saved = false;
  bool _finished = false;
  bool _ready = false;
  bool _pulse = false;
  int _wrong = 0;
  int _hintsUsed = 0;
  FeedbackKind? _kind;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _scene = _catalog.sceneFor(widget.activity.variant);
    _active = _catalog.activeSpots(
      widget.activity.band,
      widget.activity.variant,
    );
    _pad = _catalog.padFor(widget.activity.band);
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

  String? get _hintSpotId {
    final stage = hintStageForWrongCount(_wrong);
    if (stage != HintStage.firstHint && stage != HintStage.strongerHint) {
      return null;
    }
    for (final spot in _active) {
      if (!_marked.contains(spot.id)) {
        return spot.id;
      }
    }
    return null;
  }

  void _noteHints() {
    final stage = hintStageForWrongCount(_wrong);
    if (stage == HintStage.firstHint && _hintsUsed < 1) {
      _hintsUsed = 1;
    } else if (stage == HintStage.strongerHint) {
      _hintsUsed = 2;
    }
  }

  void _tap(Offset point) {
    if (_finished) {
      return;
    }
    final hit = _catalog.hitTest(
      point: point,
      active: _active,
      marked: _marked,
      pad: _pad,
    );
    if (hit.missed) {
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
      return;
    }
    if (hit.alreadyMarked) {
      setState(() => _pulse = false);
      _armIdle();
      return;
    }
    setState(() {
      _marked.add(hit.spotId!);
      _pulse = false;
      _kind = FeedbackKind.correct;
      if (_marked.length == _active.length) {
        _finished = true;
      }
    });
    if (_finished) {
      _save();
    } else {
      playFeedback(ref, FeedbackKind.correct);
      _storeCheckpoint();
    }
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
            generatorVersion: 'find_difference:v1',
            kind: 'difference',
          );
    final known = _active.map((spot) => spot.id).toSet();
    final safe =
        parsed != null && parsed.marked.every((id) => known.contains(id));
    if (payload != null && !safe) {
      await deleteCheckpoint(ref, widget.activity.id);
    } else if (safe) {
      _marked
        ..clear()
        ..addAll(parsed.marked);
      _wrong = parsed.wrong;
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
        generatorVersion: 'find_difference:v1',
        state: BoardCheckpoint(
          kind: 'difference',
          marked: _marked.toList(),
          wrong: _wrong,
          hintsUsed: _hintsUsed,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 700;
    final strong = hintStageForWrongCount(_wrong) == HintStage.strongerHint;
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
              : ListView(
                  padding: const EdgeInsets.all(SproutSpace.md),
                  children: [
                    GameHeader(
                      title: widget.activity.title,
                      activity: widget.activity,
                      onClose: () =>
                          confirmLeaveActivity(context, finished: _finished),
                      progress: _active.isEmpty
                          ? 0
                          : _marked.length / _active.length,
                      progressLabel:
                          'Found ${_marked.length} of ${_active.length}',
                    ),
                    PlayInstruction(
                      text:
                          'Find ${_active.length} differences. Tap the picture that changed.',
                      detail: _pulse
                          ? 'Look carefully at both pictures.'
                          : null,
                    ),
                    if (_kind != null) ...[
                      const SizedBox(height: SproutSpace.sm),
                      FeedbackOverlay(kind: _kind!),
                    ],
                    const SizedBox(height: SproutSpace.md),
                    if (wide)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: _pair(strong, 'Original')),
                          const SizedBox(width: SproutSpace.md),
                          Expanded(
                            child: _pair(strong, 'Changed', altered: true),
                          ),
                        ],
                      )
                    else ...[
                      _pair(strong, 'Original'),
                      const SizedBox(height: SproutSpace.md),
                      _pair(strong, 'Changed', altered: true),
                    ],
                  ],
                ),
        ),
      ),
    );
  }

  Widget _pair(bool strong, String label, {bool altered = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: SproutSpace.xs),
        DifferenceSceneView(
          sceneId: _scene.id,
          altered: altered,
          spots: _active,
          marked: _marked,
          hintSpotId: altered ? _hintSpotId : null,
          strongHint: strong,
          onTapNormalized: _tap,
        ),
      ],
    );
  }
}
