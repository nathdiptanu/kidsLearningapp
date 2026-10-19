import 'dart:math';

enum TicDifficulty { beginner, guided, challenge }

enum TicOutcome { ongoing, childWin, opponentWin, draw }

enum TicActionKind { play, opponent, hint, reset }

class TicAction {
  const TicAction.play(this.index) : kind = TicActionKind.play;
  const TicAction.opponent() : kind = TicActionKind.opponent, index = null;
  const TicAction.hint() : kind = TicActionKind.hint, index = null;
  const TicAction.reset() : kind = TicActionKind.reset, index = null;

  final TicActionKind kind;
  final int? index;
}

class TicState {
  TicState({
    required this.cells,
    required this.childTurn,
    required this.difficulty,
    required this.seed,
    required this.opening,
    required this.openingChildTurn,
    this.ply = 0,
    this.hintsUsed = 0,
    this.hintIndex,
    this.winLine,
    this.outcome = TicOutcome.ongoing,
  });

  static const child = 1;
  static const opponent = 2;

  final List<int> cells;
  final bool childTurn;
  final TicDifficulty difficulty;
  final int seed;
  final int ply;
  final int hintsUsed;
  final int? hintIndex;
  final int? winLine;
  final TicOutcome outcome;
  final List<int> opening;
  final bool openingChildTurn;

  bool get finished => outcome != TicOutcome.ongoing;

  factory TicState.opening({required int variant, required int seed}) {
    final scenario = ticScenario(variant);
    return TicState(
      cells: List<int>.of(scenario.cells),
      childTurn: scenario.childTurn,
      difficulty: scenario.difficulty,
      seed: seed,
      opening: List<int>.of(scenario.cells),
      openingChildTurn: scenario.childTurn,
    );
  }

  TicState copyWith({
    List<int>? cells,
    bool? childTurn,
    int? ply,
    int? hintsUsed,
    int? hintIndex,
    bool clearHint = false,
    int? winLine,
    bool clearWin = false,
    TicOutcome? outcome,
  }) {
    return TicState(
      cells: cells ?? this.cells,
      childTurn: childTurn ?? this.childTurn,
      difficulty: difficulty,
      seed: seed,
      opening: opening,
      openingChildTurn: openingChildTurn,
      ply: ply ?? this.ply,
      hintsUsed: hintsUsed ?? this.hintsUsed,
      hintIndex: clearHint ? null : (hintIndex ?? this.hintIndex),
      winLine: clearWin ? null : (winLine ?? this.winLine),
      outcome: outcome ?? this.outcome,
    );
  }
}

class TicScenario {
  const TicScenario({
    required this.difficulty,
    required this.cells,
    required this.childTurn,
  });

  final TicDifficulty difficulty;
  final List<int> cells;
  final bool childTurn;
}

const ticLines = <List<int>>[
  [0, 1, 2],
  [3, 4, 5],
  [6, 7, 8],
  [0, 3, 6],
  [1, 4, 7],
  [2, 5, 8],
  [0, 4, 8],
  [2, 4, 6],
];

TicScenario ticScenario(int variant) {
  const empty = [0, 0, 0, 0, 0, 0, 0, 0, 0];
  return switch (variant % 5) {
    0 => const TicScenario(
      difficulty: TicDifficulty.beginner,
      cells: empty,
      childTurn: true,
    ),
    1 => const TicScenario(
      difficulty: TicDifficulty.guided,
      cells: empty,
      childTurn: true,
    ),
    2 => const TicScenario(
      difficulty: TicDifficulty.challenge,
      cells: empty,
      childTurn: true,
    ),
    3 => const TicScenario(
      difficulty: TicDifficulty.beginner,
      cells: [2, 0, 0, 0, 0, 0, 0, 0, 0],
      childTurn: true,
    ),
    _ => const TicScenario(
      difficulty: TicDifficulty.guided,
      cells: [2, 0, 0, 0, 1, 0, 0, 0, 0],
      childTurn: true,
    ),
  };
}

int? ticWinningLine(List<int> cells) {
  for (var index = 0; index < ticLines.length; index++) {
    final line = ticLines[index];
    final mark = cells[line[0]];
    if (mark != 0 && mark == cells[line[1]] && mark == cells[line[2]]) {
      return index;
    }
  }
  return null;
}

bool ticBoardFull(List<int> cells) => cells.every((cell) => cell != 0);

List<int> ticLegalMoves(List<int> cells) {
  return [
    for (var index = 0; index < cells.length; index++)
      if (cells[index] == 0) index,
  ];
}

class TicTacToeEngine {
  const TicTacToeEngine();

  static const generatorVersion = 'tic_tac_toe:v1';

  TicState create({required int variant, required int seed}) {
    return TicState.opening(variant: variant, seed: seed);
  }

  TicState reduce(TicState state, TicAction action) {
    return switch (action.kind) {
      TicActionKind.reset => TicState(
        cells: List<int>.of(state.opening),
        childTurn: state.openingChildTurn,
        difficulty: state.difficulty,
        seed: state.seed,
        opening: state.opening,
        openingChildTurn: state.openingChildTurn,
      ),
      TicActionKind.hint => _hint(state),
      TicActionKind.play => _playChild(state, action.index ?? -1),
      TicActionKind.opponent => _playOpponent(state),
    };
  }

