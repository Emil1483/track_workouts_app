import 'package:flutter/material.dart';
import 'package:track_workouts/routes/base/base_widget.dart';
import 'package:track_workouts/routes/root/root_viewmodel.dart';
import 'package:track_workouts/routes/workout_details/workout_details_viewmodel.dart';
import 'package:track_workouts/style/theme.dart';
import 'package:track_workouts/ui_elements/date_widget.dart';

class WorkoutDetailsRoute extends StatelessWidget {
  final FormattedWorkout workout;

  const WorkoutDetailsRoute({@required this.workout});

  @override
  Widget build(BuildContext context) {
    return BaseWidget<WorkoutDetailsViewmodel>(
      model: WorkoutDetailsViewmodel(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: DateWidget(
            date: workout.date,
            style: getTextStyle(TextStyles.h1),
          ),
        ),
      ),
    );
  }
}
