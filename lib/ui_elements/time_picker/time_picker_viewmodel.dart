import 'package:flutter/material.dart';
import 'package:track_workouts/routes/base/base_model.dart';

class TimePickerViewmodel extends BaseModel {
  final ScrollController minuteController;
  final ScrollController secondController;

  TimePickerViewmodel(double itemHeight)
      : minuteController = ScrollController(initialScrollOffset: itemHeight * 60 * 10),
        secondController = ScrollController(initialScrollOffset: itemHeight * 60 * 10);
}
