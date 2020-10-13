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
  final List<String> _selectedExerciseIds;
  final Routine oldRoutine;

  CreateRoutineViewmodel({@required this.routinesService, @required this.onError, this.oldRoutine})
      : _selectedExerciseIds = oldRoutine?.exerciseIds?.copy() ?? [],
        exerciseNameController = TextEditingController(text: oldRoutine?.name),
        _selectedImage = oldRoutine?.image ?? images.first;

  bool get _editing => oldRoutine != null;

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

  List<Exercise> get selectedExercises {
    return _selectedExerciseIds.map((id) => routinesService.exercises.getExerciseFrom(id)).toList().copy();
  }

  List<Exercise> get notSelectedExercises =>
      routinesService.exercises.where((exercise) => !selectedExercises.containsName(exercise.name)).toList();

  bool get noExercisesSelected => selectedExercises.isEmpty;

  bool get allExercisesSelected => routinesService.exercises.length == selectedExercises.length;

  bool get noExercisesMade => routinesService.exercises.isEmpty;

  int _getExerciseIndex(Exercise exercise) {
    return _selectedExerciseIds.indexWhere((id) => id == exercise.id);
  }

  void toggleSelected(Exercise exercise) {
    final index = _getExerciseIndex(exercise);
    if (index == -1) {
      _selectedExerciseIds.add(exercise.id);
    } else {
      _selectedExerciseIds.removeAt(index);
    }
    notifyListeners();
  }

  void onReorderExercises(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final exerciseId = _selectedExerciseIds.removeAt(oldIndex);
    _selectedExerciseIds.insert(newIndex, exerciseId);
    notifyListeners();
  }

  Future<void> edit(Exercise exercise) async {
    await Router.pushNamed(CreateExerciseRoute.routeName, arguments: [exercise]);
    notifyListeners();
  }

  Future<void> createExercise() async {
    final result = await Router.pushNamed(CreateExerciseRoute.routeName);
    final updatedExercise = result as Exercise;
    if (updatedExercise == null) return;

    _selectedExerciseIds.add(updatedExercise.id);
    notifyListeners();
  }

  Future<void> delete(Exercise exercise) async {
    await ErrorHandler.handleErrors(
      run: () => routinesService.deleteExerciseWithName(exercise.name),
      onFailure: (failure) => onError(failure.message),
      onSuccess: (_) {
        final index = _getExerciseIndex(exercise);
        if (index != -1) _selectedExerciseIds.removeAt(index);
        notifyListeners();
      },
    );
  }

  Future<void> save() async {
    if (!formKey.currentState.validate()) return;
    if (_selectedExerciseIds.isEmpty) {
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
    final routine = Routine(
      id: oldRoutine?.id,
      exerciseIds: _selectedExerciseIds,
      name: exerciseNameController.text.trim(),
      image: _selectedImage,
    );
    if (_editing) {
      routinesService.updateRoutine(oldRoutine.name, routine);
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
