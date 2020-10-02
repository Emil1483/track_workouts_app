import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:track_workouts/data/model/picked_time/picked_time.dart';
import 'package:track_workouts/data/model/workouts/workout/workout.dart';
import 'package:track_workouts/routes/base/base_model.dart';
import 'package:track_workouts/routes/new_workout/new_workout_details/new_exercise_details_viewmodel.dart';
import 'package:track_workouts/style/theme.dart';

class TimerViewmodel extends BaseModel {
  final NewExerciseDetailsViewmodel model;

  Duration _currentTime = Duration();
  Timer _timer;
  DateTime _timerStart;

  TimerViewmodel(BuildContext context) : model = Provider.of<NewExerciseDetailsViewmodel>(context, listen: false);

  PickedTime get currentTime => PickedTime.fromDuration(_currentTime);

  bool get isTiming => _timer != null;

  bool get hasStarted => isTiming || _currentTime.inMilliseconds > 0;

  double get _periodicValue {
    final seconds = _currentTime.inSeconds;
    return -math.cos(seconds * math.pi / 60) / 2 + 0.5;
  }

  Color get borderColor => Color.lerp(AppColors.accent, AppColors.accent900, _periodicValue);

  double get borderWidth => lerpDouble(1, 4, _periodicValue);

  void startStopTimer() {
    if (isTiming) {
      _currentTime = DateTime.now().difference(_timerStart);
      _timer.cancel();
      _timer = null;
    } else {
      _timerStart = DateTime.now().subtract(_currentTime);
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        _currentTime += Duration(seconds: 1);
        notifyListeners();
      });
    }
    notifyListeners();
  }

  void cancelTimer() {
    if (model.modifyIfPossible(currentTime, AttributeName.time)) model.panelController.close();
    _currentTime = Duration();
    _timer?.cancel();
    _timer = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
