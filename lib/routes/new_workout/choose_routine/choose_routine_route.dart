import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:provider/provider.dart';
import 'package:track_workouts/data/model/routine/routine.dart';
import 'package:track_workouts/data/services/new_workout_service.dart';
import 'package:track_workouts/data/services/routines_service.dart';
import 'package:track_workouts/routes/base/base_widget.dart';
import 'package:track_workouts/routes/new_workout/choose_routine/choose_routine_viewmodel.dart';
import 'package:track_workouts/style/theme.dart';

class ChooseRoutineRoute extends StatelessWidget {
  static const String routeName = 'chooseWorkout';

  @override
  Widget build(BuildContext context) {
    return BaseWidget<ChooseRoutineViewmodel>(
      model: ChooseRoutineViewmodel(
        newWorkoutService: Provider.of<NewWorkoutService>(context),
        routinesService: Provider.of<RoutinesService>(context),
      ),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(title: Text('Choose Workout')),
        floatingActionButton: FloatingActionButton(
          onPressed: model.createRoutine,
          child: Icon(Icons.add),
        ),
        body: ListView(
          children: model.routines.map((routine) => _buildRoutinesRow(routine, context)).toList(),
        ),
      ),
    );
  }

  Widget _buildRoutinesRow(Routine routine, BuildContext context) {
    final model = Provider.of<ChooseRoutineViewmodel>(context);
    return Stack(
      children: [
        Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.width / 2,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 14.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(routine.name, style: getTextStyle(TextStyles.subtitle1)),
                          SizedBox(height: 6.0),
                          ...routine.exercises
                              .map(
                                (exercise) => Padding(
                                  padding: EdgeInsets.only(top: 2.0),
                                  child: AutoSizeText(
                                    '●  ${exercise.name}',
                                    style: getTextStyle(TextStyles.body1),
                                    maxLines: 1,
                                    minFontSize: 12.0,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              )
                              .toList(),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 24.0),
                    child: VerticalDivider(),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(24.0),
                      child: Image.asset(
                        'assets/images/${routine.image}',
                        color: Color.lerp(AppColors.accent, AppColors.white, .6),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
          ],
        ),
        Positioned.fill(
          child: Material(
            color: AppColors.transparent,
            child: InkWell(onTap: () => model.selectRoutine(routine)),
          ),
        ),
      ],
    );
  }
}
