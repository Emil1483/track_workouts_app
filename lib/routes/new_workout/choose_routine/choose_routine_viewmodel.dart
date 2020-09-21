import 'dart:math';

import 'package:track_workouts/data/model/routine/routine.dart';
import 'package:track_workouts/data/model/workouts/workout/workout.dart';
import 'package:track_workouts/routes/base/base_model.dart';

class ChooseRoutineViewmodel extends BaseModel {
  // TODO: use some other way to store this such that the user can create his own routines
  final List<Routine> _routines = [
    Routine(
      name: 'Pull Workout',
      exercises: [
        Exercise(name: 'Pull Ups', attributes: [
          AttributeName.body_mass,
          AttributeName.pre_break,
          AttributeName.reps,
          AttributeName.weight,
          AttributeName.band_level,
        ]),
        Exercise(name: 'Barbell Row', attributes: Exercise.defaultAttributes),
        Exercise(name: 'Reverse Grip Lat Pulldowns', attributes: Exercise.defaultAttributes),
        Exercise(name: 'Chest Supported Rear Delt Row', attributes: Exercise.defaultAttributes),
        Exercise(name: 'Narrow Grip Barbell Curl', attributes: Exercise.defaultAttributes),
        Exercise(name: 'Kneeling Face Pulls', attributes: Exercise.defaultAttributes),
        Exercise(name: 'Lying Face Pulls', attributes: Exercise.defaultAttributes),
      ],
    ),
    Routine(
      name: 'Push Workout',
      exercises: [
        Exercise(name: 'Incline Barbell Bench Press', attributes: Exercise.defaultAttributes),
        Exercise(name: 'Standing Dumbbell Shoulder Press', attributes: Exercise.defaultAttributes),
        Exercise(name: 'Paused Flat Dumbbell Press', attributes: Exercise.defaultAttributes),
        Exercise(name: 'Lean Away Dumbbell Lateral Raise', attributes: Exercise.defaultAttributes),
        Exercise(name: 'Seated Decline Cable Flies', attributes: Exercise.defaultAttributes),
        Exercise(name: 'Incline Dumbbell Overhead Extensions', attributes: Exercise.defaultAttributes),
      ],
    ),
  ];

  List<Routine> get routines => _routines.copy();

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
