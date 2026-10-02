import 'age_band.dart';

class ChildProfile {
  const ChildProfile({
    required this.id,
    required this.nickname,
    required this.avatarId,
    required this.ageBand,
    required this.createdAtMillis,
    required this.active,
  });

  final int id;
  final String? nickname;
  final String avatarId;
  final AgeBand ageBand;
  final int createdAtMillis;
  final bool active;
}
