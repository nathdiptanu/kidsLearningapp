import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/session_providers.dart';
import '../../../domain/games/play/activity_definition.dart';
import '../learning_area.dart';
import '../sprout_tokens.dart';
import 'fox_mascot.dart';

/// Top of every game: close, what is being played, sound, and progress.
class GameHeader extends StatelessWidget {
  const GameHeader({
    required this.title,
    required this.onClose,
    this.activity,
    this.progress,
    this.progressLabel,
    super.key,
  });

  final String title;
  final VoidCallback onClose;
  final ActivityDefinition? activity;
  final double? progress;
  final String? progressLabel;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final item = activity;
    final detail = item == null
        ? null
        : '${gameKindLabel(item.category)} · ${levelLabel(item)}';
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: SproutColors.surface,
        borderRadius: BorderRadius.all(Radius.circular(SproutRadius.card)),
        border: Border.fromBorderSide(BorderSide(color: SproutColors.cardEdge)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          SproutSpace.xs,
          SproutSpace.xs,
          SproutSpace.xs,
          SproutSpace.sm,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Semantics(
                  button: true,
                  label: 'Close',
                  onTap: onClose,
                  excludeSemantics: true,
                  child: IconButton(
                    onPressed: onClose,
                    iconSize: SproutSize.childIcon,
                    style: IconButton.styleFrom(
                      backgroundColor: SproutColors.background,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: SproutSize.childTarget - 8,
                      minHeight: SproutSize.childTarget - 8,
                    ),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ),
                const SizedBox(width: SproutSpace.xs),
                if (item != null) ...[
                  ArtTile(
                    art: artFor(item.category),
                    tint: tintFor(item.category),
                    width: 48,
                    height: 36,
                    radius: 10,
                  ),
                  const SizedBox(width: SproutSpace.sm),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: text.titleMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (detail != null)
                        Text(detail, style: text.bodySmall),
                    ],
                  ),
                ),
                const GameSoundButton(),
              ],
            ),
            if (progress != null || progressLabel != null) ...[
              const SizedBox(height: SproutSpace.xs),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    if (progress != null)
                      Expanded(
                        child: ExcludeSemantics(
                          child: LinearProgressIndicator(
                            value: progress!.clamp(0, 1),
                            minHeight: 8,
                          ),
                        ),
                      )
                    else
                      const Spacer(),
                    if (progressLabel != null) ...[
                      const SizedBox(width: 12),
                      Text(progressLabel!, style: text.labelMedium),
                    ],
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Child mute for activity sounds. It does not open grown-up settings.
class GameSoundButton extends ConsumerWidget {
  const GameSoundButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enabled =
        ref.watch(sessionProvider).value?.settings.soundEffectsEnabled ?? true;
    Future<void> toggle() async {
      final settings = ref.read(sessionProvider).value?.settings;
      if (settings == null) {
        return;
      }
      await ref
          .read(sessionProvider.notifier)
          .saveSettings(settings.copyWith(soundEffectsEnabled: !enabled));
    }

    return Semantics(
      button: true,
      label: enabled ? 'Sound is on' : 'Sound is off',
      onTap: toggle,
      excludeSemantics: true,
      child: IconButton(
        onPressed: toggle,
        iconSize: SproutSize.childIcon,
        style: IconButton.styleFrom(
          backgroundColor: SproutColors.primarySoft,
          foregroundColor: SproutColors.primary,
        ),
        constraints: const BoxConstraints(
          minWidth: SproutSize.childTarget - 8,
          minHeight: SproutSize.childTarget - 8,
        ),
        icon: Icon(enabled ? Icons.volume_up_rounded : Icons.volume_off_rounded),
      ),
    );
  }
}
