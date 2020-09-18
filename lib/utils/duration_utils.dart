extension DurationUtils on Duration {
  String get formatMinuteSeconds {
    final minutes = inMinutes;
    final seconds = inSeconds - inMinutes * 60;
    String result = '$minutes minute';
    if (seconds > 0) {
      result += ' $seconds second';
      if (seconds > 1) result += 's';
    }
    return result;
  }
}
