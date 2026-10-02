import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sproutlab/app/session_providers.dart';
import 'package:sproutlab/core/design_system/learning_area.dart';
import 'package:sproutlab/core/design_system/sprout_theme.dart';
import 'package:sproutlab/domain/games/play/activity_catalog.dart';
import 'package:sproutlab/domain/models/age_band.dart';
import 'package:sproutlab/domain/models/child_profile.dart';
import 'package:sproutlab/domain/models/game_category.dart';
import 'package:sproutlab/domain/progress/activity_record.dart';
import 'package:sproutlab/domain/regional/learning_preferences.dart';
import 'package:sproutlab/domain/settings/local_settings.dart';
import 'package:sproutlab/features/explore/explore_screen.dart';

void main() {
  const catalog = ActivityCatalog();

  test('generated activity titles avoid leftover again labels', () {
    for (final band in AgeBand.values) {
      for (final category in [
        GameCategory.maths,
        GameCategory.vocabulary,
        GameCategory.pattern,
      ]) {
        final titles = [
          for (final activity in catalog.forBand(category, band)) activity.title,
        ];
        expect(titles.any((title) => title.contains('again')), isFalse);
        expect(titles.every((title) => title.trim().isNotEmpty), isTrue);
      }
    }
  });

  test('quiz prompts stay in the card, not the header', () {
    final knowledge = catalog.forBand(GameCategory.knowledge, AgeBand.c).first;
    expect(activityHeaderTitle(knowledge), isNot(knowledge.title));
    expect(activityHeaderTitle(knowledge), contains('Quiz'));
    expect(containsDevanagari('Listen to अ'), isTrue);
    expect(containsDevanagari('Listen to A'), isFalse);
  });

  testWidgets('Play again hides regional history when the region is off', (
    tester,
  ) async {
    const hindiId = 'lesson:hindi:listen:a';
    final lesson = catalog.byId(hindiId)!;
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sessionProvider.overrideWith(_HiddenRegionSession.new),
          progressListProvider.overrideWith(
            (ref) async => [
              ActivityRecord(
                activityId: hindiId,
                engineType: GameCategory.hindi.storageKey,
                attempts: 1,
                completions: 1,
                bestStars: 3,
                hintsUsed: 0,
                lastPlayedAt: 10,
                countedAsFree: false,
              ),
            ],
          ),
          startedActivityIdsProvider.overrideWith((ref) async => {hindiId}),
          premiumActiveProvider.overrideWith((ref) => false),
        ],
        child: MaterialApp(
          theme: SproutTheme.child(),
          home: const PlayAgainScreen(),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    expect(find.text(lesson.title), findsNothing);
    expect(find.text('Nothing to play again yet'), findsOneWidget);
  });
}

class _HiddenRegionSession extends SessionController {
  @override
  Future<AppSession> build() async {
    return const AppSession(
      settings: LocalSettings(
        soundEffectsEnabled: true,
        musicEnabled: false,
        narrationEnabled: false,
        onboardingComplete: true,
        onboardingStep: 5,
        draftAgeBand: AgeBand.c,
        draftAvatarId: 'fox',
        draftNickname: null,
        learningRegion: LearningRegion.other,
      ),
      profile: ChildProfile(
        id: 1,
        nickname: 'Mia',
        avatarId: 'fox',
        ageBand: AgeBand.c,
        createdAtMillis: 0,
        active: true,
      ),
    );
  }
}
