import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:track_workouts/data/model/workouts/workout/workout.dart';
import 'package:track_workouts/routes/base/base_widget.dart';
import 'package:track_workouts/routes/root/root_viewmodel.dart';
import 'package:track_workouts/routes/workout_details/exercise_details_app_bar.dart';
import 'package:track_workouts/routes/workout_details/exercise_details_viewmodel.dart';
import 'package:track_workouts/style/theme.dart';
import 'package:track_workouts/ui_elements/colored_container.dart';
import 'package:track_workouts/ui_elements/set_widget.dart';

class ExerciseDetailsRoute extends StatelessWidget {
  static const String routeName = 'exerciseDetails';

  final FormattedExercise exercise;

  const ExerciseDetailsRoute({@required this.exercise});

  @override
  Widget build(BuildContext context) {
    return BaseWidget<ExerciseDetailsViewmodel>(
      model: ExerciseDetailsViewmodel(exercise: exercise),
      builder: (context, model, child) {
        final List<Widget> setWidgets = [];
        model.forEachFormattedSet((formattedSet, index) => setWidgets.add(SetWidget(attributes: formattedSet, index: index)));
        return Scaffold(
          appBar: ExerciseDetailsAppBar(exerciseName: model.exercise.name),
          body: ListView(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            children: [
              _RepeatedAttributes(attributes: model.repeatedAttributes),
              ...setWidgets,
            ],
          ),
        );
      },
    );
  }
}

class _RepeatedAttributes extends StatelessWidget {
  final Map<AttributeName, double> attributes;

  const _RepeatedAttributes({@required this.attributes});

  @override
  Widget build(BuildContext context) {
    if (attributes.isEmpty) return Container();

    return Column(
      children: [
        SizedBox(height: 16.0),
        Wrap(
          alignment: WrapAlignment.center,
          children: attributes.entries.map((attribute) {
            final name = attribute.key.formattedString;
            final value = attribute.formattedValueString;
            return ColoredContainer(
              margin: EdgeInsets.symmetric(horizontal: 3.0, vertical: 3.0),
              child: Text('$name: $value', style: getTextStyle(TextStyles.caption)),
            );
          }).toList(),
        ),
        Divider(height: 24.0),
      ],
    );
  }
}
