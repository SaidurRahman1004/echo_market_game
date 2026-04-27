enum GameStatus { playing, paused, gameOver, menu }

class RunSession {
  GameStatus status;
  double distance;
  int score;
  int coins;
  int shards;

  bool get isPlaying => status == GameStatus.playing;

  RunSession({
    this.status = GameStatus.menu,
    this.distance = 0.0,
    this.score = 0,
    this.coins = 0,
    this.shards = 0,
  });

  void reset() {
    status = GameStatus.playing;
    distance = 0.0;
    score = 0;
    coins = 0;
    shards = 0;
  }
}
