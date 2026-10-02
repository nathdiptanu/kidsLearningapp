import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/session_providers.dart';
import '../../core/audio/audio_controller.dart';
import '../../core/design_system/sprout_tokens.dart';
import '../../core/design_system/widgets/app_page_scaffold.dart';
import '../../core/design_system/widgets/choice_card.dart';
import '../../core/design_system/widgets/feedback_overlay.dart';
import '../../core/design_system/widgets/game_header.dart';
import '../../core/design_system/widgets/sprout_card.dart';
import '../../core/design_system/widgets/status_chip.dart';
import '../../domain/geography/geography_models.dart';
import '../../domain/geography/map_geometry.dart';
import '../../domain/games/play/activity_definition.dart';
import '../../domain/heritage/heritage_catalog.dart';
import '../../domain/heritage/heritage_engine.dart';
import '../../domain/heritage/heritage_models.dart';
import '../../domain/models/age_band.dart';
import '../../domain/models/content_pack.dart';
import '../../domain/models/readiness.dart';
import '../../domain/regional/learning_preferences.dart';
import '../geography/india_map.dart';
import '../play/open_activity.dart';
import '../play/play_chrome.dart';
import '../play/play_sounds.dart';
import '../play/save_completion.dart';
import 'heritage_picture.dart';

class HeritageActivityScreen extends ConsumerStatefulWidget {
  const HeritageActivityScreen({
    required this.activity,
    this.catalog,
    this.atlas,
    this.journeyDate,
    super.key,
  });

  final HeritageActivity activity;
  final HeritageCatalog? catalog;
  final IndiaMapAtlas? atlas;
  final String? journeyDate;

  @override
  ConsumerState<HeritageActivityScreen> createState() =>
      _HeritageActivityScreenState();
}

