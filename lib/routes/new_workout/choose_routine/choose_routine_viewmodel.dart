import 'dart:math';

import 'package:flutter/material.dart';
import 'package:track_workouts/data/model/routine/routine.dart';
import 'package:track_workouts/data/model/workouts/workout/workout.dart';
import 'package:track_workouts/data/services/new_workout_service.dart';
import 'package:track_workouts/handlers/router.dart';
import 'package:track_workouts/routes/base/base_model.dart';
import 'package:track_workouts/routes/new_workout/new_workout/new_workout_route.dart';

class ChooseRoutineViewmodel extends BaseModel {
  final NewWorkoutService newWorkoutService;

  // TODO: use some other way to store this such that the user can create his own routines
  final List<Routine> _routines = [
    Routine(
      name: 'Pull Workout',
      exercises: [
        Exercise(
          name: 'Pull Ups',
          numberOfSets: 4,
          oneOf: [AttributeName.band_level, AttributeName.weight],
          attributes: [
            AttributeName.body_mass,
            AttributeName.pre_break,
            AttributeName.reps,
            AttributeName.weight,
            AttributeName.band_level,
          ],
        ),
        Exercise(name: 'Barbell Row', numberOfSets: 4, attributes: Exercise.defaultAttributes),
        Exercise(name: 'Reverse Grip Lat Pulldowns', numberOfSets: 4, attributes: Exercise.defaultAttributes),
        Exercise(name: 'Chest Supported Rear Delt Row', numberOfSets: 4, attributes: Exercise.defaultAttributes),
        Exercise(name: 'Narrow Grip Barbell Curl', numberOfSets: 3, attributes: Exercise.defaultAttributes),
        Exercise(name: 'Kneeling Face Pulls', numberOfSets: 2, attributes: Exercise.defaultAttributes),
        Exercise(name: 'Lying Face Pulls', numberOfSets: 2, attributes: Exercise.defaultAttributes),
      ],
    ),
    Routine(
      name: 'Push Workout',
      exercises: [
        Exercise(name: 'Incline Barbell Bench Press', numberOfSets: 4, attributes: Exercise.defaultAttributes),
        Exercise(name: 'Standing Dumbbell Shoulder Press', numberOfSets: 4, attributes: Exercise.defaultAttributes),
        Exercise(name: 'Paused Flat Dumbbell Press', numberOfSets: 4, attributes: Exercise.defaultAttributes),
        Exercise(name: 'Lean Away Dumbbell Lateral Raise', numberOfSets: 3, attributes: Exercise.defaultAttributes),
        Exercise(name: 'Seated Decline Cable Flies', numberOfSets: 3, attributes: Exercise.defaultAttributes),
        Exercise(name: 'Incline Dumbbell Overhead Extensions', numberOfSets: 3, attributes: Exercise.defaultAttributes),
      ],
    ),
  ];

  ChooseRoutineViewmodel({@required this.newWorkoutService});

  List<Routine> get routines => _routines.copy();

  void selectRoutine(Routine routine) {
    newWorkoutService.selectRoutine(routine);
    Router.pushReplacementNamed(NewWorkoutRoute.routeName);
  }

  // TODO: Delete this if not in use
  List<List<Routine>> routinesRows(int rowLength) {
    final List<List<Routine>> result = [];
    for (int i = 0; i < _routines.length; i += rowLength) {
      final end = min(i + rowLength, _routines.length);
      result.add(_routines.sublist(i, end).copy());
    }
    return result;
  }
}
