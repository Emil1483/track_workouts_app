import 'package:flutter/material.dart';
import 'package:track_workouts/data/model/routine/routine.dart';
import 'package:track_workouts/data/services/routines_service.dart';
import 'package:track_workouts/handlers/error/error_handler.dart';
import 'package:track_workouts/handlers/router.dart';
import 'package:track_workouts/routes/base/base_model.dart';
import 'package:track_workouts/routes/create_routine/create_exercise/create_exercise_route.dart';

class CreateRoutineViewmodel extends BaseModel {
  static const List<String> images = ['default.png', 'bench_press.png', 'pull_up.png'];

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String _selectedImage;

  final RoutinesService routinesService;
  final void Function(String) onError;
  final TextEditingController exerciseNameController;
  final List<Exercise> _selectedExercises;
  final _oldName;

  CreateRoutineViewmodel({@required this.routinesService, @required this.onError, Routine routine})
      : _selectedExercises = routine?.exercises?.copy() ?? [],
        exerciseNameController = TextEditingController(text: routine?.name),
        _oldName = routine?.name,
        _selectedImage = routine?.image ?? images.first;

  bool get _editing => _oldName != null;

  List<List<String>> getImageRows(int rowLength) {
    List<List<String>> result = [];
    for (int i = 0; i < images.length; i += rowLength) {
      int end = i + rowLength;
      int rest = 0;
      if (end > images.length) {
        rest = end - images.length;
        end = images.length;
      }
      result.add([
        ...images.sublist(i, end),
        ...List.generate(rest, (_) => null),
      ]);
    }
    return result;
  }

  String get selectedImage => _selectedImage;

  void selectImage(String image) {
    _selectedImage = image;
    notifyListeners();
  }

  List<Exercise> get selectedExercises => _selectedExercises.copy();

  List<Exercise> get notSelectedExercises =>
      routinesService.exercises.where((exercise) => !_selectedExercises.containsName(exercise.name)).toList();

  bool get noExercisesSelected => _selectedExercises.isEmpty;

  bool get allExercisesSelected => routinesService.exercises.length == _selectedExercises.length;

  bool get noExercisesMade => routinesService.exercises.isEmpty;

  int _getExerciseIndex(Exercise exercise) {
    return _selectedExercises.indexWhere((selectedExercise) => selectedExercise.name == exercise.name);
  }

  void toggleSelected(Exercise exercise) {
    final index = _getExerciseIndex(exercise);
    if (index == -1) {
      _selectedExercises.add(exercise);
    } else {
      _selectedExercises.removeAt(index);
    }
    notifyListeners();
  }

  void onReorderExercises(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final exercise = _selectedExercises.removeAt(oldIndex);
    _selectedExercises.insert(newIndex, exercise);
    notifyListeners();
  }

  Future<void> edit(Exercise exercise) async {
    final result = await Router.pushNamed(CreateExerciseRoute.routeName, arguments: [exercise]);
    final updatedExercise = result as Exercise;
    if (updatedExercise == null) return;

    final index = _getExerciseIndex(exercise);
    if (index != -1) {
      _selectedExercises[index] = updatedExercise;
    }
    notifyListeners();
  }

  Future<void> createExercise() async {
    final result = await Router.pushNamed(CreateExerciseRoute.routeName);
    final updatedExercise = result as Exercise;
    if (updatedExercise == null) return;

    _selectedExercises.add(updatedExercise);
    notifyListeners();
  }

  Future<void> delete(Exercise exercise) async {
    await ErrorHandler.handleErrors(
      run: () => routinesService.deleteExerciseWithName(exercise.name),
      onFailure: (failure) => onError(failure.message),
      onSuccess: (_) {
        final index = _getExerciseIndex(exercise);
        if (index != -1) _selectedExercises.removeAt(index);
        notifyListeners();
      },
    );
  }

  Future<void> save() async {
    if (!formKey.currentState.validate()) return;
    if (_selectedExercises.isEmpty) {
      onError('Please add at least one exercise');
      return;
    }

    await ErrorHandler.handleErrors(
      run: _saveRoutine,
      onFailure: (failure) => onError(failure.message),
      onSuccess: (_) => Router.pop(),
    );
  }

  Future<void> _saveRoutine() async {
    final routine = Routine(exercises: _selectedExercises, name: exerciseNameController.text.trim(), image: _selectedImage);
    if (_editing) {
      routinesService.updateRoutine(_oldName, routine);
    } else {
      routinesService.addRoutine(routine);
    }
  }
}

extension on List<Exercise> {
  bool containsName(String name) {
    for (final exercise in this) {
      if (exercise.name == name) return true;
    }
    return false;
  }
}
