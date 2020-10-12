import 'package:json_store/json_store.dart';
import 'package:track_workouts/data/model/routine/routine.dart';
import 'package:track_workouts/data/model/workouts/workout/workout.dart';
import 'package:track_workouts/handlers/error/failure.dart';
import 'package:track_workouts/utils/list_utils.dart';

class RoutinesService {
  final _jsonStore = JsonStore();

  List<Exercise> _exercises;
  List<Routine> _routines;

  List<Exercise> get exercises => _exercises.copy();
  List<Routine> get routines => _routines.copy();

  RoutinesService() {
    loadData();
  }

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

  Future<void> _saveData() async {
    await _jsonStore.setItem(
      'exercises',
      _exercises.map((exercise) => exercise.toMap()).toList().toMap(),
    );

    await _jsonStore.setItem(
      'routines',
      _routines.map((routine) => routine.toMap()).toList().toMap(),
    );
  }

  Future<void> loadData() async {
    final exercises = await _jsonStore.getItem('exercises');
    if (exercises == null) {
      _exercises = [];
      _routines = [];
      return;
    }

    final exerciseEntries = exercises.entries.toList();
    exerciseEntries.sort((a, b) => int.parse(a.key) - int.parse(b.key));
    _exercises = exerciseEntries.map((entry) => ExerciseSerializer.fromMap(entry.value)).toList();

    final routines = await _jsonStore.getItem('routines');
    if (routines == null) {
      _routines = [];
      return;
    }

    final routineEntries = routines.entries.toList();
    routineEntries.sort((a, b) => int.parse(a.key) - int.parse(b.key));
    _routines = routineEntries.map((entry) => RoutineSerializer.fromMap(entry.value)).toList();
  }

  Future<void> addExercise(Exercise newExercise) async {
    _exercises.forEach((existingExercise) {
      if (existingExercise.name.toLowerCase() == newExercise.name.toLowerCase()) {
        throw Failure('An exercise with this name already exists');
      }
    });
    _exercises.insert(0, newExercise.copy());

    await _saveData();
  }

  Future<void> updateExercise(String oldName, Exercise exercise) async {
    final index = _getExerciseIndex(oldName);
    _exercises[index] = exercise.copy();

    await _saveData();
  }

  Future<void> deleteExerciseWithName(String name) async {
    final index = _getExerciseIndex(name);
    final id = _exercises[index].id;
    _exercises.removeAt(index);

    for (final routineData in _routines) {
      routineData.exerciseIds.removeWhere((exerciseId) => exerciseId == id);
    }

    await _saveData();
  }

  Future<void> deleteRoutineWithName(String name) async {
    final index = _getRoutineIndex(name);
    _routines.removeAt(index);

    await _saveData();
  }

  Exercise tryGetExerciseByName(String name) {
    try {
      final index = _getExerciseIndex(name);
      return _exercises[index].copy();
    } on StateError catch (_) {
      return null;
    }
  }

  Exercise getExerciseById(String id) => _exercises.getExerciseFrom(id);

  Future<void> addRoutine(Routine newRoutine) async {
    routines.forEach((routine) {
      if (routine.name.toLowerCase() == newRoutine.name.toLowerCase()) {
        throw Failure('A workout with this name already exists');
      }
      if (routine.hasSameExercises(newRoutine)) {
        throw Failure('A workout with these exercises already exists');
      }
    });
    _routines.add(newRoutine.copy());

    await _saveData();
  }

  Future<void> updateRoutine(String oldName, Routine routine) async {
    final index = _getRoutineIndex(oldName);
    _routines[index] = routine.copy();

    await _saveData();
  }
}

extension ExerciseSerializer on Exercise {
  static Exercise fromMap(Map<String, dynamic> map) {
    return Exercise(
      name: map['name'],
      numberOfSets: map['numberOfSets'],
      attributes: (map['attributes'] as List<dynamic>).map((string) => AttributeNameExtension.fromString(string)).toList(),
      id: map['id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'numberOfSets': numberOfSets,
      'attributes': attributes.map((attribute) => attribute.toString()).toList(),
    };
  }
}

extension RoutineSerializer on Routine {
  static Routine fromMap(Map<String, dynamic> map) {
    return Routine(
      exerciseIds: (map['exerciseIds'] as List).map((id) => id as String).toList(),
      image: map['image'],
      name: map['name'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'image': image,
      'exerciseIds': exerciseIds,
    };
  }
}
