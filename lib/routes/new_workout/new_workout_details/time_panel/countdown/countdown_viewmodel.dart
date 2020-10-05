import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:track_workouts/data/model/picked_time/picked_time.dart';
import 'package:track_workouts/data/model/workouts/workout/workout.dart';
import 'package:track_workouts/routes/base/base_model.dart';
import 'package:track_workouts/routes/new_workout/new_workout_details/new_exercise_details_viewmodel.dart';
import 'package:track_workouts/ui_elements/time_picker/time_picker_viewmodel.dart';

class CountdownViewmodel extends BaseModel {
  final GlobalKey timerContainerKey = GlobalKey();
  final AudioCache _player = AudioCache(prefix: 'assets/sounds/');

  final TimePickerViewmodel timePickerModel;

  AnimationController _controller;

  PickedTime _pickedTime;
  double _timePickerHeight;

  CountdownViewmodel({@required double timePickerHeight}) : timePickerModel = TimePickerViewmodel(height: timePickerHeight);

  PickedTime get pickedTime => _pickedTime?.copy();

  bool get selectingTime => _pickedTime == null;

  bool get pickedTimeNotSelected => timePickerModel.selectedTime.isZero;

  double get timePickerHeight => _timePickerHeight;

  AnimationController get controller => _controller;

  double get countdownValue => 1 - _controller.value;

  void addSpinnerListener() => timePickerModel.addListener(notifyListeners);

  void buildAnimationController(BuildContext context, {@required TickerProvider vsync}) {
    final model = Provider.of<NewExerciseDetailsViewmodel>(context, listen: false);
    _controller = AnimationController(vsync: vsync);
    _controller.addListener(() async {
      if (_controller.value == 1) {
        if (model.modifyIfPossible(_pickedTime.inSeconds.toDouble(), AttributeName.pre_break)) {
          model.panelController.close();
        }

        await _player.play('done.mp3');

        await Future.delayed(Duration(milliseconds: 100));
        _pickedTime = null;
        notifyListeners();
      }
    });
  }

  void startCountdown() {
    _pickedTime = timePickerModel.selectedTime;
    _timePickerHeight = timerContainerKey.currentContext.size.height;

    _controller.value = 0;
    _controller.animateTo(1, duration: _pickedTime.toDuration);

    notifyListeners();
  }

  bool get isCountingDown => _controller.isAnimating;

  void startStopCountdown() {
    if (selectingTime) return;

    if (isCountingDown) {
      _controller.stop();
    } else {
      _controller.animateTo(1, duration: _pickedTime.toDuration * countdownValue);
    }
    notifyListeners();
  }

  void cancelCountdown() {
    if (selectingTime) return;

    _pickedTime = null;
    notifyListeners();

    _controller.stop();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
