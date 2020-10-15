extension NumUtils on num {
  Duration toDurationFromSeconds() => this == null ? null : Duration(seconds: round());

  String get withMaxTwoDecimals {
    String result;
    for (int i = 0; i <= 2; i++) {
      result = toStringAsFixed(i);
      if (num.parse(result) == this) return result;
    }
    return result;
  }
}
