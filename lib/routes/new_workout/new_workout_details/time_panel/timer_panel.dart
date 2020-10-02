import 'package:flutter/material.dart';
import 'package:track_workouts/routes/new_workout/new_workout_details/time_panel/countdown/countdown_tab.dart';
import 'package:track_workouts/routes/new_workout/new_workout_details/time_panel/timer/timer.dart';
import 'package:track_workouts/style/theme.dart';

class TimePanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          SizedBox(height: 64.0),
          Expanded(
            child: TabBarView(
              children: [
                CountdownTab(),
                Timer(),
              ],
            ),
          ),
          Container(
            color: AppColors.primary,
            child: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.timelapse)),
                Tab(icon: Icon(Icons.timer)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
