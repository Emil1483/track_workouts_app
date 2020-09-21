import 'package:flutter/material.dart';
import 'package:track_workouts/routes/base/base_widget.dart';
import 'package:track_workouts/routes/new_workout/new_workout_viewmodel.dart';

class NewWorkoutRoute extends StatelessWidget {
  static const String routeName = 'newWorkout';

  @override
  Widget build(BuildContext context) {
    return BaseWidget<NewWorkoutViewmodel>(
      model: NewWorkoutViewmodel(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(title: Text('New Workout')),
      ),
    );
  }
}
