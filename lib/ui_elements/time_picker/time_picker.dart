import 'package:flutter/material.dart';
import 'package:track_workouts/routes/base/base_widget.dart';
import 'package:track_workouts/style/theme.dart';
import 'package:track_workouts/ui_elements/time_picker/spinner_viewmodel.dart';
import 'package:track_workouts/ui_elements/time_picker/time_picker_viewmodel.dart';

class _ItemScrollPhysics extends ScrollPhysics {
  final double itemHeight;
  final double targetPixelsLimit;

  const _ItemScrollPhysics({
    ScrollPhysics parent,
    this.itemHeight,
    this.targetPixelsLimit = 3.0,
  })  : assert(itemHeight != null && itemHeight > 0),
        super(parent: parent);

  @override
  _ItemScrollPhysics applyTo(ScrollPhysics ancestor) {
    return _ItemScrollPhysics(parent: buildParent(ancestor), itemHeight: itemHeight);
  }

  double _getItem(ScrollPosition position) {
    double maxScrollItem = (position.maxScrollExtent / itemHeight).floorToDouble();
    return (position.pixels / itemHeight).clamp(0, maxScrollItem);
  }

  double _getPixels(ScrollPosition position, double item) {
    return item * itemHeight;
  }

  double _getTargetPixels(ScrollPosition position, Tolerance tolerance, double velocity) {
    double item = _getItem(position);
    if (velocity < -tolerance.velocity)
      item -= targetPixelsLimit;
    else if (velocity > tolerance.velocity) item += targetPixelsLimit;
    return _getPixels(position, item.roundToDouble());
  }

  @override
  Simulation createBallisticSimulation(ScrollMetrics position, double velocity) {
    final double target = _getTargetPixels(position, tolerance, velocity);
    if (target != position.pixels) return ScrollSpringSimulation(spring, position.pixels, target, velocity, tolerance: tolerance);
    return null;
  }

  @override
  bool get allowImplicitScrolling => false;
}

class TimePicker extends StatelessWidget {
  static const double defaultHeight = 198.0;

  final TimePickerViewmodel model;
  final double height;

  TimePicker({
    @required this.model,
    this.height = defaultHeight,
  });

  @override
  Widget build(BuildContext context) {
    return BaseWidget<TimePickerViewmodel>(
      model: model,
      builder: (context, model, child) => Container(
        height: height,
        padding: EdgeInsets.symmetric(horizontal: 32.0),
        child: Row(
          children: [
            Expanded(
              child: _Spinner(model: model.minuteModel),
            ),
            Expanded(
              child: _Spinner(model: model.secondModel),
            ),
          ],
        ),
      ),
    );
  }
}

class _Spinner extends StatelessWidget {
  final SpinnerViewmodel model;

  _Spinner({@required this.model});

  @override
  Widget build(BuildContext context) {
    return BaseWidget<SpinnerViewmodel>(
      model: model,
      builder: (context, model, child) => NotificationListener<ScrollNotification>(
        onNotification: (notification) => model.onScrollNotification(notification, context),
        child: ListView.builder(
          controller: model.controller,
          physics: _ItemScrollPhysics(itemHeight: model.itemHeight),
          itemBuilder: (context, index) => GestureDetector(
            onTap: () => model.animateToIndex(index),
            child: Container(
              alignment: Alignment.center,
              height: model.itemHeight,
              child: Text(
                (index * model.interval % 60).toString().padLeft(2, '0'),
                style: getTextStyle(TextStyles.h0).copyWith(
                  color: model.selectedIndex == index ? AppColors.white : AppColors.disabled,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
