import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:track_workouts/data/model/routine/routine.dart';
import 'package:track_workouts/routes/base/base_widget.dart';
import 'package:track_workouts/routes/new_workout/choose_routine/choose_routine_viewmodel.dart';
import 'package:track_workouts/style/theme.dart';

class ChooseRoutineRoute extends StatelessWidget {
  static const String routeName = 'chooseWorkout';

  @override
  Widget build(BuildContext context) {
    return BaseWidget<ChooseRoutineViewmodel>(
      model: ChooseRoutineViewmodel(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(title: Text('Choose Workout')),
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 12.0),
          children: model.routines.map(_buildRoutinesRow).toList(),
        ),
      ),
    );
  }

  Widget _buildRoutinesRow(Routine routine) {
    final borderRadius = BorderRadius.circular(12.0);

    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Material(
        color: AppColors.primary700,
        elevation: 4.0,
        borderRadius: borderRadius,
        child: InkWell(
          onTap: () {},
          borderRadius: borderRadius,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(routine.name, style: getTextStyle(TextStyles.h2)),
                SizedBox(height: 4.0),
                ...routine.exercises
                    .map(
                      (exercise) => Padding(
                        padding: EdgeInsets.only(top: 2.0),
                        child: AutoSizeText(
                          '●  ${exercise.name}',
                          style: getTextStyle(TextStyles.body1),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                    .toList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
