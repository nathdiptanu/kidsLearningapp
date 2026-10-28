import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/session_providers.dart';
import '../../core/audio/audio_controller.dart';
import '../../core/design_system/sprout_tokens.dart';
import '../../core/design_system/widgets/app_page_scaffold.dart';
import '../../core/design_system/widgets/primary_kid_button.dart';
import '../../core/design_system/widgets/sprout_card.dart';
import '../../domain/games/play/activity_definition.dart';
import '../../domain/models/game_category.dart';
import '../../domain/models/age_band.dart';
import '../../domain/regional/explorer_content.dart';
import '../../domain/regional/regional_availability.dart';
import '../play/save_completion.dart';
import 'india_learning_screen.dart';

/// The usable, source-based library; legacy unreviewed tracing stays separate.
class ExplorerLibraryScreen extends ConsumerStatefulWidget {
  const ExplorerLibraryScreen({required this.module, super.key});
  final RegionalModule module;
  @override
  ConsumerState<ExplorerLibraryScreen> createState() => _ExplorerLibraryState();
}

class _ExplorerLibraryState extends ConsumerState<ExplorerLibraryScreen> {
  String _query = '';
  @override
  Widget build(BuildContext context) {
    ref.listen(regionalModulesProvider, (_, modules) {
      if (!modules.contains(widget.module)) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) Navigator.of(context).maybePop();
        });
      }
    });
    final hindi = widget.module == RegionalModule.hindi;
    final band = ref.watch(sessionProvider).value?.profile?.ageBand;
    final toddler = band == AgeBand.toddler;
    return AppPageScaffold(
      title: hindi ? 'Hindi' : 'Discover India',
      body: ListView(
        padding: const EdgeInsets.all(SproutSpace.page),
        children: [
          SproutCard(
            color: hindi ? const Color(0xFFFFF0E6) : const Color(0xFFE8F5EF),
            child: Text(
              toddler
                  ? 'Explore together with a grown-up. Tap a picture or name.'
                  : hindi
                  ? 'Tap to hear. Explore letters, then play with words!'
                  : 'Meet India’s places, monuments and neighbours!',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const SizedBox(height: 16),
          if (hindi) ...[
            if (!toddler) ...[
              _heading(context, 'Vowels'),
              _letters(hindiVowels, 'vowel'),
              _heading(context, 'Consonants'),
              _letters(hindiConsonants, 'consonant'),
            ],
            _heading(context, 'Words from each letter'),
            for (final entry in hindiLetterWords.entries)
              _entry(
                '${entry.key} · ${entry.value.map((word) => word.word).join(', ')}',
                entry.value.map((word) => word.meaning).join(', '),
                'hi:family:${entry.key}',
                '${entry.key}. ${entry.value.map((word) => '${word.word}, ${word.meaning}').join('. ')}',
                hindi: true,
                picture: entry.value.first.picture,
              ),
            _heading(context, 'Picture words'),
            for (final word in hindiPictureWords)
              _entry(
                word.word,
                word.meaning,
                'hi:word:${word.picture}',
                word.word,
                hindi: true,
                picture: word.picture,
              ),
          ] else ...[
            PrimaryKidButton(
              label: 'Start my India journey',
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const IndiaLearningScreen(),
                ),
              ),
              trailingIcon: Icons.explore,
            ),
            const SizedBox(height: 12),
            PrimaryKidButton(
              label: 'Explore the accurate India map',
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const OfficialIndiaMapScreen(),
                ),
              ),
              trailingIcon: Icons.map_outlined,
            ),
            _heading(context, 'States and union territories'),
            const Text(
              '28 states · 8 union territories. Choose a place to explore.',
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Find a place',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) =>
                  setState(() => _query = value.trim().toLowerCase()),
            ),
            const SizedBox(height: 12),
            for (var i = 0; i < explorerPlaces.length; i++)
              if (explorerPlaces[i].name.toLowerCase().contains(_query) ||
                  explorerPlaces[i].hindi.contains(_query))
                _place(explorerPlaces[i], 'region', i),
            if (explorerPlaces.every(
              (p) =>
                  !p.name.toLowerCase().contains(_query) &&
                  !p.hindi.contains(_query),
            ))
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text('Try a different name.'),
              ),
            _heading(context, 'Neighbouring countries'),
            for (var i = 0; i < explorerNeighbours.length; i++)
              _place(explorerNeighbours[i], 'neighbour', i),
            _heading(context, 'Monuments'),
            for (final entry in explorerMonuments.entries)
              _entry(
                entry.value.title,
                entry.value.detail,
                'india:monument:${entry.key}',
                entry.value.title,
                picture: entry.value.picture,
                choices: entry.value.choices,
              ),
          ],
          const SizedBox(height: 16),
          const Text(
            'Speech uses the device’s installed offline voice. Pronunciation recordings are being prepared.',
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _heading(BuildContext context, String label) => Padding(
    padding: const EdgeInsets.only(top: 24, bottom: 12),
    child: Text(label, style: Theme.of(context).textTheme.titleLarge),
  );

  Widget _letters(List<String> letters, String kind) => Wrap(
    spacing: 12,
    runSpacing: 12,
    children: [
      for (final letter in letters)
        SizedBox(
          width: 88,
          height: 88,
          child: FilledButton.tonal(
            style: FilledButton.styleFrom(padding: const EdgeInsets.all(8)),
            onPressed: () => _open(
              letter,
              'Listen, then find the same letter.',
              'hi:$kind:$letter',
              letter,
              hindi: true,
              choices: [
                letter,
                letters[(letters.indexOf(letter) + 1) % letters.length],
              ],
            ),
            child: Text(
              letter,
              style: const TextStyle(
                fontFamily: 'NotoSansDevanagari',
                fontSize: 36,
              ),
            ),
          ),
        ),
    ],
  );

  Widget _place(ExplorerPlace place, String kind, int index) => _entry(
    place.name,
    '${place.type} · ${place.fact}',
    'india:$kind:$index',
    place.name,
    details: '${place.name}\n${place.hindi}\n${place.type}\n\n${place.fact}',
    choices: [
      place.name,
      (kind == 'region' ? explorerPlaces : explorerNeighbours)[(index + 1) %
              (kind == 'region' ? explorerPlaces : explorerNeighbours).length]
          .name,
    ],
  );

  Widget _entry(
    String title,
    String subtitle,
    String id,
    String speech, {
    bool hindi = false,
    String? picture,
    String? details,
    List<String>? choices,
  }) {
    final done =
        ref
            .watch(progressListProvider)
            .value
            ?.any((p) => p.activityId == id && p.completed) ??
        false;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SproutCard(
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: picture != null && hindi
              ? SizedBox(
                  width: 60,
                  child: Image.asset(
                    'assets/teaching/$picture.png',
                    cacheWidth: 144,
                    fit: BoxFit.contain,
                  ),
                )
              : Icon(
                  done
                      ? Icons.check_circle
                      : hindi
                      ? Icons.volume_up_rounded
                      : Icons.explore_rounded,
                  color: const Color(0xFF5B3CC4),
                ),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
          subtitle: Text(subtitle),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _open(
            title,
            details ?? subtitle,
            id,
            speech,
            hindi: hindi,
            picture: picture,
            choices:
                choices ??
                [
                  title,
                  hindi
                      ? hindiPictureWords[(hindiPictureWords.indexWhere(
                                      (w) => w.word == title,
                                    ) +
                                    1) %
                                hindiPictureWords.length]
                            .word
                      : 'India Gate',
                ],
          ),
        ),
      ),
    );
  }

  void _open(
    String title,
    String detail,
    String id,
    String speech, {
    bool hindi = false,
    String? picture,
    List<String>? choices,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ExplorerActivityScreen(
          title: title,
          detail: detail,
          activityId: id,
          spokenText: speech,
          hindi: hindi,
          picture: picture,
          choices: choices ?? [title],
          speakOnOpen: true,
        ),
      ),
    );
  }
}

