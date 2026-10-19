import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/design_system/sprout_tokens.dart';
import '../../core/design_system/widgets/feedback_overlay.dart';
import '../../core/design_system/widgets/game_header.dart';
import '../../domain/games/find_objects/find_objects_catalog.dart';
import '../../domain/games/hints/hint_stage.dart';
import '../../domain/games/play/activity_definition.dart';
import '../../domain/games/play/play_checkpoint.dart';
import '../../domain/scoring/activity_score.dart';
import 'find_objects_scene_view.dart';
import 'open_activity.dart';
import 'play_chrome.dart';
import 'play_sounds.dart';
import 'save_completion.dart';

class FindObjectsScreen extends ConsumerStatefulWidget {
  const FindObjectsScreen({
    required this.activity,
    this.journeyDate,
    this.idleAfter = const Duration(seconds: 30),
    super.key,
  });

  final ActivityDefinition activity;
  final String? journeyDate;
  final Duration idleAfter;

  @override
  ConsumerState<FindObjectsScreen> createState() => _FindObjectsScreenState();
}

class _FindObjectsScreenState extends ConsumerState<FindObjectsScreen>
    with WidgetsBindingObserver {
  final _catalog = const FindObjectsCatalog();
  late final FindObjectScene _scene;
  late final List<FindObjectTarget> _targets;
  late final double _pad;
  final _found = <String>{};
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
    _targets = _catalog.targetsFor(widget.activity.band, widget.activity.variant);
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

  String? get _hintId {
    final stage = hintStageForWrongCount(_wrong);
    if (stage != HintStage.firstHint && stage != HintStage.strongerHint) {
      return null;
    }
    for (final target in _targets) {
      if (!_found.contains(target.id)) {
        return target.id;
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
      targets: _targets,
      found: _found,
      pad: _pad,
    );
    if (hit.missed) {
      playFeedback(ref, FeedbackKind.retry);
      setState(() {
        _wrong++;
        _noteHints();
        _pulse = false;
        _kind = hintStageForWrongCount(_wrong) == HintStage.retryOnly
            ? FeedbackKind.retry
            : FeedbackKind.hint;
      });
      _storeCheckpoint();
      _armIdle();
      return;
    }
    if (hit.alreadyFound) {
      setState(() => _pulse = false);
      _armIdle();
      return;
    }
    setState(() {
      _found.add(hit.objectId!);
      _pulse = false;
      _kind = FeedbackKind.correct;
      if (_found.length == _targets.length) {
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
            generatorVersion: FindObjectsCatalog.generatorVersion,
            kind: 'find_objects',
          );
    final known = _targets.map((target) => target.id).toSet();
    final safe =
        parsed != null && parsed.marked.every((id) => known.contains(id));
    if (payload != null && !safe) {
      await deleteCheckpoint(ref, widget.activity.id);
    } else if (safe) {
      _found
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
        generatorVersion: FindObjectsCatalog.generatorVersion,
        state: BoardCheckpoint(
          kind: 'find_objects',
          marked: _found.toList(),
          wrong: _wrong,
          hintsUsed: _hintsUsed,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                      progress: _targets.isEmpty
                          ? 0
                          : _found.length / _targets.length,
                      progressLabel:
                          'Found ${_found.length} of ${_targets.length}',
                    ),
                    PlayInstruction(
                      text: 'Find ${_targets.length} things in the picture.',
                      detail: _pulse ? 'Look at the cards, then tap the picture.' : null,
                    ),
                    const SizedBox(height: SproutSpace.sm),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final target in _targets)
                          _TargetCard(
                            label: target.label,
                            found: _found.contains(target.id),
                          ),
                      ],
                    ),
                    if (_kind != null) ...[
                      const SizedBox(height: SproutSpace.sm),
                      FeedbackOverlay(kind: _kind!),
                    ],
                    const SizedBox(height: SproutSpace.md),
                    FindObjectsSceneView(
                      sceneId: _scene.id,
                      targets: _targets,
                      found: _found,
                      hintId: _hintId,
                      strongHint: strong,
                      onTapNormalized: _tap,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class _TargetCard extends StatelessWidget {
  const _TargetCard({required this.label, required this.found});

  final String label;
  final bool found;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: found ? const Color(0xFFDCEFE3) : SproutColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: found ? const Color(0xFF2F7D4A) : SproutColors.line,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Text(
          label,
          style: Theme.of(context).textTheme.titleSmall,
        ),
      ),
    );
  }
}
