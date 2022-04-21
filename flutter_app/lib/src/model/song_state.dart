class SongState {
  static const double DEFAULT_FONT_SIZE = 16;
  int transpose = 0;
  double fontSize = DEFAULT_FONT_SIZE;

  SongState();

  factory SongState.withTranspose(int transpose) {
    var songState = SongState();
    songState.transpose = transpose;
    return songState;
  }
}
