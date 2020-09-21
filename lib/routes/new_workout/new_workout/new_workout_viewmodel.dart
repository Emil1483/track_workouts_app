import 'package:flutter/material.dart';
import 'package:track_workouts/data/model/routine/routine.dart';
import 'package:track_workouts/data/services/new_workout_service.dart';
import 'package:track_workouts/routes/base/base_model.dart';
import 'package:track_workouts/style/theme.dart';

class NewWorkoutViewmodel extends BaseModel {
  final NewWorkoutService newWorkoutService;
  final List<ActiveExercise> _activeExercises;

  NewWorkoutViewmodel({@required this.newWorkoutService})
      : assert(newWorkoutService.selectedRoutine != null),
        _activeExercises = newWorkoutService.selectedRoutine.exercises.map((exercise) => ActiveExercise(exercise)).toList();

  List<ActiveExercise> get activeExercises => _activeExercises.copy();
}

enum Progress { not_started, started, completed }

extension ProgressExtension on Progress {
  Color get color {
    switch (this) {
      case Progress.not_started:
        return AppColors.transparent;
      case Progress.started:
        return AppColors.accent900;
      case Progress.completed:
        return AppColors.disabled;
    }
    return null;
  }
}

class ActiveExercise {
  final Exercise exercise;
  Progress progress = Progress.not_started;

  ActiveExercise(this.exercise);

  ActiveExercise copy() => ActiveExercise(exercise.copy());
}

extension on List<ActiveExercise> {
  List<ActiveExercise> copy() => List.generate(length, (i) => this[i].copy());
}
