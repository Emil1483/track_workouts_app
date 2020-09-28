import 'package:flutter/material.dart';

class PickedTime {
  final int minutes;
  final int seconds;

  PickedTime({@required this.minutes, @required this.seconds});

  int get inSeconds => minutes * 60 + seconds;

  Duration get toDuration => Duration(minutes: minutes, seconds: seconds);

  PickedTime operator *(double value) {
    final totalSeconds = (inSeconds * value).ceil();
    final minutes = (totalSeconds / 60).floor();
    final seconds = totalSeconds % 60;
    return PickedTime(minutes: minutes, seconds: seconds);
  }

  @override
  String toString() {
    final minutesString = minutes.toString().padLeft(2, '0');
    final secondsString = seconds.toString().padLeft(2, '0');
    return '$minutesString : $secondsString';
  }
}
