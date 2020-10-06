import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:track_workouts/data/model/workouts/workout/workout.dart';
import 'package:track_workouts/routes/base/base_widget.dart';
import 'package:track_workouts/routes/create_routine/create_exercise/create_exercise_viewmodel.dart';
import 'package:track_workouts/style/theme.dart';
import 'package:track_workouts/ui_elements/main_button.dart';
import 'package:track_workouts/ui_elements/text_field_app_bar.dart';
import 'package:track_workouts/utils/error_mixins.dart';

class CreateExerciseRoute extends StatelessWidget with ErrorStateless {
  static const String routeName = 'createExercise';

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BaseWidget<CreateExerciseViewmodel>(
      model: CreateExerciseViewmodel(onError: onError),
      builder: (context, model, child) => Form(
        key: model.formKey,
        child: Scaffold(
          appBar: TextFieldAppBar(labelText: 'Exercise Name'),
          body: Column(
            children: [
              Expanded(
                child: ListView(
                  children: model.selectableAttributes.map((attribute) => _buildAttribute(context, attribute)).toList(),
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
    return Column(
      children: [
        InkWell(
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
        Divider(),
      ],
    );
  }
}
