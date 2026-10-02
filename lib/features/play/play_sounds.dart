import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/session_providers.dart';
import '../../core/audio/audio_controller.dart';
import '../../core/design_system/widgets/feedback_overlay.dart';

/// Plays one short sound for a result. Hints stay visual because no reviewed
/// spoken hint is bundled.
void playFeedback(WidgetRef ref, FeedbackKind kind) {
  final effect = switch (kind) {
    FeedbackKind.correct => SoundEffect.correct,
    FeedbackKind.retry => SoundEffect.retry,
    FeedbackKind.hint => null,
  };
  if (effect == null) {
    return;
  }
  ref.read(audioControllerProvider).playEffect(effect);
}
