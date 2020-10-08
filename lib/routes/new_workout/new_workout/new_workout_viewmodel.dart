import 'package:flutter/material.dart';
import 'package:track_workouts/data/model/routine/routine.dart';
import 'package:track_workouts/data/services/new_workout_service.dart';
import 'package:track_workouts/data/services/routines_service.dart';
import 'package:track_workouts/handlers/router.dart';
import 'package:track_workouts/routes/base/base_model.dart';
import 'package:track_workouts/routes/new_workout/new_workout_details/new_exercise_details_route.dart';
import 'package:track_workouts/style/theme.dart';

class NewWorkoutViewmodel extends BaseModel {
  final NewWorkoutService newWorkoutService;
  final RoutinesService routinesService;

  NewWorkoutViewmodel({@required this.newWorkoutService, @required this.routinesService})
      : assert(newWorkoutService.selectedRoutine != null);

  Map<String, List<ActiveSet>> get activeExercises => newWorkoutService.selectedRoutine.activeExercises;

  Exercise getExerciseFrom(String exerciseName) => routinesService.getExerciseBy(exerciseName);

  Future<void> goToDetails(Exercise exercise) async {
    await Router.pushNamed(NewExerciseDetailsRoute.routeName, arguments: [exercise]);
    notifyListeners();
  }
}

enum Progress { not_started, started, completed }

extension ExerciseMapEntry on MapEntry<String, List<ActiveSet>> {
  Progress getProgress(int maxSets) {
    final activeSets = value.where((activeSet) => activeSet.checked);
    if (activeSets.isEmpty) return Progress.not_started;
    if (activeSets.length >= maxSets) return Progress.completed;
    return Progress.started;
  }
}

extension ProgressExtension on Progress {
  Color get color {
    switch (this) {
      case Progress.not_started:
        return AppColors.black900;
      case Progress.started:
        return AppColors.primary.withOpacity(.65);
      case Progress.completed:
        return AppColors.primary.withOpacity(.9);
    }
    return null;
  }

  TextStyle get textStyle {
    TextStyle result = getTextStyle(TextStyles.h2);
    if (this == Progress.completed) {
      result = result.copyWith(color: AppColors.accent, fontStyle: FontStyle.italic);
    }
    return result;
  }
}
