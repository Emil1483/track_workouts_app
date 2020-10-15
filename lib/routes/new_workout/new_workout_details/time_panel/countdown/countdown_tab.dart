import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:track_workouts/routes/base/base_widget.dart';
import 'package:track_workouts/routes/new_workout/new_workout_details/time_panel/countdown/countdown_viewmodel.dart';
import 'package:track_workouts/style/theme.dart';
import 'package:track_workouts/ui_elements/main_button.dart';
import 'package:track_workouts/ui_elements/time_picker/time_picker.dart';

class CountdownTab extends StatefulWidget {
  @override
  _CountdownTabState createState() => _CountdownTabState();
}

class _CountdownTabState extends State<CountdownTab> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  static const _radius = Radius.circular(12.0);

  @override
  bool wantKeepAlive = true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BaseWidget<CountdownViewmodel>(
      model: CountdownViewmodel(
        context,
        timePickerHeight: TimePicker.defaultHeight,
      ),
      onModelReady: (model) {
        model.buildAnimationController(context, vsync: this);
        model.addSpinnerListener();
      },
      onDispose: (model) => model.dispose(),
      builder: (context, model, child) => Column(
        children: [
          Stack(
            children: [
              Opacity(
                opacity: model.selectingTime ? 1.0 : 0.0,
                child: Container(
                  key: model.timerContainerKey,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(top: _radius),
                    border: Border.all(color: AppColors.accent),
                    color: AppColors.black900,
                  ),
                  child: TimePicker(model: model.timePickerModel),
                ),
              ),
              if (!model.selectingTime)
                AnimatedBuilder(
                  animation: model.controller,
                  builder: (context, child) => CustomPaint(
                    painter: _CountdownPainter(value: 1 - model.countdownValue),
                    child: Container(
                      height: model.timePickerHeight,
                      alignment: Alignment.center,
                      child: Text((model.pickedTime * model.countdownValue).toString(), style: getTextStyle(TextStyles.h0)),
                    ),
                  ),
                ),
            ],
          ),
          MainButton(
            texts: model.selectingTime ? ['Start'] : [model.isCountingDown ? 'Stop' : 'Continue', 'Cancel'],
            onTaps: model.selectingTime ? [model.startCountdown] : [model.startStopCountdown, model.cancelCountdown],
            primaryColor: !model.selectingTime,
            borderRadius: BorderRadius.vertical(bottom: _radius),
            disabled: model.pickedTimeNotSelected,
          ),
        ],
      ),
    );
  }
}

class _CountdownPainter extends CustomPainter {
  final double value;
  final Radius radius;
  final double strokeWidth;

  _CountdownPainter({
    @required this.value,
    this.radius = const Radius.circular(12.0),
    this.strokeWidth = 2.0,
  }) : assert(value >= 0 && value <= 1);

  RRect _getRectFrom(Size size) {
    return RRect.fromLTRBAndCorners(
      strokeWidth / 2,
      strokeWidth / 2,
      size.width - strokeWidth / 2,
      size.height - strokeWidth / 2,
      topLeft: radius,
      topRight: radius,
    );
  }

  double _getAngleValue(Size size) {
    final h = size.height / 2;
    final w = size.width / 2;
    final t = value * (h * 4 + w * 4);

    if (t < w) return math.atan(t / h);
    if (t < w + 2 * h) return math.atan((t - w - h) / w) + math.pi / 2;
    if (t < 3 * w + 2 * h) return math.atan((t - 2 * h - 2 * w) / h) + math.pi;
    if (t < 3 * w + 4 * h) return math.atan((t - 3 * w - 3 * h) / w) + 3 * math.pi / 2;
    return math.atan((t - 4 * w - 4 * h) / h) + 2 * math.pi;
  }

  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();

    path.moveTo(size.width / 2, size.height / 2);

    final iterations = 10;
    for (int i = 0; i < iterations; i++) {
      final angle = lerpDouble(
        3 * math.pi / 2 - _getAngleValue(size),
        -math.pi / 2,
        i / (iterations - 1),
      );
      final radius = size.width + size.height;
      path.lineTo(
        radius * math.cos(angle) + size.width / 2,
        radius * math.sin(angle) + size.height / 2,
      );
    }

    path.lineTo(size.width / 2, size.height / 2);

    canvas.drawRRect(
      _getRectFrom(size),
      Paint()
        ..color = AppColors.accent.withOpacity(.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth,
    );

    canvas.clipPath(path);

    canvas.drawRRect(
      _getRectFrom(size),
      Paint()
        ..color = AppColors.accent
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
