import 'age_band.dart';
import 'readiness.dart';

class ChildProfile {
  const ChildProfile({
    required this.id,
    required this.nickname,
    required this.avatarId,
    required this.ageBand,
    required this.createdAtMillis,
    required this.active,
    this.readiness = Readiness.steady,
  });

  final int id;
  final String? nickname;
  final String avatarId;
  final AgeBand ageBand;
  final int createdAtMillis;
  final bool active;
  final Readiness readiness;
}
