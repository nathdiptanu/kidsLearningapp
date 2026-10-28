import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/session_providers.dart';
import '../../core/audio/audio_controller.dart';
import '../../domain/models/age_band.dart';
import '../../domain/models/game_category.dart';
import '../../domain/games/play/activity_definition.dart';
import '../../domain/regional/explorer_content.dart';
import '../../domain/regional/india_general_knowledge.dart';
import '../../domain/regional/india_learning_content.dart';
import '../play/save_completion.dart';
import 'india_interactive_map.dart';
import 'explorer_library_screen.dart';

class IndiaLearningScreen extends ConsumerStatefulWidget {
  const IndiaLearningScreen({super.key, this.question, this.journeyDate});
  final IndiaQuestion? question;
  final String? journeyDate;
  @override
  ConsumerState<IndiaLearningScreen> createState() => _IndiaLearningState();
}

class _IndiaLearningState extends ConsumerState<IndiaLearningScreen> {
  final _scrollController = ScrollController();
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  int _index = 0, _wrong = 0;
  bool _asking = false, _done = false, _saving = false;
  String? _selected;
  String _feedback = '';
  List<IndiaQuestion> get _questions {
    if (widget.question != null) return [widget.question!];
    final band = ref.read(sessionProvider).value?.profile?.ageBand ?? AgeBand.a;
    final questions = indiaQuestions(band);
    const order = [
      IndiaQuestionKind.mapBasics,
      IndiaQuestionKind.river,
      IndiaQuestionKind.lake,
      IndiaQuestionKind.dam,
      IndiaQuestionKind.city,
      IndiaQuestionKind.neighbour,
      IndiaQuestionKind.locate,
      IndiaQuestionKind.capital,
      IndiaQuestionKind.culture,
      IndiaQuestionKind.monument,
    ];
    return [
      for (final kind in order) ...questions.where((q) => q.kind == kind),
    ];
  }

