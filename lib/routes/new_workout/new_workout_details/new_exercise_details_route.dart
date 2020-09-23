import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:track_workouts/data/model/workouts/workout/workout.dart';
import 'package:track_workouts/routes/base/base_widget.dart';
import 'package:track_workouts/routes/new_workout/new_workout/new_workout_viewmodel.dart';
import 'package:track_workouts/routes/new_workout/new_workout_details/new_exercise_details_viewmodel.dart';
import 'package:track_workouts/style/theme.dart';
import 'package:track_workouts/ui_elements/colored_container.dart';
import 'package:track_workouts/utils/duration_utils.dart';

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
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          children: model.activeSets.map(_buildActiveSet).toList(),
        ),
      ),
    );
  }

  Widget _buildActiveSet(ActiveSet activeSet) {
    final formattedSet = activeSet.copy();

    Widget breakWidget;
    if (formattedSet.attributes.containsKey(AttributeName.pre_break)) {
      final seconds = activeSet.attributes[AttributeName.pre_break];
      final duration = seconds == null ? null : Duration(seconds: seconds.round());
      formattedSet.attributes.remove(AttributeName.pre_break);
      breakWidget = ColoredContainer(
        onTap: () {},
        child: Text(
          duration?.formatMinuteSeconds ?? 'Set Break',
          style: getTextStyle(TextStyles.caption),
        ),
      );
    }

    return Column(
      children: [
        breakWidget ?? Container(),
        Container(
          margin: EdgeInsets.only(bottom: 12.0),
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          decoration: BoxDecoration(
            color: AppColors.black500,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [BoxShadow(blurRadius: 4.0, offset: Offset(0, 3), color: AppColors.black950)],
          ),
          child: Column(
            children: formattedSet.attributes.entries.map(
              (attribute) {
                final name = attribute.key.formattedString;
                final unit = attribute.key.unit;
                final unitString = unit == null ? '' : ' (${unit.string})';
                return Padding(
                  padding: EdgeInsets.only(bottom: 14.0),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    style: getTextStyle(TextStyles.caption),
                    decoration: InputDecoration(
                      labelText: name + unitString,
                      labelStyle: getTextStyle(TextStyles.caption),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.accent900, width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.white, width: 0.5),
                      ),
                    ),
                  ),
                );
              },
            ).toList(),
          ),
        ),
      ],
    );
  }
}
