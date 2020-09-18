import 'package:flutter/material.dart';
import 'package:track_workouts/data/model/workouts/workout/workout.dart';
import 'package:track_workouts/routes/base/base_widget.dart';
import 'package:track_workouts/routes/root/root_viewmodel.dart';
import 'package:track_workouts/routes/workout_details/exercise_details_viewmodel.dart';
import 'package:track_workouts/style/theme.dart';
import 'package:track_workouts/utils/duration_utils.dart';

class ExerciseDetails extends StatelessWidget {
  final FormattedExercise exercise;

  const ExerciseDetails({@required this.exercise});

  @override
  Widget build(BuildContext context) {
    return BaseWidget<ExerciseDetailsViewmodel>(
      model: ExerciseDetailsViewmodel(exercise: exercise),
      builder: (context, model, child) {
        final List<Widget> setWidgets = [];
        model.forEachFormattedSet((formattedSet, index) => setWidgets.add(_buildSetWidget(formattedSet, index)));

        return Scaffold(
          appBar: AppBar(title: Text(model.exerciseName, style: getTextStyle(TextStyles.h1))),
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

  Widget _buildSetWidget(Map<AttributeName, double> formattedSet, int index) {
    Widget breakWidget;
    final filteredSet = Map<AttributeName, double>.from(formattedSet)
      ..removeWhere((name, value) {
        if (name == AttributeName.pre_break) {
          breakWidget = _BreakWidget(duration: Duration(seconds: value.round()));
          return true;
        }
        return false;
      });
    return Column(
      children: [
        breakWidget ?? Container(),
        Container(
          margin: EdgeInsets.only(top: 8.0),
          padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          decoration: BoxDecoration(
            color: AppColors.black500,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Set #${index + 1}', style: getTextStyle(TextStyles.h2)),
              SizedBox(height: 4.0),
              ...filteredSet.entries.map(_buildSetEntry).toList(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSetEntry(MapEntry<AttributeName, double> entry) {
    final attributeName = entry.key;
    final attribute = entry.value;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          attributeName.formattedString,
          style: getTextStyle(TextStyles.body1),
        ),
        Text(
          attribute.toString(),
          style: getTextStyle(TextStyles.body1).copyWith(fontWeight: FontWeight.bold),
        ),
      ],
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
            final value = attribute.value;
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
              margin: EdgeInsets.symmetric(horizontal: 3.0, vertical: 3.0),
              decoration: BoxDecoration(
                color: AppColors.accent900,
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Text('$name: $value', style: getTextStyle(TextStyles.caption)),
            );
          }).toList(),
        ),
        Divider(height: 24.0),
      ],
    );
  }
}

class _BreakWidget extends StatelessWidget {
  final Duration duration;

  const _BreakWidget({@required this.duration});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 12.0),
        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
        decoration: BoxDecoration(
          color: AppColors.accent900,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(
          '${duration.formatMinuteSeconds} break',
          style: getTextStyle(TextStyles.h3),
        ),
      ),
    );
  }
}