class _HeritageActivityScreenState
    extends ConsumerState<HeritageActivityScreen> {
  late final HeritageCatalog _catalog;
  late final ActivityDefinition _definition;
  late final AudioController _audio;
  IndiaMapAtlas? _atlas;
  HeritageQuestion? _question;
  String? _answerId;
  bool _accepted = false;
  bool _saved = false;
  int _wrong = 0;
  int _hints = 0;

  HeritageActivity get _activity => widget.activity;

  @override
  void initState() {
    super.initState();
    _audio = ref.read(audioControllerProvider);
    _catalog = widget.catalog ?? HeritageCatalog();
    final band = ref.read(sessionProvider).value?.profile?.ageBand ?? AgeBand.c;
    _definition = _catalog.definition(_activity, band);
    _atlas = widget.atlas;
    _prepareQuestion();
    if (_atlas == null && _activity.mode == HeritageMode.story) {
      unawaited(_loadAtlas());
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_play());
    });
  }

  Future<void> _loadAtlas() async {
    try {
      final raw = await rootBundle.loadString(
        'assets/content/geography/slice_geometry.json',
      );
      final atlas = atlasFromJson(jsonDecode(raw) as Map<String, dynamic>);
      if (mounted) {
        setState(() => _atlas = atlas);
      }
    } catch (_) {}
  }

  void _prepareQuestion() {
    final session = ref.read(sessionProvider).value;
    final band = session?.profile?.ageBand ?? AgeBand.c;
    final readiness = session?.profile?.readiness ?? Readiness.steady;
    final progress = ref.read(progressListProvider).value ?? const [];
    final completed = [
      for (final row in progress)
        if (row.completed) row.activityId,
    ];
    final identified = identifiedHeritageFrom(completed);
    final stories = heritageStoriesFrom(completed);
    if (_activity.siteId != null) {
      identified.add(_activity.siteId!);
    }
    final engine = const HeritageQuestionEngine();
    final site = _catalog.site(_activity.siteId);
    setState(() {
      _question = switch (_activity.mode) {
        HeritageMode.identify when site != null => engine.identify(
          pack: _catalog.pack,
          site: site,
          band: band,
          readiness: readiness,
        ),
        HeritageMode.match when site != null => engine.match(
          pack: _catalog.pack,
          site: site,
          band: band,
          readiness: readiness,
        ),
        HeritageMode.locate when site != null => engine.locate(
          pack: _catalog.pack,
          site: site,
          introducedSiteIds: identified,
          band: band,
          readiness: readiness,
        ),
        HeritageMode.recall => engine.recall(
          pack: _catalog.pack,
          introducedSiteIds: stories,
          band: band,
          readiness: readiness,
        ),
        _ => null,
      };
    });
  }

  Future<void> _play() async {
    final id =
        _activity.narrationId ?? _catalog.site(_activity.siteId)?.narrationId;
    if (id == null) {
      return;
    }
    await _audio.playNarration(id);
  }

  Future<void> _finish({required bool skipped}) async {
    if (_saved) {
      return;
    }
    _saved = true;
    if (skipped) {
      _hints += 1;
    }
    await saveFinishedActivity(
      ref,
      activity: _definition,
      hintsUsed: _hints,
      firstAttemptCorrect: _wrong == 0 && _hints == 0 && !skipped,
      stars: starsForPlay(wrongCount: _wrong, hintsUsed: _hints),
      wrongCount: _wrong,
      journeyDate: widget.journeyDate,
    );
    if (mounted) {
      setState(() => _accepted = true);
    }
  }

  void _choose(String id) {
    if (_accepted || _saved || _question == null) {
      return;
    }
    final correct = const HeritageQuestionEngine().accepts(_question!, id);
    setState(() {
      _answerId = id;
      if (correct) {
        _accepted = true;
      } else {
        _wrong += 1;
      }
    });
    playFeedback(ref, correct ? FeedbackKind.correct : FeedbackKind.retry);
  }

  @override
  void dispose() {
    unawaited(_audio.stopNarration());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final finished = _saved;
    final text = Theme.of(context).textTheme;
    final site = _catalog.site(_activity.siteId ?? _question?.siteId);
    final teaching =
        ref.watch(sessionProvider).value?.settings.teachingLanguage ??
        TeachingLanguage.english;
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
                    title: _activity.title,
                    activity: _definition,
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
                      if (_activity.reviewStatus != ReviewStatus.approved)
                        const Padding(
                          padding: EdgeInsets.only(bottom: SproutSpace.sm),
                          child: StatusChip(
                            label: 'Development sample',
                            tone: StatusTone.info,
                            icon: Icons.science_rounded,
                          ),
                        ),
                      PlayInstruction(text: _activity.prompt),
                      const SizedBox(height: SproutSpace.md),
                      if (_activity.mode == HeritageMode.match &&
                          site != null) ...[
                        const SizedBox(height: SproutSpace.md),
                        Center(
                          child: HeritagePicture(
                            pictureId: site.pictureId,
                            size: 140,
                          ),
                        ),
                      ],
                      if (_activity.mode == HeritageMode.story && site != null)
                        ..._siteCard(site, text, teaching),
                      if (_question != null) ...[
                        const SizedBox(height: SproutSpace.md),
                        Text(_question!.prompt, style: text.titleMedium),
                        const SizedBox(height: SproutSpace.sm),
                        for (final choice in _question!.choices) ...[
                          ChoiceCard(
                            label: choice.label,
                            selected: _answerId == choice.id,
                            showText: _activity.mode != HeritageMode.match,
                            leading: choice.pictureId == null
                                ? null
                                : HeritagePicture(
                                    pictureId: choice.pictureId!,
                                    size: 56,
                                  ),
                            onPressed: _accepted
                                ? null
                                : () => _choose(choice.id),
                          ),
                          const SizedBox(height: 12),
                        ],
                      ],
                      if (_accepted)
                        const FeedbackOverlay(kind: FeedbackKind.correct),
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
                        PinnedActivityActions(
                        finished: finished,
                        primaryKey: const Key('heritage-next'),
                        fromJourney: widget.journeyDate != null,
                        onHearAgain: _play,
                        onSkip: () => _finish(skipped: true),
                        onHome: () => Navigator.of(context).maybePop(),
                        onPrimary: () async {
                          if (finished) {
                            if (widget.journeyDate != null) {
                              await openNextJourneyActivity(
                                context,
                                ref,
                                activity: _definition,
                                journeyDate: widget.journeyDate,
                              );
                              return;
                            }
                            Navigator.of(context).maybePop();
                            return;
                          }
                          final teach = _activity.mode == HeritageMode.story;
                          await _finish(skipped: teach ? false : !_accepted);
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

  List<Widget> _siteCard(
    HeritageSite site,
    TextTheme text,
    TeachingLanguage teaching,
  ) {
    final atlas = _atlas;
    return [
      SproutCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: HeritagePicture(pictureId: site.pictureId, size: 160)),
            const SizedBox(height: SproutSpace.md),
            Text(site.name, style: text.headlineMedium),
            if (teaching.includesHindi && site.hindiName != null)
              Text(
                site.hindiName!,
                style: text.headlineSmall?.copyWith(
                  fontFamilyFallback: SproutType.fallback,
                  height: SproutType.devanagariHeight,
                ),
              ),
            Text(site.regionHint, style: text.bodyLarge),
            const SizedBox(height: SproutSpace.sm),
            Text(site.fact.text, style: text.bodyLarge),
            if (_activity.mode == HeritageMode.story)
              for (final line in site.story) ...[
                const SizedBox(height: SproutSpace.md),
                StatusChip(
                  label: line.kindLabel,
                  tone: line.kind == HeritageStatementKind.history
                      ? StatusTone.info
                      : StatusTone.inProgress,
                ),
                const SizedBox(height: SproutSpace.xs),
                Text(line.text, style: text.bodyLarge),
              ],
          ],
        ),
      ),
      if (atlas != null) ...[
        const SizedBox(height: SproutSpace.md),
        IndiaMapView(
          atlas: atlas,
          highlightedIds: {site.mapRegionId},
          selectedId: site.mapRegionId,
          height: 200,
        ),
      ],
    ];
  }
}
