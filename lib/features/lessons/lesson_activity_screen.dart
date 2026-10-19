import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/session_providers.dart';
import '../../core/audio/audio_controller.dart';
import '../../core/audio/speech_fallback.dart';
import '../../core/design_system/sprout_tokens.dart';
import '../../core/design_system/widgets/app_page_scaffold.dart';
import '../../core/design_system/widgets/choice_card.dart';
import '../../core/design_system/widgets/feedback_overlay.dart';
import '../../core/design_system/widgets/game_header.dart';
import '../../core/design_system/widgets/primary_kid_button.dart';
import '../../core/design_system/widgets/sprout_card.dart';
import '../../core/design_system/widgets/status_chip.dart';
import '../../core/design_system/widgets/word_picture.dart';
import '../../domain/lessons/lesson_catalog.dart';
import '../../domain/lessons/lesson_models.dart';
import '../../domain/lessons/tracing.dart';
import '../../domain/lessons/word_builder.dart';
import '../../domain/models/age_band.dart';
import '../../domain/models/content_pack.dart';
import '../../domain/models/readiness.dart';
import '../../domain/games/play/activity_definition.dart';
import '../../domain/games/play/play_checkpoint.dart';
import '../play/open_activity.dart';
import '../play/play_chrome.dart';
import '../play/play_sounds.dart';
import '../play/save_completion.dart';
import 'trace_board.dart';
import 'word_build_board.dart';

class LessonActivityScreen extends ConsumerStatefulWidget {
  const LessonActivityScreen({
    required this.lesson,
    this.catalog,
    this.speech = const UnavailableSpeechFallback(),
    this.journeyDate,
    super.key,
  });

  final LessonRecord lesson;
  final LessonCatalog? catalog;
  final SpeechFallback speech;
  final String? journeyDate;

  @override
  ConsumerState<LessonActivityScreen> createState() =>
      _LessonActivityScreenState();
}

