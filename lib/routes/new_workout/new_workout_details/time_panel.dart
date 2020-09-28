import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:track_workouts/data/model/picked_time/picked_time.dart';
import 'package:track_workouts/routes/new_workout/new_workout_details/new_exercise_details_viewmodel.dart';
import 'package:track_workouts/style/theme.dart';
import 'package:track_workouts/ui_elements/main_button.dart';
import 'package:track_workouts/ui_elements/time_picker/time_picker.dart';

class TimePanel extends StatefulWidget {
  @override
  _TimePanelState createState() => _TimePanelState();
}

class _TimePanelState extends State<TimePanel> with SingleTickerProviderStateMixin {
  static const _radius = Radius.circular(12.0);

  final GlobalKey<TimePickerState> _timerKey = GlobalKey();
  final GlobalKey _timerContainerKey = GlobalKey();

  AnimationController _controller;

  PickedTime _pickedTime;
  double _timePickerHeight;

  @override
  initState() {
    super.initState();
    final model = Provider.of<NewExerciseDetailsViewmodel>(context, listen: false);
    _controller = AnimationController(vsync: this);
    _controller.addListener(() async {
      if (_controller.value == 1) {
        model.panelController.close();
        model.modifyPreBreakIfPossible(_pickedTime);
        await Future.delayed(Duration(milliseconds: 500));
        setState(() => _pickedTime = null);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final timeWidget = _pickedTime == null
        ? Container(
            key: _timerContainerKey,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: _radius),
              border: Border.all(color: AppColors.accent),
              color: AppColors.black900,
            ),
            child: TimePicker(key: _timerKey),
          )
        : AnimatedBuilder(
            animation: _controller,
            builder: (context, child) => CustomPaint(
              painter: _CountdownPainter(value: 1 - _controller.value),
              child: Container(
                height: _timePickerHeight,
                alignment: Alignment.center,
                child: Text((_pickedTime * (1 - _controller.value)).toString(), style: getTextStyle(TextStyles.h0)),
              ),
            ),
          );

    return Column(
      children: [
        SizedBox(height: 64.0),
        SizedBox(
          width: 256.0,
          child: Column(
            children: [
              timeWidget,
              MainButton(
                text: 'Start',
                primaryColor: _pickedTime != null,
                borderRadius: BorderRadius.vertical(bottom: _radius),
                onTap: () => setState(() {
                  _pickedTime = _timerKey.currentState.selectedTime;
                  _timePickerHeight = _timerContainerKey.currentContext.size.height;

                  _controller.value = 0;
                  _controller.animateTo(1, duration: _pickedTime.toDuration);
                }),
              )
            ],
          ),
        ),
      ],
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

  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();

    path.moveTo(size.width / 2, size.height / 2);

    final iterations = 10;
    for (int i = 0; i < iterations; i++) {
      final angle = 2 * math.pi * i * value / (iterations - 1) - math.pi / 2;
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
