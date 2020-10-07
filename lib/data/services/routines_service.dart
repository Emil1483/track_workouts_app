import 'package:track_workouts/data/model/routine/routine.dart';
import 'package:track_workouts/handlers/error/failure.dart';

class RoutinesService {
  final List<Exercise> _exercises = [];
  final List<Routine> _routines = [];

  List<Exercise> get exercises => _exercises.copy();
  List<Routine> get routines => _routines.copy();

  int _getExerciseIndex(String name) {
    final index = _exercises.indexWhere((exercise) => exercise.name == name);
    if (index == -1) throw StateError('could not find exercise with name $name');
    return index;
  }

  int _getRoutineIndex(String name) {
    final index = _routines.indexWhere((routine) => routine.name == name);
    if (index == -1) throw StateError('could not find exercise with name $name');
    return index;
  }

  Future<void> addExercise(Exercise newExercise) async {
    _exercises.forEach((existingExercise) {
      if (existingExercise.name.toLowerCase() == newExercise.name.toLowerCase()) {
        throw Failure('An exercise with this name already exists');
      }
    });
    _exercises.insert(0, newExercise);
  }

  Future<void> updateExercise(String oldName, Exercise exercise) async {
    final index = _getExerciseIndex(oldName);
    _exercises[index] = exercise;
  }

  Future<void> deleteExerciseWithName(String name) async {
    final index = _getExerciseIndex(name);
    _exercises.removeAt(index);
  }

  Future<void> deleteRoutineWithName(String name) async {
    final index = _getRoutineIndex(name);
    _routines.removeAt(index);
  }

  Exercise getExerciseBy(String name) {
    final index = _getExerciseIndex(name);
    return _exercises[index];
  }

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

  Future<void> updateRoutine(String oldName, Routine routine) async {
    final index = _getRoutineIndex(oldName);
    _routines[index] = routine;
  }

  void dispose() {
    //TODO: delete if not in use
  }
}

extension on List<Exercise> {
  List<Exercise> copy() => List.generate(length, (index) => this[index].copy());
}
