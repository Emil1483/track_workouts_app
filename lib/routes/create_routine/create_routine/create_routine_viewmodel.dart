import 'package:flutter/material.dart';
import 'package:track_workouts/data/model/routine/routine.dart';
import 'package:track_workouts/data/services/routines_service.dart';
import 'package:track_workouts/handlers/router.dart';
import 'package:track_workouts/routes/base/base_model.dart';
import 'package:track_workouts/routes/create_routine/create_exercise/create_exercise_route.dart';

class CreateRoutineViewmodel extends BaseModel {
  final RoutinesService routinesService;

  CreateRoutineViewmodel({@required this.routinesService});

  List<Exercise> get exercises => routinesService.exercises;

  Future<void> createExercise() async {
    await Router.pushNamed(CreateExerciseRoute.routeName);
    notifyListeners();
  }

  void deleteExercise(Exercise exercise) {
    routinesService.deleteExerciseWithName(exercise.name);
    notifyListeners();
  }
}
