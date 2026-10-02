class ChoiceCheckpoint {
  const ChoiceCheckpoint({
    required this.index,
    required this.wrongOnQuestion,
    required this.totalWrong,
    required this.hintsShown,
    required this.acceptedCurrent,
  });

  final int index;
  final int wrongOnQuestion;
  final int totalWrong;
  final int hintsShown;
  final bool acceptedCurrent;
}

class BoardCheckpoint {
  const BoardCheckpoint({
    required this.kind,
    required this.wrong,
    required this.hintsUsed,
    this.row = 0,
    this.col = 0,
    this.marked = const [],
  });

  final String kind;
  final int row;
  final int col;
  final List<String> marked;
  final int wrong;
  final int hintsUsed;
}

const checkpointPayloadVersion = 1;

String choiceCheckpointPayload({
  required int seed,
  required String generatorVersion,
  required ChoiceCheckpoint state,
}) {
  return 'v=$checkpointPayloadVersion;kind=choices;seed=$seed;gen=$generatorVersion;index=${state.index};wrongOn=${state.wrongOnQuestion};totalWrong=${state.totalWrong};hints=${state.hintsShown};accepted=${state.acceptedCurrent ? 1 : 0}';
}

ChoiceCheckpoint? parseChoiceCheckpoint(
  String payload, {
  required int seed,
  required String generatorVersion,
  required int questionCount,
}) {
  final fields = _fields(payload);
  if (fields == null ||
      fields['v'] != '$checkpointPayloadVersion' ||
      fields['kind'] != 'choices' ||
      fields['seed'] != '$seed' ||
      fields['gen'] != generatorVersion) {
    return null;
  }
  final index = int.tryParse(fields['index'] ?? '');
  final wrongOn = int.tryParse(fields['wrongOn'] ?? '');
  final totalWrong = int.tryParse(fields['totalWrong'] ?? '');
  final hints = int.tryParse(fields['hints'] ?? '');
  final accepted = fields['accepted'];
  if (index == null ||
      wrongOn == null ||
      totalWrong == null ||
      hints == null ||
      index < 0 ||
      index >= questionCount ||
      wrongOn < 0 ||
      totalWrong < 0 ||
      hints < 0 ||
      (accepted != '0' && accepted != '1')) {
    return null;
  }
  return ChoiceCheckpoint(
    index: index,
    wrongOnQuestion: wrongOn,
    totalWrong: totalWrong,
    hintsShown: hints,
    acceptedCurrent: accepted == '1',
  );
}

String boardCheckpointPayload({
  required int seed,
  required String generatorVersion,
  required BoardCheckpoint state,
}) {
  final marked = state.marked.join('|');
  return 'v=$checkpointPayloadVersion;kind=${state.kind};seed=$seed;gen=$generatorVersion;row=${state.row};col=${state.col};marked=$marked;wrong=${state.wrong};hints=${state.hintsUsed}';
}

BoardCheckpoint? parseBoardCheckpoint(
  String payload, {
  required int seed,
  required String generatorVersion,
  required String kind,
}) {
  final fields = _fields(payload);
  if (fields == null ||
      fields['v'] != '$checkpointPayloadVersion' ||
      fields['kind'] != kind ||
      fields['seed'] != '$seed' ||
      fields['gen'] != generatorVersion) {
    return null;
  }
  final row = int.tryParse(fields['row'] ?? '');
  final col = int.tryParse(fields['col'] ?? '');
  final wrong = int.tryParse(fields['wrong'] ?? '');
  final hints = int.tryParse(fields['hints'] ?? '');
  if (row == null || col == null || wrong == null || hints == null) {
    return null;
  }
  if (row < 0 || col < 0 || wrong < 0 || hints < 0) {
    return null;
  }
  final marked = (fields['marked'] ?? '')
      .split('|')
      .where((id) => id.isNotEmpty)
      .toList();
  return BoardCheckpoint(
    kind: kind,
    row: row,
    col: col,
    marked: marked,
    wrong: wrong,
    hintsUsed: hints,
  );
}

String lessonCheckpointPayload({
  required String lessonId,
  required int strokeIndex,
  required bool assisted,
  required bool accepted,
  required int wrong,
  required int hints,
  required List<String> placed,
}) {
  return 'v=$checkpointPayloadVersion;kind=lesson;id=$lessonId;stroke=$strokeIndex;assisted=${assisted ? 1 : 0};accepted=${accepted ? 1 : 0};wrong=$wrong;hints=$hints;placed=${placed.join('|')}';
}

({
  int strokeIndex,
  bool assisted,
  bool accepted,
  int wrong,
  int hints,
  List<String> placed,
})?
parseLessonCheckpoint(String payload, {required String lessonId}) {
  final fields = _fields(payload);
  if (fields == null ||
      fields['v'] != '$checkpointPayloadVersion' ||
      fields['kind'] != 'lesson' ||
      fields['id'] != lessonId) {
    return null;
  }
  final stroke = int.tryParse(fields['stroke'] ?? '');
  final wrong = int.tryParse(fields['wrong'] ?? '');
  final hints = int.tryParse(fields['hints'] ?? '');
  if (stroke == null || wrong == null || hints == null) {
    return null;
  }
  return (
    strokeIndex: stroke,
    assisted: fields['assisted'] == '1',
    accepted: fields['accepted'] == '1',
    wrong: wrong,
    hints: hints,
    placed: (fields['placed'] ?? '')
        .split('|')
        .where((id) => id.isNotEmpty)
        .toList(),
  );
}

Map<String, String>? _fields(String payload) {
  if (payload.trim().isEmpty) {
    return null;
  }
  final fields = <String, String>{};
  for (final part in payload.split(';')) {
    final split = part.split('=');
    if (split.length != 2 || split[0].isEmpty) {
      return null;
    }
    fields[split[0]] = split[1];
  }
  return fields;
}
