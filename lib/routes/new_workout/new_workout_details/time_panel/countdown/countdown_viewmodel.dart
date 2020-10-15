import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:track_workouts/data/model/picked_time/picked_time.dart';
import 'package:track_workouts/data/services/time_panel_service.dart';
import 'package:track_workouts/routes/base/base_model.dart';
import 'package:track_workouts/ui_elements/time_picker/time_picker_viewmodel.dart';

class CountdownViewmodel extends BaseModel {
  final TimePickerViewmodel timePickerModel;
  final TimePanelService timePanelService;

  CountdownViewmodel(BuildContext context, {@required double timePickerHeight})
      : timePanelService = Provider.of<TimePanelService>(context, listen: false),
        timePickerModel = TimePickerViewmodel(height: timePickerHeight);

  PickedTime get pickedTime => timePanelService.countdownTime;

  bool get selectingTime => pickedTime == null;

  bool get pickedTimeNotSelected => timePickerModel.selectedTime.isZero;


  AnimationController get controller => timePanelService.countdownController;

  double get countdownValue => timePanelService.countdownValue;

  bool get isCountingDown => controller.isAnimating;

  void addSpinnerListener() => timePickerModel.addListener(notifyListeners);

  void buildAnimationController({@required TickerProvider vsync}) {
    timePanelService.initCountdownController(vsync);
  }

  void startCountdown() {
    timePanelService.startCountdown(timePickerModel.selectedTime);

    notifyListeners();
  }

  void startStopCountdown() {
    if (selectingTime) return;

    timePanelService.startStopCountdown();

    notifyListeners();
  }

  void cancelCountdown() {
    if (selectingTime) return;

    timePanelService.cancelCountdown();
    notifyListeners();
  }

  @override
  void dispose() {
    timePanelService.disposeCountdownController();
    super.dispose();
  }
}
