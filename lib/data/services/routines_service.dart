import 'package:flutter/cupertino.dart';
import 'package:track_workouts/data/model/routine/routine.dart';
import 'package:track_workouts/handlers/error/failure.dart';
import 'package:uuid/uuid.dart';

class RoutinesService {
  final List<_ExerciseWithId> _exercises = [];
  final List<_RoutineData> _routines = [];

  List<Exercise> get exercises => _exercises.copy();
  List<Routine> get routines => _routines.toRoutines(_exercises);

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
    _exercises.insert(0, _ExerciseWithId(newExercise));
  }

  Future<void> updateExercise(String oldName, Exercise exercise) async {
    final index = _getExerciseIndex(oldName);
    final old = _exercises[index];
    _exercises[index] = _ExerciseWithId(exercise, id: old.id);
  }

  Future<void> deleteExerciseWithName(String name) async {
    final index = _getExerciseIndex(name);
    final id = _exercises[index].id;
    _exercises.removeAt(index);

    for (final routineData in _routines) {
      routineData.exerciseIds.removeWhere((exerciseId) => exerciseId == id);
    }
  }

  Future<void> deleteRoutineWithName(String name) async {
    final index = _getRoutineIndex(name);
    _routines.removeAt(index);
  }

  Exercise getExerciseBy(String name) {
    final index = _getExerciseIndex(name);
    return _exercises[index].copy();
  }

  Future<void> addRoutine(Routine newRoutine) async {
    routines.forEach((routine) {
      if (routine.name.toLowerCase() == newRoutine.name.toLowerCase()) {
        throw Failure('A workout with this name already exists');
      }
      if (routine.hasSameExercises(newRoutine)) {
        throw Failure('A workout with these exercises already exists');
      }
    });
    _routines.add(_RoutineData.fromRoutine(newRoutine, _exercises));
  }

  Future<void> updateRoutine(String oldName, Routine routine) async {
    final index = _getRoutineIndex(oldName);
    _routines[index] = _RoutineData.fromRoutine(routine, _exercises);
  }

  void dispose() {
    //TODO: delete if not in use
  }
}

class _ExerciseWithId extends Exercise {
  final String id;

  _ExerciseWithId(Exercise exercise, {String id})
      : this.id = id ?? Uuid().v1(),
        super(name: exercise.name, attributes: exercise.attributes, numberOfSets: exercise.numberOfSets);
}

class _RoutineData {
  final String name;
  final String image;
  final List<String> exerciseIds;

  _RoutineData({
    @required this.name,
    @required this.image,
    @required this.exerciseIds,
  });

  factory _RoutineData.fromRoutine(Routine routine, List<_ExerciseWithId> allExercises) {
    return _RoutineData(
      name: routine.name,
      image: routine.image,
      exerciseIds: routine.exercises.map((exercise) => allExercises.firstWhere((e) => e.name == exercise.name).id).toList(),
    );
  }

  Routine toRoutine(List<_ExerciseWithId> allExercises) {
    return Routine(
      name: name,
      image: image,
      exercises: exerciseIds.map((id) => allExercises.firstWhere((exercise) => exercise.id == id)).toList(),
    );
  }
}

extension on List<_RoutineData> {
  List<Routine> toRoutines(List<_ExerciseWithId> allExercises) {
    return this.map((routineData) => routineData.toRoutine(allExercises)).toList();
  }
}
