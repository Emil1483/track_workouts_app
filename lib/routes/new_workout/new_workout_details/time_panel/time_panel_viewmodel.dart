import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:track_workouts/data/model/picked_time/picked_time.dart';
import 'package:track_workouts/routes/base/base_model.dart';
import 'package:track_workouts/routes/new_workout/new_workout_details/new_exercise_details_viewmodel.dart';
import 'package:track_workouts/ui_elements/time_picker/time_picker_viewmodel.dart';

class TimePanelViewmodel extends BaseModel {
  final GlobalKey timerContainerKey = GlobalKey();

  final TimePickerViewmodel timePickerModel;

  AnimationController _controller;

  PickedTime _pickedTime;
  double _timePickerHeight;

  TimePanelViewmodel({@required double timePickerHeight}) : timePickerModel = TimePickerViewmodel(height: timePickerHeight);

  PickedTime get pickedTime => _pickedTime?.copy();

  double get timePickerHeight => _timePickerHeight;

  AnimationController get controller => _controller;

  double get countdownValue => 1 - _controller.value;

  void buildAnimationController(BuildContext context, {@required TickerProvider vsync}) {
    final model = Provider.of<NewExerciseDetailsViewmodel>(context, listen: false);
    _controller = AnimationController(vsync: vsync);
    _controller.addListener(() async {
      if (_controller.value == 1) {
        model.panelController.close();
        model.modifyPreBreakIfPossible(_pickedTime);

        await Future.delayed(Duration(milliseconds: 500));

        final copiedTime = _pickedTime.copy();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          timePickerModel.jumpToTime(copiedTime);
        });
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}