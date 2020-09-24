import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:provider/provider.dart';
import 'package:track_workouts/data/model/workouts/workout/workout.dart';
import 'package:track_workouts/routes/base/base_widget.dart';
import 'package:track_workouts/routes/new_workout/new_workout/new_workout_viewmodel.dart';
import 'package:track_workouts/routes/new_workout/new_workout_details/new_exercise_details_viewmodel.dart';
import 'package:track_workouts/style/theme.dart';
import 'package:track_workouts/ui_elements/colored_container.dart';
import 'package:track_workouts/ui_elements/main_button.dart';
import 'package:track_workouts/ui_elements/set_widget.dart';
import 'package:track_workouts/utils/duration_utils.dart';
import 'package:track_workouts/utils/error_mixins.dart';
import 'package:track_workouts/utils/validation_utils.dart';
import 'package:track_workouts/utils/map_utils.dart';

class NewExerciseDetailsRoute extends StatelessWidget with ErrorStateless {
  static const String routeName = 'newWorkoutDetails';

  final ActiveExercise activeExercise;

  NewExerciseDetailsRoute({@required this.activeExercise});

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BaseWidget<NewExerciseDetailsViewmodel>(
      model: NewExerciseDetailsViewmodel(exercise: activeExercise.exercise, onError: onError),
      builder: (context, model, child) {
        final List<Widget> setWidgets = [];
        for (int i = 0; i < model.activeSets.length; i++) {
          final activeSet = model.activeSets[i];
          if (activeSet.completed) {
            setWidgets.add(SetWidget(attributes: activeSet.attributes, index: i));
          } else {
            setWidgets.add(_ActiveSetWidget(attributes: activeSet.attributes));
          }
        }
        return Scaffold(
          appBar: AppBar(title: AutoSizeText(activeExercise.exercise.name, maxLines: 1)),
          body: ListView(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            children: setWidgets,
          ),
        );
      },
    );
  }
}

class _ActiveSetWidget extends StatelessWidget {
  final Map<AttributeName, double> attributes;

  const _ActiveSetWidget({@required this.attributes});

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<NewExerciseDetailsViewmodel>(context, listen: false);

    final formattedAttributes = attributes.copy();

    Widget breakWidget;
    if (formattedAttributes.containsKey(AttributeName.pre_break)) {
      final seconds = formattedAttributes[AttributeName.pre_break];
      final duration = seconds == null ? null : Duration(seconds: seconds.round());
      formattedAttributes.remove(AttributeName.pre_break);
      breakWidget = ColoredContainer(
        onTap: () {},
        child: Text(
          duration?.formatMinuteSeconds ?? 'Set Break',
          style: getTextStyle(TextStyles.caption),
        ),
      );
    }

    final borderRadius = 8.0;

    return Column(
      children: [
        breakWidget ?? Container(),
        Container(
          decoration: BoxDecoration(
            color: AppColors.black500,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: Column(
            children: [
              _AttributesTextFields(formattedAttributes: formattedAttributes),
              MainButton(
                onTap: () => model.saveSets(),
                text: 'Save',
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(borderRadius),
                  bottomRight: Radius.circular(borderRadius),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AttributesTextFields extends StatelessWidget {
  final Map<AttributeName, double> formattedAttributes;

  const _AttributesTextFields({@required this.formattedAttributes});

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<NewExerciseDetailsViewmodel>(context, listen: false);
    return Form(
      key: model.formKey,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          children: formattedAttributes.entries.map(
            (attribute) {
              final name = attribute.key.formattedString;
              final unit = attribute.key.unit;
              final unitString = unit == null ? '' : ' (${unit.string})';
              return Padding(
                padding: EdgeInsets.only(bottom: 14.0),
                child: TextFormField(
                  controller: model.getControllerFrom(attribute.key),
                  keyboardType: TextInputType.number,
                  style: getTextStyle(TextStyles.caption),
                  validator: Validation.mustBeNumber,
                  decoration: InputDecoration(
                    labelText: name + unitString,
                    labelStyle: getTextStyle(TextStyles.caption),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.accent, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.white, width: 0.5),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.error, width: 1.0),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.error, width: 2.0),
                    ),
                  ),
                ),
              );
            },
          ).toList(),
        ),
      ),
    );
  }
}
