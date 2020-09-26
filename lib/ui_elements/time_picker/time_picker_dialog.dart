import 'package:flutter/material.dart';
import 'package:track_workouts/data/model/picked_time/picked_time.dart';
import 'package:track_workouts/handlers/router.dart';
import 'package:track_workouts/style/theme.dart';
import 'package:track_workouts/ui_elements/main_button.dart';
import 'package:track_workouts/ui_elements/time_picker/time_picker.dart';

class TimePickerDialog {
  static Future<PickedTime> showTimePicker(BuildContext context) {
    final timerKey = GlobalKey<TimePickerState>();
    return showDialog<PickedTime>(
      context: context,
      builder: (context) => SimpleDialog(
        backgroundColor: AppColors.black500,
        title: Text('Break', textAlign: TextAlign.center),
        titleTextStyle: getTextStyle(TextStyles.h1),
        contentPadding: EdgeInsets.only(top: 16.0),
        children: [
          TimePicker(key: timerKey),
          MainButton(
            onTap: () => Router.pop(timerKey.currentState.selectedTime),
            text: 'Save Break Time',
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(4.0),
              bottomRight: Radius.circular(4.0),
            ),
          ),
        ],
      ),
    );
  }
}
