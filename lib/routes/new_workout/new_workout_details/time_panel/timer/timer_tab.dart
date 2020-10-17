import 'package:flutter/material.dart';
import 'package:track_workouts/routes/base/base_widget.dart';
import 'package:track_workouts/routes/new_workout/new_workout_details/time_panel/timer/timer_viewmodel.dart';
import 'package:track_workouts/style/theme.dart';
import 'package:track_workouts/ui_elements/main_button.dart';

class TimerTab extends StatefulWidget {
  @override
  _TimerState createState() => _TimerState();
}

class _TimerState extends State<TimerTab> with AutomaticKeepAliveClientMixin {
  static const _radius = Radius.circular(12.0);

  @override
  bool wantKeepAlive = true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BaseWidget<TimerViewmodel>(
      model: TimerViewmodel(context),
      onModelReady: (model) => model.loadTimer(),
      onDispose: (model) => model.dispose(),
      builder: (context, model, child) => Column(
        children: <Widget>[
          Container(
            height: 196.0,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: _radius),
              border: Border.all(
                color: model.borderColor,
                width: model.borderWidth,
              ),
              color: AppColors.black900,
            ),
            child: Text(model.currentTime.toString(), style: getTextStyle(TextStyles.h0)),
          ),
          MainButton(
            texts: [
              model.isTiming ? 'Stop' : 'Start',
              if (model.hasStarted) 'Done',
            ],
            onTaps: [
              model.startStopTimer,
              if (model.hasStarted) model.cancelTimer,
            ],
            borderRadius: BorderRadius.vertical(bottom: _radius),
            primaryColor: model.hasStarted,
          ),
        ],
      ),
    );
  }
}
