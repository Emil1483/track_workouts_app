import 'package:flutter/material.dart';
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

  Widget _buildSetWidget(Map<String, double> mySet, int index) {
    return Container(
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
          ...mySet.entries.map(_buildSetEntry).toList(),
        ],
      ),
    );
  }

  Widget _buildSetEntry(MapEntry<String, double> entry) {
    final attributeName = entry.key;
    final attribute = entry.value;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          attributeName.formatFromCamelcase,
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
