import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:track_workouts/data/model/routine/routine.dart';
import 'package:track_workouts/data/services/routines_service.dart';
import 'package:track_workouts/handlers/router.dart';
import 'package:track_workouts/routes/base/base_widget.dart';
import 'package:track_workouts/routes/create_routine/create_routine/create_routine_viewmodel.dart';
import 'package:track_workouts/style/theme.dart';
import 'package:track_workouts/ui_elements/confirm_dialog.dart';
import 'package:track_workouts/ui_elements/main_button.dart';
import 'package:track_workouts/ui_elements/text_field_app_bar.dart';
import 'package:track_workouts/utils/error_mixins.dart';

class CreateRoutine extends StatelessWidget with ErrorStateless {
  static const String routeName = 'createRoutine';

  final Routine routine;

  CreateRoutine({@required this.routine});

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BaseWidget<CreateRoutineViewmodel>(
      model: CreateRoutineViewmodel(
        routinesService: Provider.of<RoutinesService>(context),
        onError: onError,
        routine: routine,
      ),
      builder: (context, model, child) => Form(
        key: model.formKey,
        child: Scaffold(
          appBar: TextFieldAppBar(
            labelText: 'Workout Name',
            controller: model.exerciseNameController,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => showModalBottomSheet(
              context: context,
              builder: (_) => ChangeNotifierProvider.value(
                value: model,
                child: _AddExerciseSheet(),
              ),
              backgroundColor: AppColors.primary,
            ),
            child: Icon(Icons.add),
          ),
          body: Column(
            children: [
              Expanded(
                child: model.missingExercises
                    ? _MissingExercisesWidget()
                    : ListView(
                        children:
                            model.getExercisesBySelected(true).map((exercise) => _ExerciseWidget(exercise: exercise)).toList(),
                      ),
              ),
              MainButton(
                onTaps: [model.save],
                texts: ['save'],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MissingExercisesWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 12.0),
      child: Stack(
        children: [
          Center(
            child: Text(
              'Click here to add exercises',
              style: getTextStyle(TextStyles.h2),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Icon(Icons.arrow_downward, size: 64.0),
          ),
        ],
      ),
    );
  }
}

class _AddExerciseSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<CreateRoutineViewmodel>(context);

    return Material(
      color: AppColors.primary,
      child: Stack(
        children: [
          Positioned.fill(
            child: _buildContent(model),
          ),
          Positioned(
            bottom: 16.0,
            right: 16.0,
            child: FloatingActionButton(
              onPressed: model.createExercise,
              child: Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(CreateRoutineViewmodel model) {
    if (model.noExercisesMade) {
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

    if (model.allExercisesSelected) {
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
      children: model.getExercisesBySelected(false).map((exercise) => _ExerciseWidget(exercise: exercise)).toList(),
    );
  }
}

class _ExerciseWidget extends StatelessWidget {
  final Exercise exercise;

  const _ExerciseWidget({@required this.exercise});

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<CreateRoutineViewmodel>(context);
    return Dismissible(
      key: ValueKey(exercise),
      onDismissed: (_) => model.delete(exercise),
      background: Container(
        padding: EdgeInsets.only(right: 12.0),
        color: AppColors.accent900,
        alignment: Alignment.centerRight,
        child: Icon(Icons.delete),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) => ConfirmDialog.showConfirmDialog(
        context,
        'Are you sure you wish to delete the "${exercise.name}" exercise?',
      ),
      child: InkWell(
        onTap: () => model.select(exercise),
        onLongPress: () => model.edit(exercise),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(exercise.name, style: getTextStyle(TextStyles.h2)),
                  Icon(Icons.chevron_right),
                ],
              ),
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}
