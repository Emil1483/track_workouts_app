import 'package:flutter/material.dart';

class PickedTime {
  final int minutes;
  final int seconds;

  PickedTime({@required this.minutes, @required this.seconds});

  int get inSeconds => minutes * 60 + seconds;
}
