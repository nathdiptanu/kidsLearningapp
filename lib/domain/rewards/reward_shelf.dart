import 'reward_snapshot.dart';

class RewardShelf {
  const RewardShelf({required this.snapshot, required this.unlockedAt});

  final RewardSnapshot snapshot;
  final Map<String, int> unlockedAt;

  bool isUnlocked(String id) => unlockedAt.containsKey(id);

  static const empty = RewardShelf(snapshot: RewardSnapshot(), unlockedAt: {});
}
