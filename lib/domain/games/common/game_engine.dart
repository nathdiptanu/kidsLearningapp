import '../../models/game_result.dart';

abstract interface class GameEngine<C, S, A> {
  S create({required C config, required int seed});

  S reduce(S state, A action);

  bool isComplete(S state);

  GameResult result(S state);
}