  IndiaQuestion get _q => _questions[_index];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _hear(_q.teaching);
    });
  }

  Future<void> _hear(String text) async {
    final result = await ref
        .read(audioControllerProvider)
        .playNarration(
          'india-learning:${_q.id}',
          assetPath: Uri(
            scheme: 'speech',
            queryParameters: {'language': 'en-IN', 'text': text},
          ).toString(),
        );
    if (!mounted) return;
    if (result == NarrationPlayResult.muted ||
        result == NarrationPlayResult.missing) {
      setState(
        () => _feedback = result == NarrationPlayResult.muted
            ? 'Spoken instructions are off. Ask a grown-up to turn them on.'
            : 'Install an offline English device voice to hear this lesson.',
      );
    }
  }

  Future<void> _answer(String name) async {
    if (!_asking || _done || _saving) return;
    if (name != _q.answer) {
      setState(() {
        _wrong++;
        _feedback = 'You found $name. Keep exploring! Try again.';
      });
      return;
    }
    setState(() => _saving = true);
    try {
      await saveFinishedActivity(
        ref,
        activity: ActivityDefinition(
          id: 'india-learning:v1:${_q.id}',
          category: GameCategory.discoverIndia,
          band: ref.read(sessionProvider).value?.profile?.ageBand ?? AgeBand.a,
          variant: 0,
          seed: 0,
          title: _q.prompt,
          questionCount: 1,
        ),
        hintsUsed: 0,
        firstAttemptCorrect: _wrong == 0,
        stars: _wrong == 0 ? 3 : 2,
        wrongCount: _wrong,
        journeyDate: widget.journeyDate,
      );
      if (mounted) {
        setState(() {
          _done = true;
          _selected = _q.answer;
          _feedback = 'You found it! Wonderful exploring.';
        });
        unawaited(_hear('Wonderful exploring! ${_q.answer}.'));
      }
    } catch (_) {
      if (mounted) {
        setState(
          () => _feedback = 'That is right! Tap again to save your learning.',
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _next() {
    if (_saving) {
      return;
    }
    ref.read(audioControllerProvider).stopNarration();
    setState(() {
      _index++;
      _asking = false;
      _done = false;
      _wrong = 0;
      _selected = null;
      _feedback = '';
    });
    _hear(_q.teaching);
  }

  @override
  Widget build(BuildContext context) {
    final q = _q;
    final toddler =
        ref.watch(sessionProvider).value?.profile?.ageBand == AgeBand.toddler;
    final locate = q.kind == IndiaQuestionKind.locate;
    final region =
        _selected ??
        (q.id.startsWith('capital:')
            ? q.id.substring(8)
            : locate
            ? q.answer
            : null);
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) ref.read(audioControllerProvider).stopNarration();
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('My India journey')),
        body: ListView(
          controller: _scrollController,
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              'Step ${_index + 1} of ${_questions.length} · ${_asking ? 'Try it!' : 'Let’s explore'}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Text(
              _asking ? q.prompt : q.teaching,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            if (q.picture != null)
              TeachingPicture(id: q.picture!)
            else if (q.kind == IndiaQuestionKind.neighbour) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: InteractiveViewer(
                  maxScale: 8,
                  child: Image.asset(
                    'assets/teaching/india-map-2026.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const Text('Pinch to zoom to see India and its neighbours.'),
            ] else
              IndiaInteractiveMap(
                highlight: (_asking && !_done) ? null : region,
                onSelect: (name) {
                  if (_asking) {
                    if (locate) _answer(name);
                  } else {
                    setState(() => _selected = name);
                    final p = explorerPlaces.where((p) => p.name == name).first;
                    _hear(
                      '$name. ${p.fact} ${toddler ? '' : capitalNotes[name] ?? 'Its capital is ${indiaCapitals[name]}.'} ${cultureBlurb(name)}',
                    );
                  }
                },
                showSelectedName: !_asking || _done,
              ),
            if (q.picture == null && q.kind != IndiaQuestionKind.neighbour)
              const Text(
                'Tap a coloured state. Pinch to zoom. Smaller territories are in the place list.',
              ),
            if (_selected != null && !_asking)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  '$_selected${toddler ? '' : ' · ${capitalNotes[_selected] ?? 'Capital: ${indiaCapitals[_selected]}'} ${cultureBlurb(_selected!)}'}',
                ),
              ),
            if (_feedback.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  _feedback,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            OutlinedButton.icon(
              onPressed: () => _hear(_asking ? q.prompt : q.teaching),
              icon: const Icon(Icons.volume_up),
              label: const Text('Hear again · device voice'),
            ),
            if (!_asking && !toddler)
              FilledButton(
                onPressed: () {
                  setState(() {
                    _asking = true;
                    _selected = null;
                    _feedback = '';
                  });
                  _hear(q.prompt);
                },
                child: const Text('Let’s try'),
              ),
            if (_asking && !locate && !_done)
              for (final answer in (List<String>.of(q.options)..sort()))
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: OutlinedButton(
                    onPressed: _saving ? null : () => _answer(answer),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(answer),
                    ),
                  ),
                ),
            if (_asking && !_done)
              TextButton(
                onPressed: () {
                  setState(() {
                    _asking = false;
                    _feedback = 'Look closely, then try when you’re ready.';
                  });
                  _hear(q.teaching);
                },
                child: const Text('Show me again'),
              ),
            if (_done || toddler)
              FilledButton(
                onPressed: _index + 1 < _questions.length
                    ? _next
                    : () => Navigator.of(context).pop(),
                child: Text(
                  _index + 1 < _questions.length ? 'Next discovery' : 'Done',
                ),
              ),
            if (!_asking && !toddler && _index + 1 < _questions.length)
              TextButton(
                onPressed: _next,
                child: const Text('Explore next without a question'),
              ),
            if (widget.question == null) ...[
              const SizedBox(height: 24),
              const Text('Choose a discovery · learn before every question'),
              Wrap(
                spacing: 8,
                children: [
                  for (final kind in IndiaQuestionKind.values.where(
                    (kind) => _questions.any((q) => q.kind == kind),
                  ))
                    ActionChip(
                      label: Text(switch (kind) {
                        IndiaQuestionKind.mapBasics => 'Meet the map',
                        IndiaQuestionKind.river => 'Rivers',
                        IndiaQuestionKind.lake => 'Lakes',
                        IndiaQuestionKind.dam => 'Dams',
                        IndiaQuestionKind.city => 'Cities',
                        IndiaQuestionKind.neighbour => 'Neighbours',
                        IndiaQuestionKind.locate => 'Find states',
                        IndiaQuestionKind.capital => 'Capitals',
                        IndiaQuestionKind.culture => 'Culture',
                        IndiaQuestionKind.monument => 'Monuments',
                      }),
                      onPressed: () {
                        if (_saving) {
                          return;
                        }
                        final i = _questions.indexWhere((q) => q.kind == kind);
                        if (i >= 0) {
                          setState(() {
                            _index = i;
                            _asking = false;
                            _done = false;
                            _selected = null;
                            _feedback = '';
                            _wrong = 0;
                          });
                          _hear(_q.teaching);
                        }
                      },
                    ),
                ],
              ),
              const SizedBox(height: 12),
              const Text('Explore every state and union territory'),
              for (final p in explorerPlaces)
                ListTile(
                  title: Text(p.name),
                  subtitle: Text(
                    toddler
                        ? p.type
                        : '${p.type} · ${indiaCapitals[p.name]} ${cultureBlurb(p.name)}',
                  ),
                  onTap: () {
                    if (_saving) {
                      return;
                    }
                    setState(() {
                      _selected = p.name;
                      _asking = false;
                      _done = false;
                      _feedback = p.fact;
                    });
                    _scrollController.animateTo(
                      0,
                      duration: const Duration(milliseconds: 350),
                      curve: Curves.easeOut,
                    );
                    _hear(
                      '${p.name}. ${p.fact} ${toddler ? '' : capitalNotes[p.name] ?? 'Its capital is ${indiaCapitals[p.name]}.'} ${cultureBlurb(p.name)}',
                    );
                  },
                ),
            ],
            const SizedBox(height: 16),
            const Text(
              'Map outlines: Survey of India, 2023 source. Speech uses your installed offline device voice. Explore together and take breaks whenever you like.',
              style: TextStyle(fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
