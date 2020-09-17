import 'package:flutter/material.dart';
import 'package:track_workouts/handlers/router.dart';
import 'package:track_workouts/routes/root/color_utils.dart';
import 'package:track_workouts/routes/root/root_viewmodel.dart';
import 'package:track_workouts/ui_elements/date_widget.dart';
import 'package:track_workouts/style/theme.dart';

class WorkoutWidget extends StatelessWidget {
  final FormattedWorkout workout;

  const WorkoutWidget({@required this.workout});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Router.pushNamed(Router.workoutDetailsRoute, arguments: [workout]),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 14.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('●  ', style: getTextStyle(TextStyles.subtitle1).copyWith(color: ColorUtils.getColorFrom(workout))),
                    DateWidget(date: workout.date, style: getTextStyle(TextStyles.subtitle1)),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 6.0),
                  child: Icon(Icons.chevron_right),
                ),
              ],
            ),
          ),
          Divider(),
        ],
      ),
    );
  }
}
