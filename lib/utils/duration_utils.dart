import 'package:track_workouts/data/model/picked_time/picked_time.dart';

extension DurationUtils on Duration {
  String get formatMinuteSeconds {
    if (inSeconds == 0) return null;
    String result = '';

    final minutes = inMinutes;
    final seconds = inSeconds - inMinutes * 60;

    if (minutes > 0) result += '$minutes minute';
    if (seconds > 0) {
      result += ' $seconds second';
      if (seconds > 1) result += 's';
    }
    return result;
  }

  String get breakText {
    final minuteSeconds = formatMinuteSeconds;
    if (minuteSeconds == null) return 'no break';
    return '$minuteSeconds break';
  }

  double operator /(PickedTime pickedTime) => inMilliseconds / pickedTime.inMilliseconds;

  Duration copy() => Duration(microseconds: inMicroseconds);
}
