import 'package:flutter/cupertino.dart';

class SuggestedWeight {
  final double min;
  final double max;

  SuggestedWeight({
    @required this.min,
    @required this.max,
  });

  bool get isNotEmpty => min != null || max != null;

  SuggestedWeight copy() => SuggestedWeight(min: min, max: max);
}