class ExplorerActivityScreen extends ConsumerStatefulWidget {
  const ExplorerActivityScreen({
    required this.title,
    required this.detail,
    required this.activityId,
    required this.spokenText,
    required this.choices,
    this.hindi = false,
    this.picture,
    this.speakOnOpen = false,
    this.journeyDate,
    super.key,
  });
  final String title, detail, activityId, spokenText;
  final bool hindi;
  final bool speakOnOpen;
  final String? journeyDate;
  final String? picture;
  final List<String> choices;
  @override
  ConsumerState<ExplorerActivityScreen> createState() =>
      _ExplorerActivityState();
}

class _ExplorerActivityState extends ConsumerState<ExplorerActivityScreen>
    with WidgetsBindingObserver {
  bool _practice = false, _complete = false, _saving = false, _speaking = false;
  int _wrong = 0;
  String? _feedback;
  late final List<String> _choices;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _choices = [...widget.choices];
    if (widget.activityId.codeUnits.fold<int>(0, (a, b) => a + b).isOdd) {
      _choices.setAll(0, _choices.reversed.toList());
    }
    if (widget.speakOnOpen) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _hear();
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) {
      ref.read(audioControllerProvider).stopNarration();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _hear() async {
    setState(() => _speaking = true);
    final result = await ref
        .read(audioControllerProvider)
        .playNarration(
          widget.activityId,
          assetPath: Uri(
            scheme: 'speech',
            queryParameters: {
              'language': widget.hindi ? 'hi-IN' : 'en-IN',
              'text': widget.spokenText,
            },
          ).toString(),
        );
    if (!mounted) return;
    setState(() {
      _speaking = false;
      _feedback = switch (result) {
        NarrationPlayResult.muted =>
          'Spoken instructions are off. Ask a grown-up to turn them on.',
        NarrationPlayResult.missing => 'A device voice is not ready. Ask a grown-up to install an offline voice.',
        _ => _feedback,
      };
    });
  }

  Future<void> _answer(String choice) async {
    if (_saving || _complete) return;
    if (choice != widget.title) {
      setState(() {
        _wrong++;
        _feedback = 'Good exploring! Look again and try another.';
      });
      return;
    }
    setState(() {
      _saving = true;
      _feedback = 'You found it! Lovely learning.';
    });
    try {
      final band =
          ref.read(sessionProvider).value?.profile?.ageBand ?? AgeBand.a;
      await saveFinishedActivity(
        ref,
        journeyDate: widget.journeyDate,
        activity: ActivityDefinition(
          id: widget.activityId,
          category: widget.hindi
              ? GameCategory.hindi
              : GameCategory.discoverIndia,
          band: band,
          variant: 0,
          seed: 0,
          title: widget.title,
          questionCount: 1,
        ),
        hintsUsed: 0,
        firstAttemptCorrect: _wrong == 0,
        stars: _wrong == 0 ? 3 : 2,
        wrongCount: _wrong,
      );
      if (mounted) setState(() => _complete = true);
    } catch (_) {
      if (mounted) {
        setState(
          () => _feedback = 'Your answer was right. Saving needs another try.',
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) => PopScope(
    onPopInvokedWithResult: (popped, result) {
      if (popped) ref.read(audioControllerProvider).stopNarration();
    },
    child: AppPageScaffold(
      title: widget.title,
      body: ListView(
        padding: const EdgeInsets.all(SproutSpace.page),
        children: [
          if (!_practice) ...[
            if (widget.picture != null) TeachingPicture(id: widget.picture!),
            const SizedBox(height: 16),
            SproutCard(
              color: const Color(0xFFFFF1E5),
              child: InkWell(
                onTap: _hear,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(
                          fontSize: 38,
                          fontWeight: FontWeight.w800,
                          fontFamily: widget.hindi
                              ? 'NotoSansDevanagari'
                              : 'Nunito',
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        widget.detail,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 12),
                      const Icon(Icons.volume_up_rounded),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SecondaryKidButton(
              label: _speaking ? 'Speaking…' : 'Hear again',
              onPressed: _hear,
              trailingIcon: Icons.volume_up_rounded,
            ),
            const SizedBox(height: 16),
            PrimaryKidButton(
              label: 'Let’s try a little game',
              onPressed: () => setState(() {
                _practice = true;
                _feedback = null;
              }),
            ),
          ] else ...[
            Text(
              _complete ? 'You found it!' : 'Which one did we just meet?',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            if (widget.picture != null) TeachingPicture(id: widget.picture!),
            for (final choice in _choices) ...[
              const SizedBox(height: 12),
              SecondaryKidButton(
                label: choice,
                onPressed: _saving || _complete ? null : () => _answer(choice),
              ),
            ],
            const SizedBox(height: 16),
            SecondaryKidButton(
              label: 'Look and hear again',
              onPressed: () => setState(() => _practice = false),
            ),
            if (_complete) ...[
              const SizedBox(height: 16),
              PrimaryKidButton(
                label: widget.journeyDate == null
                    ? 'Explore another'
                    : 'Back to adventure',
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ],
          if (_feedback != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Semantics(
                liveRegion: true,
                child: Text(
                  _feedback!,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ),
          const SizedBox(height: 12),
          const Text(
            'Device speech · uses an installed offline voice',
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    ),
  );
}

class TeachingPicture extends StatelessWidget {
  const TeachingPicture({required this.id, super.key});
  final String id;
  @override
  Widget build(BuildContext context) {
    if (explorerMonuments.containsKey(id)) {
      return Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Image.asset(
              'assets/teaching/$id.jpg',
              cacheWidth: 960,
              height: 300,
              width: double.infinity,
              fit: BoxFit.contain,
            ),
          ),
          Text(switch (id) {
            'qutb-minar' => 'Photo: Fuzail Ahmad · CC BY-SA 4.0',
            'red-fort' => 'Photo: Michael Clarke · CC BY-SA 2.0',
            'sanchi' => 'Photo: Kaushlendrapathe · CC BY-SA 4.0',
            'konark' => 'Photo: Mayank Choudhary · CC BY-SA 3.0',
            'shore-temple' => 'Photo: Rainer Halama · CC BY-SA 4.0',
            _ => 'Photo: Divya Shikhar · CC BY-SA 4.0',
          }, style: const TextStyle(fontSize: 12)),
        ],
      );
    }
    return Image.asset(
      'assets/teaching/$id.png',
      cacheWidth: 720,
      height: 220,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stack) => const SizedBox(
        height: 80,
        child: Icon(Icons.photo_outlined, size: 48),
      ),
    );
  }
}

class OfficialIndiaMapScreen extends StatelessWidget {
  const OfficialIndiaMapScreen({super.key});
  @override
  Widget build(BuildContext context) => AppPageScaffold(
    title: 'India map',
    body: Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Pinch to zoom. Drag to look around. This map keeps its original proportions.',
          ),
        ),
        Expanded(
          child: InteractiveViewer(
            minScale: 1,
            maxScale: 12,
            child: Center(
              child: Image.asset(
                'assets/teaching/india-map-2026.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Source: Survey of India, Government of India\nPolitical Map of India · English 13th edition, 2026',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12),
          ),
        ),
      ],
    ),
  );
}
