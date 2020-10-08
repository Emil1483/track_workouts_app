import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:track_workouts/data/model/routine/routine.dart';
import 'package:track_workouts/data/services/new_workout_service.dart';
import 'package:track_workouts/data/services/routines_service.dart';
import 'package:track_workouts/routes/base/base_widget.dart';
import 'package:track_workouts/routes/new_workout/new_workout/new_workout_viewmodel.dart';
import 'package:track_workouts/ui_elements/list_element.dart';

class NewWorkoutRoute extends StatelessWidget {
  static const String routeName = 'newWorkout';

  @override
  Widget build(BuildContext context) {
    return BaseWidget<NewWorkoutViewmodel>(
      model: NewWorkoutViewmodel(
        newWorkoutService: Provider.of<NewWorkoutService>(context),
        routinesService: Provider.of<RoutinesService>(context),
      ),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(title: Text('New Workout')),
        body: ReorderableListView(
          onReorder: (a, b) {},
          children: [
            for (final exercise in model.activeExercises.entries) _buildExerciseWidget(context, exercise),
          ],
        ),
        // body: ListView(
        //   children: model.activeExercises.entries.map((exercise) => _buildExerciseWidget(context, exercise)).toList(),
        // ),
      ),
    );
  }

  Widget _buildExerciseWidget(BuildContext context, MapEntry<String, List<ActiveSet>> exerciseMapEntry) {
    final model = Provider.of<NewWorkoutViewmodel>(context, listen: false);
    final exercise = model.getExerciseFrom(exerciseMapEntry.key);
    final progress = exerciseMapEntry.getProgress(exercise.numberOfSets);

    return ListElement(
      key: ValueKey(exerciseMapEntry),
      onTap: () => model.goToDetails(exercise),
      centered: true,
      color: progress.color,
      icon: Icons.drag_handle,
      mainWidget: AutoSizeText(
        exercise.name,
        style: progress.textStyle,
        maxLines: 1,
      ),
    );
  }
}
