import 'package:track_workouts/data/model/routine/routine.dart';
import 'package:track_workouts/handlers/error/failure.dart';

class RoutinesService {
  final List<Exercise> _exercises = [];
  final List<Routine> _routines = [];

  List<Exercise> get exercises => _exercises.copy();
  List<Routine> get routines => _routines.copy();

  Future<void> addExercise(Exercise newExercise) async {
    _exercises.forEach((existingExercise) {
      if (existingExercise.name.toLowerCase() == newExercise.name.toLowerCase()) {
        throw Failure('An exercise with this name already exists');
      }
    });
    _exercises.insert(0, newExercise);
  }

  void deleteExerciseWithName(String name) {
    _exercises.removeWhere((exercise) => exercise.name == name);
  }

  Exercise getExerciseBy(String name) => _exercises.firstWhere((exercise) => exercise.name == name);

  Future<void> addRoutine(Routine newRoutine) async {
    _routines.forEach((routine) {
      if (routine.name.toLowerCase() == newRoutine.name.toLowerCase()) {
        throw Failure('A workout with this name already exists');
      }
      if (routine.hasSameExercises(newRoutine)) {
        throw Failure('A workout with these exercises already exists');
      }
    });
    _routines.add(newRoutine);
  }

  void dispose() {
    //TODO: delete if not in use
  }
}

extension on List<Exercise> {
  List<Exercise> copy() => List.generate(length, (index) => this[index].copy());
}
