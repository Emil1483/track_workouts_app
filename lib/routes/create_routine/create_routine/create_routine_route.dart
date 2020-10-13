import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:track_workouts/data/model/routine/routine.dart';
import 'package:track_workouts/data/services/routines_service.dart';
import 'package:track_workouts/routes/base/base_widget.dart';
import 'package:track_workouts/routes/create_routine/create_routine/create_routine_viewmodel.dart';
import 'package:track_workouts/style/theme.dart';
import 'package:track_workouts/ui_elements/add_exercise_sheet.dart';
import 'package:track_workouts/ui_elements/list_element.dart';
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
        oldRoutine: routine,
      ),
      builder: (context, model, child) => Form(
        key: model.formKey,
        child: Scaffold(
          appBar: TextFieldAppBar(
            labelText: 'Workout Name',
            controller: model.exerciseNameController,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => AddExerciseSheet.showModal(
              context,
              model,
              exercises: () => model.notSelectedExercises,
              createNewExercise: model.createExercise,
              onExerciseTapped: model.toggleSelected,
              noExercises: () => model.noExercisesMade,
              deleteExercise: model.delete
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
                          for (final exercise in model.selectedExercises)
                            ListElement(
                              key: ValueKey(exercise),
                              mainWidget: Text(exercise.name, style: getTextStyle(TextStyles.h2)),
                              onTap: () => model.toggleSelected(exercise),
                              onLongPress: () => model.edit(exercise),
                              centered: true,
                              color: AppColors.black900,
                              draggable: true,
                              icon: Icon(Icons.drag_handle),
                            ),
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