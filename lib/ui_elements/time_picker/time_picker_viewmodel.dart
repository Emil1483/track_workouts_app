import 'package:flutter/material.dart';
import 'package:track_workouts/data/model/picked_time/picked_time.dart';
import 'package:track_workouts/routes/base/base_model.dart';
import 'package:track_workouts/ui_elements/time_picker/spinner_viewmodel.dart';

class TimePickerViewmodel extends BaseModel {
  static const int secondInterval = 15;

  final double height;
  final SpinnerViewmodel minuteModel;
  final SpinnerViewmodel secondModel;

  TimePickerViewmodel({@required this.height})
      : minuteModel = SpinnerViewmodel(
          controller: ScrollController(initialScrollOffset: (height / 3) * 60 * 10 - (height / 3)),
          interval: 1,
          itemHeight: (height / 3),
        ),
        secondModel = SpinnerViewmodel(
          controller: ScrollController(initialScrollOffset: (height / 3) * 60 * 10 / secondInterval - (height / 3)),
          interval: secondInterval,
          itemHeight: (height / 3),
        );

  PickedTime get selectedTime {
    return PickedTime(
      minutes: minuteModel.selectedIndex % 60,
      seconds: (secondModel.selectedIndex % (60 / secondInterval)).round() * secondInterval,
    );
  }
}
