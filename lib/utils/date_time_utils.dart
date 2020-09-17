import 'package:intl/intl.dart';

extension DateTimeUtils on DateTime {
  DateTime get flooredToDay => DateTime(year, month, day);

  DateTime get flooredToWeek => flooredToDay.subtract(Duration(days: weekday - 1));

  bool get isInFuture => this.isAfter(DateTime.now());

  DateTime copy() => this == null ? null : DateTime.parse(this.toIso8601String());

  int weeksUntil(DateTime otherWeek) {
    final diff = otherWeek.difference(this).inHours / (24 * 7);
    return diff.round();
  }

  String get formatDayMonthDate => DateFormat('EEEE, MMM. d').format(this) + dateSuperScript;

  String get dateSuperScript {
    final dateString = DateFormat('d').format(this);
    final date = int.parse(dateString);
    final lastDigit = int.parse(dateString.substring(dateString.length - 1));

    if (date > 10 && date < 30) return 'th';

    if (lastDigit == 1) return 'st';
    if (lastDigit == 2) return 'nd';
    if (lastDigit == 3) return 'rd';

    return 'th';
  }
}
