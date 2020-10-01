import 'package:flutter/material.dart';
import 'package:track_workouts/data/model/picked_time/picked_time.dart';
import 'package:track_workouts/routes/base/base_model.dart';
import 'package:track_workouts/ui_elements/time_picker/spinner_viewmodel.dart';

class TimePickerViewmodel extends BaseModel {
  static const int secondInterval = 5;

  final double height;
  SpinnerViewmodel minuteModel;
  SpinnerViewmodel secondModel;

  TimePickerViewmodel({@required this.height}) {
    minuteModel = SpinnerViewmodel(
      controller: ScrollController(initialScrollOffset: _getInitialOffset(1)),
      interval: 1,
      itemHeight: (height / 3),
    );
    secondModel = SpinnerViewmodel(
      controller: ScrollController(initialScrollOffset: _getInitialOffset(secondInterval)),
      interval: secondInterval,
      itemHeight: (height / 3),
    );

    minuteModel.addListener(notifyListeners);
    secondModel.addListener(notifyListeners);
  }

  PickedTime get selectedTime {
    return PickedTime(
      minutes: minuteModel.selectedIndex % 60,
      seconds: (secondModel.selectedIndex % (60 / secondInterval)).round() * secondInterval,
    );
  }

  _getInitialOffset(int interval) => (height / 3) * 60 * 10 / interval - (height / 3);

  void animateTo(PickedTime time) {
    minuteModel.jumpTo(time.minutes);
    secondModel.jumpTo(time.seconds);
  }
}
