import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/design_system/feedback_copy.dart';
import '../../core/design_system/learning_area.dart';
import '../../core/design_system/sprout_tokens.dart';
import '../../core/design_system/widgets/choice_card.dart';
import '../../core/design_system/widgets/feedback_overlay.dart';
import '../../core/design_system/widgets/game_header.dart';
import '../../core/design_system/widgets/play_visual_view.dart';
import '../../core/design_system/widgets/primary_kid_button.dart';
import '../../core/design_system/widgets/sprout_card.dart';
import '../../domain/games/hints/hint_stage.dart';
import '../../domain/games/play/activity_catalog.dart';
import '../../domain/games/play/activity_definition.dart';
import '../../domain/games/play/activity_session.dart';
import '../../domain/games/play/play_checkpoint.dart';
import '../../domain/games/play/play_question.dart';
import '../../domain/scoring/activity_score.dart';
import 'open_activity.dart';
import 'play_chrome.dart';
import 'play_sounds.dart';
import 'save_completion.dart';

class ActivityScreen extends ConsumerStatefulWidget {
  const ActivityScreen({
    required this.activity,
    this.journeyDate,
    this.idleAfter = const Duration(seconds: 30),
    super.key,
  });

  final ActivityDefinition activity;
  final String? journeyDate;
  final Duration idleAfter;

  @override
  ConsumerState<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends ConsumerState<ActivityScreen>
    with WidgetsBindingObserver {
  late final ActivitySession _session;
  Timer? _idle;
  bool _saved = false;
  bool _paused = false;
  bool _ready = false;
  bool _taught = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    final questions = const ActivityCatalog().questionsFor(widget.activity);
    _session = ActivitySession(
      definition: widget.activity,
      questions: questions,
    );
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
    if (_paused || _session.finished) {
      return;
    }
    _idle = Timer(widget.idleAfter, () {
      if (!mounted) {
        return;
      }
      setState(_session.noteInactivity);
    });
  }

