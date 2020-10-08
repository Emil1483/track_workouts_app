import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:track_workouts/data/model/routine/routine.dart';
import 'package:track_workouts/data/services/routines_service.dart';
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
                child: model.noExercisesSelected
                    ? _MissingExercisesWidget()
                    : ReorderableListView(
                        onReorder: model.onReorderExercises,
                        children: [
                          for (final exercise in model.selectedExercises) _ExerciseWidget(exercise: exercise, draggable: true),
                        ],
                        header: Column(
                          children: [
                            SizedBox(height: 24.0),
                            Text(
                              'Select a Thumbnail',
                              style: getTextStyle(TextStyles.h2),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 18.0),
                            for (final row in model.getImageRows(3)) _buildImageRow(context, row),
                          ],
                        ),
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

  Widget _buildImageRow(BuildContext context, List<String> images) {
    final borderRadius = BorderRadius.circular(16.0);

    final model = Provider.of<CreateRoutineViewmodel>(context);
    return Row(
      children: images.map(
        (image) {
          final isSelected = model.selectedImage == image;
          return Expanded(
            child: image == null
                ? Container()
                : Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Material(
                      color: AppColors.black500,
                      borderRadius: borderRadius,
                      elevation: 4.0,
                      child: InkWell(
                        borderRadius: borderRadius,
                        onTap: () => model.selectImage(image),
                        child: Padding(
                          padding: EdgeInsets.all(6.0),
                          child: Image.asset(
                            'assets/images/$image',
                            color: !isSelected ? null : AppColors.accent,
                          ),
                        ),
                      ),
                    ),
                  ),
          );
        },
      ).toList(),
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
            child: _buildContent(context),
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

  Widget _buildContent(BuildContext context) {
    final model = Provider.of<CreateRoutineViewmodel>(context);

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
      children: [
        for (final exercise in model.notSelectedExercises)
          Dismissible(
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
            child: _ExerciseWidget(exercise: exercise),
          ),
      ],
    );
  }
}

class _ExerciseWidget extends StatelessWidget {
  final Exercise exercise;
  final bool draggable;

  _ExerciseWidget({@required this.exercise, this.draggable = false}) : super(key: ValueKey(exercise.name));

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<CreateRoutineViewmodel>(context);
    final dividerThickness = 0.4;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (draggable) Divider(thickness: dividerThickness),
        Material(
          color: draggable ? AppColors.black900 : AppColors.transparent,
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => model.toggleSelected(exercise),
                  onLongPress: () => model.edit(exercise),
                  borderRadius: draggable
                      ? BorderRadius.only(
                          topRight: Radius.circular(12.0),
                          bottomRight: Radius.circular(12.0),
                        )
                      : null,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(exercise.name, style: getTextStyle(TextStyles.h2)),
                        if (!draggable) Icon(Icons.chevron_right),
                      ],
                    ),
                  ),
                ),
              ),
              if (draggable)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Icon(Icons.drag_handle),
                ),
            ],
          ),
        ),
        Divider(thickness: dividerThickness),
      ],
    );
  }
}
