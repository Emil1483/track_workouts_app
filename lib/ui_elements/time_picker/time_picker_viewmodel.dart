import 'package:flutter/material.dart';
import 'package:track_workouts/data/model/picked_time/picked_time.dart';
import 'package:track_workouts/routes/base/base_model.dart';
import 'package:track_workouts/ui_elements/time_picker/spinner_viewmodel.dart';

class TimePickerViewmodel extends BaseModel {
  static const int secondInterval = 15;

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
  }

  PickedTime get selectedTime {
    return PickedTime(
      minutes: minuteModel.selectedIndex % 60,
      seconds: (secondModel.selectedIndex % (60 / secondInterval)).round() * secondInterval,
    );
  }

  _getInitialOffset(int interval) => (height / 3) * 60 * 10 / interval - (height / 3);

  _getClosestIndex(SpinnerViewmodel model, int index) {
    final offset = model.controller.offset;
    final currentIndex = (offset / model.itemHeight).round() + 1;
    final currentNormalizedIndex = currentIndex % (60 / model.interval);
    final normalizedIndex = index % (60 / model.interval);
    final diff = normalizedIndex - currentNormalizedIndex;
    return currentIndex + diff;
  }

  _getOffsetFromValue(SpinnerViewmodel model, int value) {
    return (_getClosestIndex(model, (value / model.interval).round()) - 1) * model.itemHeight;
  }

  void jumpToTime(PickedTime newTime) {
    final minuteOffset = _getOffsetFromValue(minuteModel, newTime.minutes);
    final secondOffset = _getOffsetFromValue(secondModel, newTime.seconds);
    minuteModel.controller.jumpTo(minuteOffset);
    secondModel.controller.jumpTo(secondOffset);
  }
}
