class SuggestedWeight {
  final double value;
  final bool isTooMuch;

  SuggestedWeight(
    this.value, {
    this.isTooMuch = false,
  });

  SuggestedWeight copy() => SuggestedWeight(value, isTooMuch: isTooMuch);
}