class _LessonActivityScreenState extends ConsumerState<LessonActivityScreen>
    with WidgetsBindingObserver {
  late final LessonCatalog _catalog;
  late final ActivityDefinition _activity;
  late final AudioController _audio;
  TracingSession? _tracing;
  CanvasTransform _transform = const CanvasTransform(1, 1);
  final List<LessonToken> _placed = [];
  String? _buildPrompt;
  String? _selected;
  bool _accepted = false;
  bool _saved = false;
  bool _skipped = false;
  int _wrong = 0;
  int _hints = 0;
  NarrationPlayResult? _audioState;
  SpeechAvailability? _voices;

  LessonRecord get _lesson => widget.lesson;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _audio = ref.read(audioControllerProvider);
    _catalog = widget.catalog ?? LessonCatalog();
    final band = ref.read(sessionProvider).value?.profile?.ageBand ?? AgeBand.c;
    _activity = _catalog.definition(_lesson, band);
    final template = _catalog.templateFor(_lesson);
    final readiness =
        ref.read(sessionProvider).value?.profile?.readiness ?? Readiness.steady;
    if (template != null) {
      _tracing = TracingSession(
        template: template,
        config: TracingConfig.forReadiness(readiness),
      );
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCheckpoint();
      _detectVoices();
    });
  }

  @override
  void dispose() {
    unawaited(_audio.stopNarration());
    unawaited(widget.speech.stop());
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden) {
      unawaited(_audio.stopNarration());
      unawaited(_storeCheckpoint());
    }
  }

  Future<void> _detectVoices() async {
    final voices = await widget.speech.detect();
    if (mounted) {
      setState(() => _voices = voices);
    }
  }

  Future<void> _loadCheckpoint() async {
    String? payload;
    try {
      payload = await loadCheckpoint(ref, _activity.id);
    } catch (_) {
      return;
    }
    if (!mounted || payload == null) {
      return;
    }
    final parsed = parseLessonCheckpoint(payload, lessonId: _lesson.id);
    if (parsed == null) {
      await deleteCheckpoint(ref, _activity.id);
      return;
    }
    _accepted = parsed.accepted;
    _wrong = parsed.wrong;
    _hints = parsed.hints;
    _tracing?.restoreSummary(
      strokesDone: parsed.strokeIndex,
      wasAssisted: parsed.assisted,
      undos: 0,
      retryCount: 0,
    );
    _placed
      ..clear()
      ..addAll([
        for (final id in parsed.placed)
          if (_catalog.token(id) != null) _catalog.token(id)!,
      ]);
    setState(() {});
  }

  Future<void> _storeCheckpoint() async {
    if (_saved) {
      return;
    }
    try {
      await storeCheckpoint(
        ref,
        _activity.id,
        lessonCheckpointPayload(
          lessonId: _lesson.id,
          strokeIndex: _tracing?.strokeIndex ?? 0,
          assisted: (_tracing?.assisted ?? false) || _skipped,
          accepted: _accepted,
          wrong: _wrong,
          hints: _hints,
          placed: [for (final token in _placed) token.id],
        ),
      );
    } catch (_) {}
  }

  Future<void> _playClip(String? id) async {
    if (id == null) {
      return;
    }
    final clip = _catalog.clip(id);
    final result = await _audio.playNarration(id, assetPath: clip?.assetPath);
    if (mounted) {
      setState(() => _audioState = result);
    }
  }

  Future<void> _replay() async {
    if (_lesson.narrationIds.isEmpty && _lesson.wordAudioId == null) {
      return;
    }
    final last = _audio.lastNarrationId;
    if (last != null) {
      final result = await _audio.replayNarration();
      if (mounted) {
        setState(() => _audioState = result);
      }
      return;
    }
    await _playClip(_lesson.wordAudioId ?? _lesson.narrationIds.first);
  }

  Future<void> _finish({required bool skipped}) async {
    if (_saved) {
      return;
    }
    if (skipped) {
      await skipJourneyActivity(ref, _activity.id, widget.journeyDate);
      if (!mounted) return;
      // Leaving a task is not completed learning and earns no reward.
      setState(() => _saved = true);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) Navigator.of(context).pop();
      });
      return;
    }
    _saved = true;
    _skipped = skipped;
    if (skipped) {
      _hints += 1;
    }
    final stars = starsForPlay(wrongCount: _wrong, hintsUsed: _hints);
    await saveFinishedActivity(
      ref,
      activity: _activity,
      hintsUsed: _hints,
      firstAttemptCorrect: _wrong == 0 && _hints == 0 && !skipped,
      stars: stars,
      wrongCount: _wrong,
      journeyDate: widget.journeyDate,
    );
    if (mounted) {
      setState(() => _accepted = true);
    }
  }

  void _choose(String id) {
    if (_accepted || _saved) {
      return;
    }
    final correct = _lesson.correctOptionIds.contains(id);
    setState(() {
      _selected = id;
      if (correct) {
        _accepted = true;
      } else {
        _wrong += 1;
      }
    });
    playFeedback(ref, correct ? FeedbackKind.correct : FeedbackKind.retry);
    if (correct) {
      unawaited(_playClip(_lesson.wordAudioId));
    }
    unawaited(_storeCheckpoint());
  }

  void _addToken(LessonToken token) {
    if (_accepted || _saved) {
      return;
    }
    final word = _catalog.wordFor(_lesson);
    if (word == null) {
      return;
    }
    setState(() {
      _placed.add(token);
      final result = const WordAssembler().evaluate(
        placed: _placed,
        target: word,
        catalog: _catalog.pack.tokens,
      );
      _buildPrompt = result.prompt;
      if (result.state == WordBuildState.correct) {
        _accepted = true;
        playFeedback(ref, FeedbackKind.correct);
        if (result.playWordAudio) {
          unawaited(_playClip(word.wordAudioId));
        }
      } else if (result.state == WordBuildState.invalid) {
        _wrong += 1;
        playFeedback(ref, FeedbackKind.retry);
      }
    });
    unawaited(_storeCheckpoint());
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final finished = _saved;
    return PopScope(
      canPop: finished,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          confirmLeaveActivity(context, finished: finished);
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: PageWidth(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    SproutSpace.page,
                    SproutSpace.sm,
                    SproutSpace.page,
                    0,
                  ),
                  child: GameHeader(
                    title: _lesson.title,
                    activity: _activity,
                    onClose: () =>
                        confirmLeaveActivity(context, finished: finished),
                    progressLabel: _saved
                        ? 'Finished'
                        : _accepted
                        ? 'Ready for next'
                        : 'In play',
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(
                      SproutSpace.page,
                      SproutSpace.md,
                      SproutSpace.page,
                      SproutSpace.lg,
                    ),
                    children: [
                      if (_lesson.reviewStatus != ReviewStatus.approved)
                        const Padding(
                          padding: EdgeInsets.only(bottom: SproutSpace.sm),
                          child: StatusChip(
                            label: 'Development sample',
                            tone: StatusTone.info,
                            icon: Icons.science_rounded,
                          ),
                        ),
                      PlayInstruction(
                        text: _lesson.prompt,
                        detail: _lesson.phrase,
                      ),
                      const SizedBox(height: SproutSpace.md),
                      _LessonVisual(lesson: _lesson, text: text),
                      const SizedBox(height: SproutSpace.md),
                      _audioNote(text),
                      const SizedBox(height: SproutSpace.md),
                      ..._modeBody(text),
                      if (_accepted) ...[
                        const SizedBox(height: SproutSpace.md),
                        const FeedbackOverlay(kind: FeedbackKind.correct),
                      ],
                    ],
                  ),
                ),
                MediaQuery.withClampedTextScaling(
                  maxScaleFactor: 1.4,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      SproutSpace.page,
                      SproutSpace.sm,
                      SproutSpace.page,
                      SproutSpace.md,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (_lesson.mode == LessonMode.trace &&
                            _tracing != null) ...[
                          _traceActions(),
                          const SizedBox(height: SproutSpace.sm),
                        ],
                        PinnedActivityActions(
                          finished: finished,
                          primaryKey: const Key('lesson-next'),
                          fromJourney: widget.journeyDate != null,
                          onHearAgain: _replay,
                          audioUnavailable:
                              _lesson.narrationIds.isEmpty ||
                              _catalog
                                      .clip(_lesson.narrationIds.first)
                                      ?.hasReviewedFile !=
                                  true,
                          onSkip: () => _finish(skipped: true),
                          onHome: () => Navigator.of(context).maybePop(),
                          onPrimary: () async {
                            if (finished) {
                              if (widget.journeyDate != null) {
                                await openNextJourneyActivity(
                                  context,
                                  ref,
                                  activity: _activity,
                                  journeyDate: widget.journeyDate,
                                );
                                return;
                              }
                              Navigator.of(context).maybePop();
                              return;
                            }
                            await _finish(skipped: !_accepted);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _audioNote(TextTheme text) {
    final voices = _voices;
    final missing =
        _audioState == NarrationPlayResult.missing ||
        _audioState == NarrationPlayResult.muted ||
        (_lesson.narrationIds.isNotEmpty &&
            _catalog.clip(_lesson.narrationIds.first)?.hasReviewedFile != true);
    if (!missing && voices?.note == null) {
      return const SizedBox.shrink();
    }
    return Text(
      [
        if (missing) 'Audio unavailable in this preview',
        if (voices?.note != null) voices!.note!,
      ].join(' '),
      style: text.bodyMedium,
    );
  }

  List<Widget> _modeBody(TextTheme text) {
    return switch (_lesson.mode) {
      LessonMode.listen || LessonMode.review => [
        if (_lesson.meaning != null)
          Text(_lesson.meaning!, style: text.bodyLarge),
        if (_lesson.bilingualNote != null) ...[
          const SizedBox(height: SproutSpace.sm),
          Text(_lesson.bilingualNote!, style: text.bodyMedium),
        ],
      ],
      LessonMode.find || LessonMode.match => [
        for (final option in _lesson.options) ...[
          ChoiceCard(
            label: option.label,
            selected: _selected == option.id,
            onPressed: _accepted ? null : () => _choose(option.id),
            leading: option.pictureId == null
                ? null
                : WordPicture(wordId: option.pictureId!, size: 48),
          ),
          const SizedBox(height: 12),
        ],
      ],
      LessonMode.trace => _traceBody(),
      LessonMode.build => [
        WordBuildBoard(
          assembled: const WordAssembler().join(_placed),
          pictureId: _lesson.pictureId,
          meaning: _lesson.meaning,
          bilingualNote: _lesson.bilingualNote,
          bank: [
            for (final id in _lesson.bankTokenIds)
              if (_catalog.token(id) != null) _catalog.token(id)!,
          ],
          placed: _placed,
          prompt: _buildPrompt,
          onAdd: _addToken,
          onUndo: () {
            if (_placed.isEmpty || _accepted) {
              return;
            }
            setState(() {
              _placed.removeLast();
              _buildPrompt = null;
            });
            unawaited(_storeCheckpoint());
          },
        ),
      ],
    };
  }

  List<Widget> _traceBody() {
    final session = _tracing;
    if (session == null) {
      return [const Text('This tracing page is not ready.')];
    }
    return [
      LayoutBuilder(
        builder: (context, constraints) {
          final side = constraints.maxWidth.clamp(160.0, 420.0);
          _transform = CanvasTransform(side, side);
          return TraceBoard(
            session: session,
            transform: _transform,
            onPointerDown: (pointer, local) {
              session.beginPointer(
                pointer,
                _transform.toNormalized(local.dx, local.dy),
              );
              setState(() {});
            },
            onPointerMove: (pointer, local) {
              session.movePointer(
                pointer,
                _transform.toNormalized(local.dx, local.dy),
              );
              setState(() {});
            },
            onPointerUp: (pointer) {
              session.endPointer(pointer);
              if (session.finished) {
                _accepted = true;
                playFeedback(ref, FeedbackKind.correct);
              }
              unawaited(_storeCheckpoint());
              setState(() {});
            },
            onPointerCancel: (pointer) {
              session.cancelPointer(pointer);
              setState(() {});
            },
          );
        },
      ),
      const SizedBox(height: SproutSpace.md),
      Text(
        'This does not mark handwriting. Take your time. There is no clock.',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    ];
  }

  Widget _traceActions() {
    final session = _tracing!;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        SecondaryKidButton(
          label: 'Undo',
          onPressed: () {
            session.undo();
            _accepted = session.finished;
            setState(() {});
            unawaited(_storeCheckpoint());
          },
        ),
        SecondaryKidButton(
          label: 'Try again',
          onPressed: () {
            session.retry();
            _accepted = false;
            setState(() {});
            unawaited(_storeCheckpoint());
          },
        ),
        SecondaryKidButton(
          key: const Key('trace-follow'),
          label: 'Follow the dots',
          onPressed: () {
            session.followActiveStroke();
            _hints += 1;
            if (session.finished) {
              _accepted = true;
            }
            setState(() {});
            unawaited(_storeCheckpoint());
          },
        ),
      ],
    );
  }
}

class _LessonVisual extends StatelessWidget {
  const _LessonVisual({required this.lesson, required this.text});

  final LessonRecord lesson;
  final TextTheme text;

  @override
  Widget build(BuildContext context) {
    return SproutCard(
      color: lesson.category.name == 'hindi'
          ? SproutColors.hindiSurface
          : SproutColors.englishSurface,
      child: Row(
        children: [
          if (lesson.pictureId != null)
            ExcludeSemantics(
              child: WordPicture(wordId: lesson.pictureId!, size: 96),
            ),
          if (lesson.pictureId != null) const SizedBox(width: SproutSpace.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lesson.displayText,
                  style: text.displaySmall?.copyWith(
                    fontFamilyFallback: SproutType.fallback,
                    height: SproutType.devanagariHeight,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (lesson.bilingualNote != null)
                  Text(lesson.bilingualNote!, style: text.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
