import 'package:flutter/material.dart';
import 'package:track_workouts/data/model/workouts/workout/workout.dart';
import 'package:track_workouts/routes/root/root_viewmodel.dart';
import 'package:track_workouts/style/theme.dart';
import 'package:track_workouts/utils/string_utils.dart';

class ExerciseDetails extends StatelessWidget {
  final FormattedExercise exercise;

  const ExerciseDetails({@required this.exercise});

  @override
  Widget build(BuildContext context) {
    final List<Widget> setWidgets = [];
    for (int i = 0; i < exercise.sets.length; i++) {
      setWidgets.add(_buildSetWidget(exercise.sets[i], i));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(exercise.name.formatFromCamelcase, style: getTextStyle(TextStyles.h1)),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        children: setWidgets,
      ),
    );
  }

  Widget _buildSetWidget(Map<AttributeName, double> mySet, int index) {
    Widget breakWidget;
    final filteredSet = Map<AttributeName, double>.from(mySet)
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

class _BreakWidget extends StatelessWidget {
  final Duration duration;

  const _BreakWidget({@required this.duration});

  @override
  Widget build(BuildContext context) {
    final minutes = duration.inMinutes;
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4.0),
        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
        decoration: BoxDecoration(
          color: AppColors.accent900,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(
          '$minutes minute break',
          style: getTextStyle(TextStyles.h3),
        ),
      ),
    );
  }
}
