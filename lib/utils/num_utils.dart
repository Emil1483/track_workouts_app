extension NumUtils on num {
  Duration toDurationFromSeconds() => this == null ? null : Duration(seconds: round());
}