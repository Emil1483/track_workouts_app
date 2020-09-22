import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:track_workouts/data/model/workouts/workout/workout.dart';
import 'package:track_workouts/routes/base/base_widget.dart';
import 'package:track_workouts/routes/new_workout/new_workout/new_workout_viewmodel.dart';
import 'package:track_workouts/routes/new_workout/new_workout_details/new_exercise_details_viewmodel.dart';
import 'package:track_workouts/style/theme.dart';

class NewExerciseDetailsRoute extends StatelessWidget {
  static const String routeName = 'newWorkoutDetails';

  final ActiveExercise activeExercise;

  const NewExerciseDetailsRoute({@required this.activeExercise});

  @override
  Widget build(BuildContext context) {
    return BaseWidget<NewExerciseDetailsViewmodel>(
      model: NewExerciseDetailsViewmodel(activeExercise.exercise),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(title: AutoSizeText(activeExercise.exercise.name, maxLines: 1)),
        body: ListView(children: model.activeSets.map(_buildActiveSet).toList()),
      ),
    );
  }

  Widget _buildActiveSet(ActiveSet activeSet) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.0),
      child: Column(
        children: activeSet.attributes.entries.map(
          (attribute) {
            final name = attribute.key.formattedString;
            return Text(
              '$name: ${attribute.value}',
              style: getTextStyle(TextStyles.body1),
            );
          },
        ).toList(),
      ),
    );
  }
}
