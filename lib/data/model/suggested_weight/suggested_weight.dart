class SuggestedWeight {
  final double value;
  final bool isTooMuch;

  SuggestedWeight(
    this.value, {
    this.isTooMuch = false,
  });

  factory SuggestedWeight.from(double maxWeight, {bool isTooMuch = false}) {
    if (maxWeight == null) return null;
    return SuggestedWeight(maxWeight, isTooMuch: isTooMuch);
  }

  SuggestedWeight copy() => SuggestedWeight(value, isTooMuch: isTooMuch);
}
