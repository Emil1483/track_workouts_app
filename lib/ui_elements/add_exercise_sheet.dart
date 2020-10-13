import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:track_workouts/data/model/routine/routine.dart';
import 'package:track_workouts/style/theme.dart';
import 'package:track_workouts/ui_elements/confirm_dialog.dart';
import 'package:track_workouts/ui_elements/dismiss_background.dart';
import 'package:track_workouts/ui_elements/list_element.dart';

class AddExerciseSheet<U extends ChangeNotifier> extends StatelessWidget {
  static void showModal<U extends ChangeNotifier>(
    BuildContext context,
    U model, {
    @required List<Exercise> Function() exercises,
    @required void Function() createNewExercise,
    void Function(Exercise) deleteExercise,
    @required Function(Exercise) onExerciseTapped,
    @required bool Function() noExercises,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (_) => ChangeNotifierProvider.value(
        value: model,
        builder: (context, child) => Consumer<U>(
          builder: (context, model, child) => AddExerciseSheet<U>(
            createNewExercise: createNewExercise,
            deleteExercise: deleteExercise,
            exercises: exercises,
            noExercises: noExercises,
            onExerciseTapped: onExerciseTapped,
          ),
        ),
      ),
    );
  }

  final List<Exercise> Function() exercises;
  final void Function() createNewExercise;
  final void Function(Exercise) deleteExercise;
  final void Function(Exercise) onExerciseTapped;
  final bool Function() noExercises;

  const AddExerciseSheet({
    @required this.exercises,
    @required this.createNewExercise,
    @required this.deleteExercise,
    @required this.onExerciseTapped,
    @required this.noExercises,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primary,
      child: Stack(
        children: [
          Positioned.fill(child: _buildContent(context)),
          Positioned(
            bottom: 16.0,
            right: 16.0,
            child: FloatingActionButton(
              onPressed: createNewExercise,
              child: Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (noExercises()) {
      return Stack(
        children: [
          Align(
            alignment: Alignment(0, -.6),
            child: Text(
              '😫\n\nThere are no exercises',
              style: getTextStyle(TextStyles.caption),
              textAlign: TextAlign.center,
            ),
          ),
          Positioned(
            bottom: 12.0,
            right: 82.0,
            child: Icon(Icons.arrow_forward, size: 64.0),
          ),
        ],
      );
    }

    final selectableExercises = exercises();

    if (selectableExercises.isEmpty) {
      return Align(
        alignment: Alignment(0, -.6),
        child: Text(
          '🙃\n\nYou have selected all the exercises',
          style: getTextStyle(TextStyles.caption),
          textAlign: TextAlign.center,
        ),
      );
    }

    return ListView(
      children: [
        for (final exercise in selectableExercises) _buildExerciseWidget(context, exercise),
      ],
    );
  }

  Widget _buildExerciseWidget(BuildContext context, Exercise exercise) {
    Widget exerciseWidget = ListElement(
      mainWidget: Text(exercise.name, style: getTextStyle(TextStyles.h2)),
      onTap: () => onExerciseTapped(exercise),
      centered: true,
    );

    if (deleteExercise != null) {
      exerciseWidget = Dismissible(
        key: ValueKey(exercise),
        onDismissed: (_) => deleteExercise(exercise),
        background: DismissBackground(rightPadding: 24.0),
        direction: DismissDirection.endToStart,
        confirmDismiss: (_) => ConfirmDialog.showConfirmDialog(
          context,
          'Are you sure you wish to delete the "${exercise.name}" exercise?',
        ),
        child: exerciseWidget,
      );
    }

    return exerciseWidget;
  }
}
