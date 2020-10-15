import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:track_workouts/data/model/routine/routine.dart';
import 'package:track_workouts/data/services/new_workout_service.dart';
import 'package:track_workouts/data/services/routines_service.dart';
import 'package:track_workouts/routes/base/base_widget.dart';
import 'package:track_workouts/routes/new_workout/new_workout/new_workout_viewmodel.dart';
import 'package:track_workouts/routes/new_workout/new_workout_details/time_panel/timer_panel.dart';
import 'package:track_workouts/ui_elements/add_exercise_sheet.dart';
import 'package:track_workouts/ui_elements/dismiss_background.dart';
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
        appBar: AppBar(
          title: Text(model.routineName),
          actions: [
            IconButton(
              icon: Icon(Icons.menu),
              onPressed: model.switchWorkout,
            ),
            SizedBox(width: 12.0),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => AddExerciseSheet.showModal(
            context,
            model,
            exercises: () => model.notIncludedExercises,
            createNewExercise: model.createNewExercise,
            onExerciseTapped: model.addExercise,
            noExercises: () => false,
          ),
          child: Icon(Icons.add),
        ),
        body: TimePanelWrapper(
          child: ReorderableListView(
            onReorder: model.reorderExercises,
            children: [
              for (final exercise in model.activeExercises) _buildExerciseWidget(context, exercise),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExerciseWidget(BuildContext context, MapEntry<String, List<ActiveSet>> exerciseMapEntry) {
    final model = Provider.of<NewWorkoutViewmodel>(context, listen: false);
    final exercise = model.getExerciseFrom(exerciseMapEntry.key);
    final progress = exerciseMapEntry.getProgress(exercise.numberOfSets);

    Widget exerciseWidget = ListElement(
      key: ValueKey(exerciseMapEntry),
      onTap: () => model.goToDetails(exercise),
      centered: true,
      color: progress.color,
      icon: Icon(Icons.drag_handle),
      mainWidget: AutoSizeText(
        exercise.name,
        style: progress.textStyle,
        maxLines: 1,
      ),
    );

    if (exerciseMapEntry.value.whereChecked.isEmpty) {
      exerciseWidget = Dismissible(
        key: ValueKey(exerciseMapEntry),
        onDismissed: (_) => model.removeExercise(exerciseMapEntry.key),
        direction: DismissDirection.endToStart,
        background: DismissBackground(rightPadding: 24.0),
        child: exerciseWidget,
      );
    }

    return exerciseWidget;
  }
}
