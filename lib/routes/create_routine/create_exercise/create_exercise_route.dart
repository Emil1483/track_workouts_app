import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:track_workouts/data/model/routine/routine.dart';
import 'package:track_workouts/data/model/workouts/workout/workout.dart';
import 'package:track_workouts/data/services/routines_service.dart';
import 'package:track_workouts/routes/base/base_widget.dart';
import 'package:track_workouts/routes/create_routine/create_exercise/create_exercise_viewmodel.dart';
import 'package:track_workouts/style/theme.dart';
import 'package:track_workouts/ui_elements/main_button.dart';
import 'package:track_workouts/ui_elements/text_field_app_bar.dart';
import 'package:track_workouts/utils/error_mixins.dart';

class CreateExerciseRoute extends StatelessWidget with ErrorStateless {
  static const String routeName = 'createExercise';

  final Exercise exercise;

  CreateExerciseRoute({@required this.exercise});

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BaseWidget<CreateExerciseViewmodel>(
      model: CreateExerciseViewmodel(
        routinesService: Provider.of<RoutinesService>(context),
        exercise: exercise,
        onError: onError,
      ),
      builder: (context, model, child) => Form(
        key: model.formKey,
        child: Scaffold(
          appBar: TextFieldAppBar(labelText: 'Exercise Name', controller: model.exerciseNameController),
          body: Column(
            children: [
              Expanded(
                child: ReorderableListView(
                  onReorder: model.onReorderAttributes,
                  children: [for (final attribute in model.selectableAttributes) _buildAttribute(context, attribute)],
                ),
              ),
              Container(
                color: AppColors.primary,
                child: Column(
                  children: [
                    SizedBox(height: 12.0),
                    Text('How many sets?', style: getTextStyle(TextStyles.h2)),
                    Row(
                      children: [
                        SizedBox(width: 18.0),
                        Text(
                          model.numberOfSets.toString(),
                          style: getTextStyle(TextStyles.h2),
                        ),
                        Expanded(
                          child: Slider(
                            value: model.numberOfSets.toDouble(),
                            onChanged: model.changeNumberOfSets,
                            min: 1,
                            max: 6,
                            activeColor: AppColors.accent,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              MainButton(
                onTaps: [model.save],
                texts: ['Save'],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAttribute(BuildContext context, SelectableAttribute attribute) {
    final model = Provider.of<CreateExerciseViewmodel>(context);
    final dividerThickness = 0.4;
    return Column(
      key: ValueKey(attribute),
      mainAxisSize: MainAxisSize.min,
      children: [
        Divider(thickness: dividerThickness),
        Material(
          color: AppColors.black900,
          child: InkWell(
            onTap: () => model.select(attribute),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    attribute.name.formattedString,
                    style: getTextStyle(TextStyles.h2),
                  ),
                  attribute.selected
                      ? Icon(
                          Icons.check_box,
                          color: AppColors.accent,
                        )
                      : Icon(
                          Icons.check_box_outline_blank,
                        ),
                ],
              ),
            ),
          ),
        ),
        Divider(thickness: dividerThickness),
      ],
    );
  }
}
