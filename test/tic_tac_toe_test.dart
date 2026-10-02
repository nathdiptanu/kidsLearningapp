import 'package:flutter_test/flutter_test.dart';
import 'package:sproutlab/domain/games/tictactoe/tic_tac_toe.dart';

void main() {
  const engine = TicTacToeEngine();

  test('every line can win and a full board can draw', () {
    for (final line in ticLines) {
      final cells = List<int>.filled(9, 0);
      for (final index in line) {
        cells[index] = TicState.child;
      }
      expect(ticWinningLine(cells), isNotNull);
    }
    expect(ticWinningLine(const [1, 2, 1, 1, 2, 1, 2, 1, 2]), isNull);
    expect(ticBoardFull(const [1, 2, 1, 1, 2, 1, 2, 1, 2]), isTrue);
  });

  test('occupied cells and the opponent turn are ignored', () {
    final started = engine.create(variant: 0, seed: 4);
    final played = engine.reduce(started, const TicAction.play(0));
    final blocked = engine.reduce(played, const TicAction.play(0));
    expect(blocked.cells[0], TicState.child);
    expect(blocked.childTurn, isFalse);
    final duringOpponent = engine.reduce(played, const TicAction.play(1));
    expect(duringOpponent.cells, played.cells);
  });

  test('turns alternate, reset, and the opponent is deterministic', () {
    final first = engine.create(variant: 0, seed: 9);
    final afterChild = engine.reduce(first, const TicAction.play(4));
    final afterOpponent = engine.reduce(afterChild, const TicAction.opponent());
    expect(afterOpponent.childTurn, isTrue);
    expect(
      afterOpponent.cells.where((cell) => cell == TicState.opponent),
      hasLength(1),
    );
    final again = engine.reduce(
      engine.reduce(
        engine.create(variant: 0, seed: 9),
        const TicAction.play(4),
      ),
      const TicAction.opponent(),
    );
    expect(again.cells, afterOpponent.cells);
    final reset = engine.reduce(afterOpponent, const TicAction.reset());
    expect(reset.cells, first.cells);
    expect(reset.childTurn, isTrue);
    expect(reset.finished, isFalse);
  });

  test('a finishing move records one result and a hint does not play', () {
    var state = TicState(
      cells: const [1, 1, 0, 2, 2, 0, 0, 0, 0],
      childTurn: true,
      difficulty: TicDifficulty.beginner,
      seed: 1,
      opening: const [0, 0, 0, 0, 0, 0, 0, 0, 0],
      openingChildTurn: true,
    );
    state = engine.reduce(state, const TicAction.play(2));
    expect(state.outcome, TicOutcome.childWin);
    expect(state.winLine, 0);
    final hinted = engine.reduce(
      engine.create(variant: 1, seed: 3),
      const TicAction.hint(),
    );
    expect(hinted.hintsUsed, 1);
    expect(hinted.hintIndex, isNotNull);
    expect(hinted.cells.where((cell) => cell != 0), isEmpty);
    final second = engine.reduce(hinted, const TicAction.hint());
    expect(second.hintsUsed, 1);
  });

  test('challenge moves stay legal and finish quickly', () {
    for (var seed = 0; seed < 30; seed++) {
      var state = engine.create(variant: 2, seed: seed);
      var guard = 0;
      while (!state.finished && guard < 12) {
        if (state.childTurn) {
          final move = chooseTicMove(
            cells: state.cells,
            difficulty: TicDifficulty.challenge,
            seed: seed,
            ply: state.ply,
            mark: TicState.child,
          );
          expect(state.cells[move], 0);
          state = engine.reduce(state, TicAction.play(move));
        } else {
          state = engine.reduce(state, const TicAction.opponent());
        }
        guard += 1;
      }
      expect(state.finished, isTrue);
    }
  });
}
