import 'package:flutter/material.dart';
import 'package:track_workouts/routes/base/base_widget.dart';
import 'package:track_workouts/style/theme.dart';
import 'package:track_workouts/ui_elements/time_picker/spinner_viewmodel.dart';
import 'package:track_workouts/ui_elements/time_picker/time_picker_viewmodel.dart';

class PickedTime {
  final int minutes;
  final int seconds;

  PickedTime({@required this.minutes, @required this.seconds});
}

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

class TimePicker extends StatefulWidget {
  final double height;
  final double width;

  const TimePicker({
    this.height = 198.0,
    this.width = 256.0,
    Key key,
  }) : super(key: key);

  @override
  _TimePickerState createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  final GlobalKey<_SpinnerState> minuteKey = GlobalKey<_SpinnerState>();
  final GlobalKey<_SpinnerState> secondKey = GlobalKey<_SpinnerState>();

  PickedTime get selectedTime {
    final minuteIndex = minuteKey.currentState.getSelectedIndex();
    final secondIndex = secondKey.currentState.getSelectedIndex();
    return PickedTime(
      minutes: minuteIndex % 60,
      seconds: (secondIndex % (60 / TimePickerViewmodel.secondInterval)).round(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget<TimePickerViewmodel>(
      model: TimePickerViewmodel(widget.height / 3),
      builder: (context, model, child) => Container(
        height: widget.height,
        width: widget.width,
        padding: EdgeInsets.symmetric(horizontal: 32.0),
        child: Row(
          children: [
            Expanded(
              child: _Spinner(
                key: minuteKey,
                controller: model.minuteController,
                itemHeight: widget.height / 3,
              ),
            ),
            Expanded(
              child: _Spinner(
                key: secondKey,
                controller: model.secondController,
                itemHeight: widget.height / 3,
                interval: TimePickerViewmodel.secondInterval,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Spinner extends StatefulWidget {
  final ScrollController controller;
  final double itemHeight;
  final int interval;

  const _Spinner({Key key, @required this.controller, @required this.itemHeight, this.interval = 1}) : super(key: key);

  @override
  _SpinnerState createState() => _SpinnerState();
}

class _SpinnerState extends State<_Spinner> {
  int Function() getSelectedIndex;

  @override
  Widget build(BuildContext context) {
    return BaseWidget<SpinnerViewmodel>(
      model: SpinnerViewmodel(widget.controller, widget.itemHeight, widget.interval),
      onModelReady: (model) => getSelectedIndex = model.getSelectedIndex,
      builder: (context, model, child) => NotificationListener<ScrollNotification>(
        onNotification: model.onScrollNotification,
        child: ListView.builder(
          controller: widget.controller,
          physics: _ItemScrollPhysics(itemHeight: widget.itemHeight),
          itemBuilder: (context, index) => Container(
            alignment: Alignment.center,
            height: widget.itemHeight,
            child: Text(
              (index * widget.interval % 60).toString().padLeft(2, '0'),
              style: getTextStyle(TextStyles.h0).copyWith(
                color: model.getSelectedIndex() == index ? AppColors.white : AppColors.disabled,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
