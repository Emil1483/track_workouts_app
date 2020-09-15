extension DateTimeUtils on DateTime {
  DateTime get flooredToDay => DateTime(year, month, day);

  DateTime get flooredToWeek => flooredToDay.subtract(Duration(days: weekday - 1));

  bool get isInFuture => this.isAfter(DateTime.now());

  DateTime copy() => this == null ? null : DateTime.parse(this.toIso8601String());

  int weeksUntil(DateTime otherWeek) {
    final diff = otherWeek.difference(this).inHours / (24 * 7);
    return diff.round();
  }
}
