import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:track_workouts/data/model/picked_time/picked_time.dart';
import 'package:track_workouts/data/services/time_panel_service.dart';
import 'package:track_workouts/routes/base/base_model.dart';
import 'package:track_workouts/ui_elements/time_picker/time_picker_viewmodel.dart';
import 'package:track_workouts/utils/duration_utils.dart';

class CountdownViewmodel extends BaseModel {
  final TimePickerViewmodel timePickerModel;
  final TimePanelService timePanelService;

  AnimationController _controller;
  PickedTime _pickedTime;

  CountdownViewmodel(BuildContext context, {@required double timePickerHeight})
      : timePanelService = Provider.of<TimePanelService>(context, listen: false),
        timePickerModel = TimePickerViewmodel(height: timePickerHeight);

  PickedTime get pickedTime => _pickedTime?.copy();

  bool get selectingTime => _pickedTime == null;

  bool get pickedTimeNotSelected => selectingTime && timePickerModel.selectedTime.isZero;

  AnimationController get controller => _controller;

  double get countdownValue => 1 - _controller.value;

  bool get isCountingDown => _controller.isAnimating;

  void addSpinnerListener() => timePickerModel.addListener(notifyListeners);

  void buildAnimationController({@required TickerProvider vsync}) {
    timePanelService.cancelAlarm();

    if (_controller != null) return;
    _controller = AnimationController(vsync: vsync);

    final countdownData = timePanelService.savedCountdown;
    if (countdownData != null) {
      timePanelService.deleteSavedCountdown();

      final timeDifference = DateTime.now().difference(countdownData.countdownDisposedAt);
      final notStopped = !countdownData.stopped;

      Duration timeLeft = countdownData.leftOfCountdown;
      if (notStopped) timeLeft -= timeDifference;

      if (timeLeft.isNegative) {
        _pickedTime = null;
        return;
      }

      _pickedTime = countdownData.countdownTime;

      _controller.value = 1 - timeLeft / countdownData.countdownTime;

      if (notStopped) _controller.animateTo(1, duration: timeLeft);
    }

    _controller.addListener(() async {
      if (_controller.value == 1) {
        timePanelService.onCountdownDone(_pickedTime);

        _pickedTime = null;
        notifyListeners();

        await timePanelService.playDoneSound();
      }
    });
  }

  void startCountdown() {
    final time = timePickerModel.selectedTime.copy();
    _pickedTime = time;
    _controller.value = 0;
    _controller.animateTo(1, duration: time.toDuration);

    notifyListeners();
  }

  void startStopCountdown() {
    if (_controller.isAnimating) {
      _controller.stop();
    } else {
      _controller.animateTo(1, duration: _pickedTime.toDuration * countdownValue);
    }

    notifyListeners();
  }

  void cancelCountdown() {
    _pickedTime = null;
    _controller.stop();
    notifyListeners();
  }

  @override
  void dispose() {
    if (_pickedTime != null) {
      final leftOfCountdown = _pickedTime.toDuration * countdownValue;
      final stopped = !_controller.isAnimating;

      if (!stopped) timePanelService.setAlarm(leftOfCountdown);

      timePanelService.saveCountdown(
        SavedCountdown(
          countdownTime: _pickedTime,
          leftOfCountdown: leftOfCountdown,
          countdownDisposedAt: DateTime.now(),
          stopped: stopped,
        ),
      );
    }

    _controller.dispose();

    super.dispose();
  }
}
