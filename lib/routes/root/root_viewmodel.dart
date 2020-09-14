import 'package:flutter/cupertino.dart';
import 'package:track_workouts/data/model/workouts/workout/workout.dart';
import 'package:track_workouts/data/services/workouts_service.dart';
import 'package:track_workouts/handlers/error/error_handler.dart';
import 'package:track_workouts/handlers/error/failure.dart';
import 'package:track_workouts/routes/base/base_model.dart';

class RootViewmodel extends BaseModel {
  final WorkoutsService _workoutsService;

  Failure _failure;

  RootViewmodel(this._workoutsService);

  List<FormattedWorkout> get workouts => _workoutsService.workouts.map((workout) => FormattedWorkout.from(workout)).toList();
  Failure get error => _failure.copy();
  bool get hasError => _failure != null;

  Future<void> getWorkouts() async {
    setLoading(true);
    await ErrorHandler.handleErrors<void>(
      run: _workoutsService.loadWorkouts,
      onFailure: (failure) => _failure = failure,
      onSuccess: (_) {},
    );
    setLoading(false);
  }
}

class FormattedWorkout {
  final DateTime date;
  final List<FormattedExercise> exercises;
  final String id;

  FormattedWorkout({
    @required this.date,
    @required this.exercises,
    @required this.id,
  });

  @override
  String toString() => 'date = $date, id = $id, exercises = $exercises';

  factory FormattedWorkout.from(Workout workout) {
    final List<FormattedExercise> exercises = [];
    workout.exercises.forEach((name, sets) => exercises.add(FormattedExercise(name, sets)));
    return FormattedWorkout(
      date: workout.date,
      id: workout.id,
      exercises: exercises,
    );
  }
}

class FormattedExercise {
  final String name;
  final List<Map<String, double>> sets;

  FormattedExercise(this.name, this.sets);

  @override
  String toString() => 'name = $name, sets = $sets';
}
