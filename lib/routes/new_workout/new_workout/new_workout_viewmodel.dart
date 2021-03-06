import 'package:flutter/material.dart';
import 'package:track_workouts/data/model/routine/routine.dart';
import 'package:track_workouts/data/services/new_workout_service.dart';
import 'package:track_workouts/data/services/routines_service.dart';
import 'package:track_workouts/handlers/router.dart';
import 'package:track_workouts/routes/base/base_model.dart';
import 'package:track_workouts/routes/create_routine/create_exercise/create_exercise_route.dart';
import 'package:track_workouts/routes/new_workout/choose_routine/choose_routine_route.dart';
import 'package:track_workouts/routes/new_workout/new_workout_details/new_exercise_details_route.dart';
import 'package:track_workouts/style/theme.dart';

class NewWorkoutViewmodel extends BaseModel {
  final RoutinesService routinesService;
  final NewWorkoutService newWorkoutService;

  NewWorkoutViewmodel({@required this.newWorkoutService, @required this.routinesService})
      : assert(newWorkoutService.selectedRoutine != null) {
    newWorkoutService.updateCurrentRoutine();
  }

  List<MapEntry<String, List<ActiveSet>>> get activeExercises =>
      newWorkoutService.selectedRoutine.activeExercises.entries.toList();

  String get routineName => newWorkoutService.selectedRoutine.name;

  Exercise getExerciseFrom(String id) => routinesService.getExerciseById(id);

  List<Exercise> get notIncludedExercises => newWorkoutService.notActiveExercises;

  Future<void> createNewExercise() async {
    MRouter.pushNamed(CreateExerciseRoute.routeName);
    notifyListeners();
  }

  void addExercise(Exercise exercise) {
    newWorkoutService.addExerciseToActiveExercises(exercise);
    notifyListeners();
  }

  Future<void> goToDetails(Exercise exercise) async {
    await MRouter.pushNamed(NewExerciseDetailsRoute.routeName, arguments: [exercise]);

    notifyListeners();
  }

  void switchWorkout() => MRouter.pushReplacementNamed(ChooseRoutineRoute.routeName);

  void reorderExercises(int oldIndex, int newIndex) {
    newWorkoutService.reorderExercises(oldIndex, newIndex);
    notifyListeners();
  }

  void removeExercise(String id) {
    newWorkoutService.removeExercise(id);
    notifyListeners();
  }
}

enum Progress { not_started, started, completed }

extension ExerciseMapEntry on MapEntry<String, List<ActiveSet>> {
  Progress getProgress(int maxSets) {
    final activeSets = value.whereChecked;
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