  Future<void> _saveIfFinished() async {
    if (!_session.finished || _saved) {
      return;
    }
    _saved = true;
    final result = _session.result();
    await saveFinishedActivity(
      ref,
      activity: widget.activity,
      hintsUsed: result.hintsUsed,
      firstAttemptCorrect: result.firstAttemptCorrect,
      stars: result.stars,
      wrongCount: _session.totalWrong,
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
        : parseChoiceCheckpoint(
            payload,
            seed: widget.activity.seed,
            generatorVersion: _session.generatorVersion,
            questionCount: _session.questions.length,
          );
    if (payload != null && parsed == null) {
      await deleteCheckpoint(ref, widget.activity.id);
    }
    if (parsed != null) {
      _session.restore(parsed);
    }
    if (mounted) {
      setState(() => _ready = true);
    }
  }

  Future<void> _storeCheckpoint() async {
    if (!_ready || _session.finished || _saved) {
      return;
    }
    await storeCheckpoint(
      ref,
      widget.activity.id,
      choiceCheckpointPayload(
        seed: widget.activity.seed,
        generatorVersion: _session.generatorVersion,
        state: _session.choiceCheckpoint,
      ),
    );
  }

  void _choose(String choiceId) {
    if (_session.finished || _saved) {
      return;
    }
    final correct = _session.submit(choiceId);
    final last = _session.index == _session.questions.length - 1;
    if (correct && last) {
      _session.advance();
      _saveIfFinished();
    } else {
      playFeedback(ref, correct ? FeedbackKind.correct : FeedbackKind.retry);
      _storeCheckpoint();
    }
    setState(() {});
    _armIdle();
  }

  Future<void> _advance() async {
    final finished = _session.advance();
    if (finished) {
      await _saveIfFinished();
    } else {
      _taught = false;
      await _storeCheckpoint();
    }
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _openNext() {
    return openNextJourneyActivity(
      context,
      ref,
      activity: widget.activity,
      journeyDate: widget.journeyDate,
    );
  }

  Future<void> _requestLeave() async {
    if (_session.finished) {
      if (mounted) {
        Navigator.of(context).pop();
      }
      return;
    }
    final leave = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Leave this activity?'),
          content: const Text(
            'You can come back later. Leaving does not finish it.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Stay'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Leave'),
            ),
          ],
        );
      },
    );
    if (leave == true && mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final question = _session.current;
    final stage = _session.hintStage;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _requestLeave();
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: !_ready
              ? const Center(child: CircularProgressIndicator())
              : _session.finished
              ? FinishedBanner(
                  stars: scoreRound(
                    category: widget.activity.category,
                    wrongCount: _session.totalWrong,
                    hintsUsed: _session.result().hintsUsed,
                  ).stars,
                  points: scoreRound(
                    category: widget.activity.category,
                    wrongCount: _session.totalWrong,
                    hintsUsed: _session.result().hintsUsed,
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
                  onNext: widget.journeyDate == null ? null : _openNext,
                  onDone: () => Navigator.of(context).pop(),
                )
              : LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      padding: const EdgeInsets.all(SproutSpace.md),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight - SproutSpace.md * 2,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            GameHeader(
                              title: activityHeaderTitle(widget.activity),
                              activity: widget.activity,
                              onClose: _requestLeave,
                              progress:
                                  (_session.index +
                                      (_session.acceptedCurrent ? 1 : 0)) /
                                  _session.questions.length,
                              progressLabel:
                                  'Question ${_session.index + 1} of ${_session.questions.length}',
                            ),
                            const SizedBox(height: SproutSpace.md),
                            if (question.teaching.isNotEmpty && !_taught) ...[
                              SproutCard(
                                child: Text(
                                  question.teaching,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ),
                              const SizedBox(height: SproutSpace.md),
                              PrimaryKidButton(
                                label: 'Let’s try',
                                onPressed: () => setState(() => _taught = true),
                              ),
                            ] else ...[
                            SproutCard(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    question.prompt,
                                    style: Theme.of(context).textTheme.titleLarge,
                                  ),
                                  if (question.promptVisuals.isNotEmpty) ...[
                                    const SizedBox(height: SproutSpace.md),
                                    PromptVisualRow(
                                      visuals: question.promptVisuals,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            if (_session.instructionPulsed) ...[
                              const SizedBox(height: SproutSpace.sm),
                              Text(
                                question.prompt,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                            const SizedBox(height: SproutSpace.md),
                            for (final choice in question.choices) ...[
                              ChoiceCard(
                                key: ValueKey(choice.id),
                                label: choice.label,
                                selected:
                                    _session.acceptedCurrent &&
                                    choice.id == question.correctId,
                                highlighted:
                                    stage == HintStage.strongerHint &&
                                    choice.id == question.correctId,
                                leading: PlayVisualView(
                                  visual: choice.visual,
                                  size: choice.visual is WordPictureVisual
                                      ? 64
                                      : 36,
                                ),
                                showText: choice.showText,
                                onPressed: _session.acceptedCurrent
                                    ? null
                                    : () => _choose(choice.id),
                              ),
                              const SizedBox(height: SproutSpace.sm),
                            ],
                            if (stage == HintStage.retryOnly)
                              const FeedbackOverlay(kind: FeedbackKind.retry),
                            if (stage == HintStage.firstHint ||
                                stage == HintStage.strongerHint)
                              _HintBanner(
                                message: stage == HintStage.firstHint
                                    ? question.firstHint
                                    : question.strongerHint,
                              ),
                            if (_session.acceptedCurrent) ...[
                              const SizedBox(height: SproutSpace.sm),
                              const FeedbackOverlay(kind: FeedbackKind.correct),
                              const SizedBox(height: SproutSpace.md),
                              PrimaryKidButton(
                                label:
                                    _session.index + 1 ==
                                        _session.questions.length
                                    ? 'Finish'
                                    : 'Next',
                                onPressed: _advance,
                              ),
                            ],
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}

class _HintBanner extends StatelessWidget {
  const _HintBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      label: '${FeedbackCopy.hint} $message',
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: SproutColors.englishSurface,
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          border: Border.all(color: SproutColors.accent),
        ),
        child: Padding(
          padding: const EdgeInsets.all(SproutSpace.md),
          child: Row(
            children: [
              const Icon(Icons.lightbulb_outline_rounded, color: SproutColors.accent),
              const SizedBox(width: SproutSpace.sm),
              Expanded(
                child: Text(
                  message,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
