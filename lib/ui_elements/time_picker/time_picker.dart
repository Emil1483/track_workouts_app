import 'package:flutter/material.dart';
import 'package:track_workouts/routes/base/base_widget.dart';
import 'package:track_workouts/style/theme.dart';
import 'package:track_workouts/ui_elements/time_picker/spinner_viewmodel.dart';
import 'package:track_workouts/ui_elements/time_picker/time_picker_viewmodel.dart';

class TimePicker extends StatelessWidget {
  final double height;
  final double width;

  const TimePicker({
    this.height = 198.0,
    this.width = 256.0,
  });

  @override
  Widget build(BuildContext context) {
    return BaseWidget<TimePickerViewmodel>(
      model: TimePickerViewmodel(height / 3),
      builder: (context, model, child) => Container(
        height: height,
        width: width,
        padding: EdgeInsets.symmetric(horizontal: 32.0),
        child: Row(
          children: [
            Expanded(
              child: _Spinner(
                controller: model.minuteController,
                itemHeight: height / 3,
              ),
            ),
            Expanded(
              child: _Spinner(
                controller: model.secondController,
                itemHeight: height / 3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Spinner extends StatelessWidget {
  final controller;
  final itemHeight;

  const _Spinner({@required this.controller, @required this.itemHeight});

  @override
  Widget build(BuildContext context) {
    return BaseWidget<SpinnerViewmodel>(
      model: SpinnerViewmodel(controller: controller, itemHeight: itemHeight),
      builder: (context, model, child) => NotificationListener<ScrollNotification>(
        onNotification: model.onScrollNotification,
        child: ListView.builder(
          controller: controller,
          itemBuilder: (context, index) => Container(
            alignment: Alignment.center,
            height: itemHeight,
            child: Text(
              (index % 60).toString().padLeft(2, '0'),
              style: getTextStyle(TextStyles.h0).copyWith(
                color: model.selectedIndex == index ? AppColors.white : AppColors.disabled,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
