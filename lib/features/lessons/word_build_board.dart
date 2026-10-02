import 'package:flutter/material.dart';

import '../../core/design_system/sprout_tokens.dart';
import '../../core/design_system/widgets/sprout_card.dart';
import '../../core/design_system/widgets/word_picture.dart';
import '../../domain/lessons/lesson_models.dart';

class WordBuildBoard extends StatelessWidget {
  const WordBuildBoard({
    required this.assembled,
    required this.pictureId,
    required this.meaning,
    required this.bilingualNote,
    required this.bank,
    required this.placed,
    required this.onAdd,
    required this.onUndo,
    this.prompt,
    super.key,
  });

  final String assembled;
  final String? pictureId;
  final String? meaning;
  final String? bilingualNote;
  final List<LessonToken> bank;
  final List<LessonToken> placed;
  final ValueChanged<LessonToken> onAdd;
  final VoidCallback onUndo;
  final String? prompt;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SproutCard(
          child: Row(
            children: [
              if (pictureId != null)
                ExcludeSemantics(
                  child: WordPicture(wordId: pictureId!, size: 88),
                ),
              if (pictureId != null) const SizedBox(width: SproutSpace.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      assembled.isEmpty ? '…' : assembled,
                      style: text.headlineMedium?.copyWith(
                        fontFamilyFallback: SproutType.fallback,
                        height: SproutType.devanagariHeight,
                      ),
                    ),
                    if (meaning != null) Text(meaning!, style: text.bodyLarge),
                    if (bilingualNote != null) ...[
                      const SizedBox(height: SproutSpace.xs),
                      Text(bilingualNote!, style: text.bodyMedium),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
        if (prompt != null) ...[
          const SizedBox(height: SproutSpace.sm),
          Semantics(
            liveRegion: true,
            child: Text(prompt!, style: text.bodyLarge),
          ),
        ],
        const SizedBox(height: SproutSpace.md),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final token in bank)
              Semantics(
                button: true,
                label: token.concept == ConceptType.matra
                    ? 'Vowel sign ${token.text}'
                    : token.concept == ConceptType.conjunct
                    ? 'Joined letters ${token.text}'
                    : token.text,
                child: OutlinedButton(
                  onPressed: () => onAdd(token),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(64, 64),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                  child: Text(
                    token.text,
                    style: text.headlineSmall?.copyWith(
                      fontFamilyFallback: SproutType.fallback,
                      height: SproutType.devanagariHeight,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: SproutSpace.sm),
        TextButton(
          onPressed: placed.isEmpty ? null : onUndo,
          child: const Text('Undo last piece'),
        ),
      ],
    );
  }
}
