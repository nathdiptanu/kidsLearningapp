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
import '../../domain/geography/geography_catalog.dart';
import '../../domain/geography/geography_models.dart';
import '../../domain/geography/map_geometry.dart';
import '../../domain/geography/question_engine.dart';
import '../../domain/games/play/activity_definition.dart';
import '../../domain/models/age_band.dart';
import '../../domain/models/content_pack.dart';
import '../../domain/models/readiness.dart';
import '../../domain/regional/learning_preferences.dart';
import '../play/open_activity.dart';
import '../play/play_chrome.dart';
import '../play/play_sounds.dart';
import '../play/save_completion.dart';
import 'india_map.dart';

class GeographyActivityScreen extends ConsumerStatefulWidget {
  const GeographyActivityScreen({
    required this.activity,
    this.catalog,
    this.atlas,
    this.journeyDate,
    super.key,
  });

  final GeographyActivity activity;
  final GeographyCatalog? catalog;
  final IndiaMapAtlas? atlas;
  final String? journeyDate;

  @override
  ConsumerState<GeographyActivityScreen> createState() =>
      _GeographyActivityScreenState();
}

class _GeographyActivityScreenState
    extends ConsumerState<GeographyActivityScreen> {
  late final GeographyCatalog _catalog;
  late final ActivityDefinition _definition;
  late final AudioController _audio;
  IndiaMapAtlas? _atlas;
  GeographyQuestion? _question;
  String? _selectedPlaceId;
  String? _answerId;
  bool _accepted = false;
  bool _saved = false;
  int _wrong = 0;
  int _hints = 0;
  var _showList = false;

  GeographyActivity get _activity => widget.activity;

  @override
  void initState() {
    super.initState();
    _audio = ref.read(audioControllerProvider);
    _catalog = widget.catalog ?? GeographyCatalog();
    final band = ref.read(sessionProvider).value?.profile?.ageBand ?? AgeBand.c;
    _definition = _catalog.definition(_activity, band);
    _atlas = widget.atlas;
    _selectedPlaceId = _activity.placeId;
    _showList = _catalog.place(_activity.placeId)?.smallTarget ?? false;
    if (_atlas == null) {
      unawaited(_loadAtlas());
    } else {
      _prepareQuestion();
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_playName());
    });
  }

  Future<void> _loadAtlas() async {
    try {
      final raw = await rootBundle.loadString(
        'assets/content/geography/slice_geometry.json',
      );
      final atlas = atlasFromJson(jsonDecode(raw) as Map<String, dynamic>);
      if (!mounted) {
        return;
      }
      setState(() => _atlas = atlas);
      _prepareQuestion();
    } catch (_) {
      if (mounted) {
        setState(() {});
      }
    }
  }

  void _prepareQuestion() {
    final session = ref.read(sessionProvider).value;
    final band = session?.profile?.ageBand ?? AgeBand.c;
    final readiness = session?.profile?.readiness ?? Readiness.steady;
    final progress = ref.read(progressListProvider).value ?? const [];
    final introduced = introducedPlacesFrom([
      for (final row in progress)
        if (row.completed) row.activityId,
    ]);
    if (_activity.placeId != null) {
      introduced.add(_activity.placeId!);
    }
    final engine = const GeographyQuestionEngine();
    final place = _catalog.place(_activity.placeId);
    setState(() {
      _question = switch (_activity.mode) {
        GeographyMode.matchName when place != null => engine.nameQuestion(
          pack: _catalog.pack,
          place: place,
          introducedPlaceIds: introduced,
          band: band,
          readiness: readiness,
        ),
        GeographyMode.capital when place != null => engine.capitalQuestion(
          pack: _catalog.pack,
          place: place,
          introducedPlaceIds: introduced,
          band: band,
          readiness: readiness,
        ),
        GeographyMode.review => engine.reviewQuestion(
          pack: _catalog.pack,
          introducedPlaceIds: introduced,
          band: band,
          readiness: readiness,
        ),
        _ => place == null ? null : engine.typeQuestion(place: place),
      };
    });
  }

  Future<void> _playName() async {
    final id =
        _activity.narrationId ?? _catalog.place(_selectedPlaceId)?.narrationId;
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
    try {
      await deleteCheckpoint(ref, _definition.id);
    } catch (_) {}
    if (mounted) {
      setState(() => _accepted = true);
    }
  }

  void _choose(String id) {
    if (_accepted || _saved) {
      return;
    }
    if (_activity.mode == GeographyMode.explore ||
        _activity.mode == GeographyMode.learn) {
      setState(() {
        _selectedPlaceId = id;
        _showList = _catalog.place(id)?.smallTarget ?? false;
      });
      unawaited(_playName());
      return;
    }
    if (_activity.mode == GeographyMode.matchLocation) {
      final correct = id == _activity.placeId;
      setState(() {
        _selectedPlaceId = id;
        _answerId = id;
        if (correct) {
          _accepted = true;
        } else {
          _wrong += 1;
        }
      });
      playFeedback(ref, correct ? FeedbackKind.correct : FeedbackKind.retry);
      return;
    }
    final question = _question;
    if (question == null) {
      return;
    }
    final correct = const GeographyQuestionEngine().accepts(question, id);
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
    final atlas = _atlas;
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
                      if (atlas == null)
                        const Text('The map is still opening.')
                      else
                        IndiaMapView(
                          atlas: atlas,
                          highlightedIds: {
                            ?_activity.placeId,
                            ?_selectedPlaceId,
                          },
                          selectedId: _selectedPlaceId,
                          insetId: _showList ? _selectedPlaceId : null,
                          onRegionTap: (hit) {
                            if (hit.useListAlternative &&
                                _activity.mode != GeographyMode.learn) {
                              setState(() => _showList = true);
                            }
                            _choose(hit.regionId);
                          },
                        ),
                      const SizedBox(height: SproutSpace.md),
                      ..._info(text, teaching),
                      if (_showList) ...[
                        const SizedBox(height: SproutSpace.md),
                        Text(
                          'A list is easier for small places.',
                          style: text.bodyMedium,
                        ),
                        const SizedBox(height: SproutSpace.sm),
                        for (final place in _listPlaces()) ...[
                          ChoiceCard(
                            label: place.name,
                            selected: _selectedPlaceId == place.id,
                            onPressed: () => _choose(place.id),
                          ),
                          const SizedBox(height: 12),
                        ],
                      ],
                      if (_question != null &&
                          _activity.mode != GeographyMode.explore &&
                          _activity.mode != GeographyMode.learn &&
                          _activity.mode != GeographyMode.matchLocation) ...[
                        const SizedBox(height: SproutSpace.md),
                        Text(_question!.prompt, style: text.titleMedium),
                        const SizedBox(height: SproutSpace.sm),
                        for (final choice in _question!.choices) ...[
                          ChoiceCard(
                            label: choice.label,
                            selected: _answerId == choice.id,
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
                        primaryKey: const Key('geo-next'),
                        fromJourney: widget.journeyDate != null,
                        onHearAgain: _playName,
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
                          final learnReady =
                              _activity.mode == GeographyMode.explore ||
                              _activity.mode == GeographyMode.learn;
                          await _finish(
                            skipped: learnReady ? false : !_accepted,
                          );
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

  List<Widget> _info(TextTheme text, TeachingLanguage teaching) {
    final place = _catalog.place(_selectedPlaceId ?? _activity.placeId);
    if (place == null) {
      return const [];
    }
    final bilingual =
        teaching != TeachingLanguage.english && place.hindiName != null;
    return [
      SproutCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(place.name, style: text.headlineMedium),
            if (bilingual)
              Text(
                place.hindiName!,
                style: text.headlineSmall?.copyWith(
                  fontFamilyFallback: SproutType.fallback,
                  height: SproutType.devanagariHeight,
                ),
              ),
            const SizedBox(height: SproutSpace.xs),
            Text(place.typeLabel, style: text.titleMedium),
            const SizedBox(height: SproutSpace.sm),
            Text(place.fact.text, style: text.bodyLarge),
            if (place.hasSeasonalOrMultipleCapitals) ...[
              const SizedBox(height: SproutSpace.sm),
              Text(
                'This place has more than one capital seat, so we do not ask for one answer.',
                style: text.bodyMedium,
              ),
            ],
          ],
        ),
      ),
    ];
  }

  List<PlaceRecord> _listPlaces() {
    final playable = {
      for (final activity in _catalog.pack.activities)
        if (activity.placeId != null) activity.placeId!,
    };
    return [
      for (final place in _catalog.pack.places.values)
        if (playable.contains(place.id) &&
            (place.smallTarget || place.id == _activity.placeId))
          place,
    ];
  }
}
