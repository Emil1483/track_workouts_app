import 'package:flutter/material.dart';
import 'package:track_workouts/data/model/routine/routine.dart';
import 'package:track_workouts/data/services/new_workout_service.dart';
import 'package:track_workouts/data/services/routines_service.dart';
import 'package:track_workouts/handlers/router.dart';
import 'package:track_workouts/routes/base/base_model.dart';
import 'package:track_workouts/routes/create_routine/create_routine/create_routine_route.dart';
import 'package:track_workouts/routes/new_workout/new_workout/new_workout_route.dart';

class ChooseRoutineViewmodel extends BaseModel {
  final NewWorkoutService newWorkoutService;
  final RoutinesService routinesService;

  ChooseRoutineViewmodel({@required this.newWorkoutService, @required this.routinesService});

  List<Routine> get routines => routinesService.routines;

  void selectRoutine(Routine routine) {
    newWorkoutService.selectRoutine(routine);
    Router.pushReplacementNamed(NewWorkoutRoute.routeName);
  }

  Future<void> createRoutine() async {
    await Router.pushNamed(CreateRoutine.routeName);
    notifyListeners();
  }
}
