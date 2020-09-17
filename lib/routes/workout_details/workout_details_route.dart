import 'package:flutter/material.dart';
import 'package:track_workouts/handlers/router.dart';
import 'package:track_workouts/routes/root/root_viewmodel.dart';
import 'package:track_workouts/style/theme.dart';
import 'package:track_workouts/ui_elements/date_widget.dart';
import 'package:track_workouts/ui_elements/list_element.dart';
import 'package:track_workouts/utils/string_utils.dart';

class WorkoutDetailsRoute extends StatelessWidget {
  final FormattedWorkout workout;

  const WorkoutDetailsRoute({@required this.workout});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: DateWidget(
          date: workout.date,
          style: getTextStyle(TextStyles.h1),
        ),
      ),
      body: ListView(
        children: workout.exercises.map(_buildExercise).toList(),
      ),
    );
  }

  Widget _buildExercise(FormattedExercise exercise) {
    return ListElement(
      onTap: () => Router.pushNamed(Router.exerciseDetailsRoute, arguments: [exercise]),
      centered: true,
      mainWidget: Text(
        exercise.name.formatFromCamelcase,
        style: getTextStyle(TextStyles.h2),
      ),
    );
  }
}