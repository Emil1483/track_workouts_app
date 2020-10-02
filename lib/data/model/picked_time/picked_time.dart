import 'package:flutter/material.dart';

class PickedTime {
  final int minutes;
  final int seconds;

  PickedTime({@required this.minutes, @required this.seconds});

  static PickedTime zero = PickedTime(minutes: 0, seconds: 0);

  factory PickedTime.fromDuration(Duration duration) {
    return PickedTime(
      minutes: duration.inMinutes % 60,
      seconds: duration.inSeconds % 60,
    );
  }

  int get inSeconds => minutes * 60 + seconds;

  Duration get toDuration => Duration(minutes: minutes, seconds: seconds);

  PickedTime operator *(double value) {
    final totalSeconds = (inSeconds * value).ceil();
    final minutes = (totalSeconds / 60).floor();
    final seconds = totalSeconds % 60;
    return PickedTime(minutes: minutes, seconds: seconds);
  }

  bool get isZero => minutes == 0 && seconds == 0;

  @override
  String toString() {
    final minutesString = minutes.toString().padLeft(2, '0');
    final secondsString = seconds.toString().padLeft(2, '0');
    return '$minutesString : $secondsString';
  }

  PickedTime copy() => PickedTime(minutes: minutes, seconds: seconds);
}
