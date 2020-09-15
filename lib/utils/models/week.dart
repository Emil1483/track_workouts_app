import 'package:track_workouts/utils/date_time_utils.dart';

class Week {
  final DateTime _weekStart;

  Week(DateTime weekStart) : _weekStart = weekStart.flooredToWeek;

  DateTime get start => _weekStart.copy();
  DateTime get end => _weekStart.add(Duration(days: 6));

  bool contains(DateTime date) {
    if (start.isAfter(date)) return false;
    if (end.isBefore(date)) return false;
    return true;
  }

  Week copy() => Week(_weekStart);

  int get weekNumber {
    DateTime startOfYear = DateTime(_weekStart.year, 1, 1, 0, 0);
    DateTime weekOne;
    if (startOfYear.weekday > 4) {
      weekOne = startOfYear.add(Duration(days: 7)).flooredToWeek;
    } else {
      weekOne = startOfYear.flooredToWeek;
    }
    return (_weekStart.difference(weekOne).inHours / (24 * 7)).round();
  }

  String get weekString => 'Week $weekNumber';
}