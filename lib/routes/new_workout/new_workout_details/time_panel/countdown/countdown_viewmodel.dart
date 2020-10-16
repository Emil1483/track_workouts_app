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

  CountdownViewmodel(BuildContext context, {@required double timePickerHeight})
      : timePanelService = Provider.of<TimePanelService>(context, listen: false),
        timePickerModel = TimePickerViewmodel(height: timePickerHeight);

  PickedTime get pickedTime => timePanelService.countdownTime;

  bool get selectingTime => pickedTime == null;

  bool get pickedTimeNotSelected => selectingTime && timePickerModel.selectedTime.isZero;

  AnimationController get controller => _controller;

  double get countdownValue => 1 - _controller.value;

  bool get isCountingDown => _controller.isAnimating;

  void addSpinnerListener() => timePickerModel.addListener(notifyListeners);

  void buildAnimationController({@required TickerProvider vsync}) {
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
        timePanelService.countdownTime = null;
        return;
      }

      _controller.value = 1 - timeLeft / countdownData.countdownTime;

      if (notStopped) _controller.animateTo(1, duration: timeLeft);
    }

    _controller.addListener(() async {
      if (_controller.value == 1) {
        timePanelService.onCountdownDone(timePanelService.countdownTime);

        timePanelService.countdownTime = null;
        notifyListeners();

        await timePanelService.player.play('done.mp3');
      }
    });
  }

  void startCountdown() {
    final time = timePickerModel.selectedTime.copy();
    timePanelService.countdownTime = time;
    _controller.value = 0;
    _controller.animateTo(1, duration: time.toDuration);

    notifyListeners();
  }

  void startStopCountdown() {
    if (_controller.isAnimating) {
      _controller.stop();
    } else {
      _controller.animateTo(1, duration: timePanelService.countdownTime.toDuration * countdownValue);
    }

    notifyListeners();
  }

  void cancelCountdown() {
    timePanelService.countdownTime = null;
    _controller.stop();
    notifyListeners();
  }

  @override
  void dispose() {
    final countdownTime = timePanelService.countdownTime;
    if (countdownTime != null) {
      timePanelService.saveCountdown(
        SavedCountdown(
          countdownTime: countdownTime,
          leftOfCountdown: countdownTime.toDuration * countdownValue,
          countdownDisposedAt: DateTime.now(),
          stopped: !_controller.isAnimating,
        ),
      );
    }
    _controller.dispose();
    super.dispose();
  }
}