  bool isComplete(TicState state) => state.finished;

  /// Pass-and-play uses the same terminal-state and occupied-cell guards.
  TicState playOnDevice(TicState state, int index) {
    if (state.finished || !_open(state.cells, index)) return state;
    return _place(
      state,
      index,
      state.childTurn ? TicState.child : TicState.opponent,
    );
  }

  TicState _hint(TicState state) {
    if (state.finished || !state.childTurn || state.hintsUsed > 0) {
      return state;
    }
    final move = chooseTicMove(
      cells: state.cells,
      difficulty: TicDifficulty.guided,
      seed: state.seed,
      ply: state.ply,
      mark: TicState.child,
    );
    if (move < 0) {
      return state;
    }
    return state.copyWith(hintsUsed: state.hintsUsed + 1, hintIndex: move);
  }

  TicState _playChild(TicState state, int index) {
    if (state.finished || !state.childTurn || !_open(state.cells, index)) {
      return state;
    }
    return _place(state, index, TicState.child);
  }

  TicState _playOpponent(TicState state) {
    if (state.finished || state.childTurn) {
      return state;
    }
    final move = chooseTicMove(
      cells: state.cells,
      difficulty: state.difficulty,
      seed: state.seed,
      ply: state.ply,
      mark: TicState.opponent,
    );
    if (move < 0) {
      return state;
    }
    return _place(state, move, TicState.opponent);
  }

  bool _open(List<int> cells, int index) {
    return index >= 0 && index < cells.length && cells[index] == 0;
  }

  TicState _place(TicState state, int index, int mark) {
    final next = List<int>.of(state.cells);
    next[index] = mark;
    final line = ticWinningLine(next);
    final outcome = line != null
        ? (mark == TicState.child
              ? TicOutcome.childWin
              : TicOutcome.opponentWin)
        : ticBoardFull(next)
        ? TicOutcome.draw
        : TicOutcome.ongoing;
    return state.copyWith(
      cells: next,
      childTurn: outcome == TicOutcome.ongoing ? mark != TicState.child : false,
      ply: state.ply + 1,
      clearHint: true,
      winLine: line,
      clearWin: line == null,
      outcome: outcome,
    );
  }
}

int chooseTicMove({
  required List<int> cells,
  required TicDifficulty difficulty,
  required int seed,
  required int ply,
  required int mark,
}) {
  final legal = ticLegalMoves(cells);
  if (legal.isEmpty) {
    return -1;
  }
  switch (difficulty) {
    case TicDifficulty.beginner:
      return legal[Random(seed + ply * 13).nextInt(legal.length)];
    case TicDifficulty.guided:
      final win = _forcingMove(cells, mark);
      if (win != null) {
        return win;
      }
      final other = mark == TicState.child ? TicState.opponent : TicState.child;
      final block = _forcingMove(cells, other);
      if (block != null) {
        return block;
      }
      return legal[Random(seed + ply * 13).nextInt(legal.length)];
    case TicDifficulty.challenge:
      return _minimaxMove(cells, seed, mark);
  }
}

int? _forcingMove(List<int> cells, int mark) {
  for (final index in ticLegalMoves(cells)) {
    final trial = List<int>.of(cells);
    trial[index] = mark;
    final line = ticWinningLine(trial);
    if (line != null && trial[ticLines[line][0]] == mark) {
      return index;
    }
  }
  return null;
}

int _minimaxMove(List<int> cells, int seed, int mark) {
  final legal = ticLegalMoves(cells);
  legal.sort((a, b) {
    final left = (a * 3 + seed) % 17;
    final right = (b * 3 + seed) % 17;
    final order = left.compareTo(right);
    return order == 0 ? a.compareTo(b) : order;
  });
  var bestIndex = legal.first;
  var bestScore = -99;
  for (final index in legal) {
    final trial = List<int>.of(cells);
    trial[index] = mark;
    final score = _minimax(trial, _other(mark), mark, false);
    if (score > bestScore) {
      bestScore = score;
      bestIndex = index;
    }
  }
  return bestIndex;
}

int _other(int mark) =>
    mark == TicState.child ? TicState.opponent : TicState.child;

int _minimax(List<int> cells, int toMove, int maximizer, bool maximizerTurn) {
  final line = ticWinningLine(cells);
  if (line != null) {
    final winner = cells[ticLines[line][0]];
    return winner == maximizer ? 1 : -1;
  }
  final legal = ticLegalMoves(cells);
  if (legal.isEmpty) {
    return 0;
  }
  var best = maximizerTurn ? -99 : 99;
  for (final index in legal) {
    final trial = List<int>.of(cells);
    trial[index] = toMove;
    final score = _minimax(trial, _other(toMove), maximizer, !maximizerTurn);
    if (maximizerTurn) {
      if (score > best) {
        best = score;
      }
    } else if (score < best) {
      best = score;
    }
  }
  return best;
}
