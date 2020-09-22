import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:track_workouts/data/services/new_workout_service.dart';
import 'package:track_workouts/handlers/router.dart';
import 'package:track_workouts/routes/base/base_widget.dart';
import 'package:track_workouts/routes/new_workout/new_workout/new_workout_viewmodel.dart';
import 'package:track_workouts/routes/new_workout/new_workout_details/new_exercise_details_route.dart';
import 'package:track_workouts/style/theme.dart';
import 'package:track_workouts/ui_elements/list_element.dart';

class NewWorkoutRoute extends StatelessWidget {
  static const String routeName = 'newWorkout';

  @override
  Widget build(BuildContext context) {
    return BaseWidget<NewWorkoutViewmodel>(
      model: NewWorkoutViewmodel(newWorkoutService: Provider.of<NewWorkoutService>(context)),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(title: Text('New Workout')),
        body: ListView(
          children: model.activeExercises.map(_buildExerciseWidget).toList(),
        ),
      ),
    );
  }

  Widget _buildExerciseWidget(ActiveExercise exercise) {
    return ListElement(
      onTap: exercise.progress == Progress.completed
          ? null
          : () => Router.pushNamed(NewExerciseDetailsRoute.routeName, arguments: [exercise]),
      centered: true,
      color: exercise.progress.color,
      mainWidget: AutoSizeText(
        exercise.exercise.name,
        style: getTextStyle(TextStyles.h2),
        maxLines: 1,
      ),
    );
  }
}
