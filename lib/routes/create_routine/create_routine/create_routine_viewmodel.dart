import 'package:flutter/material.dart';
import 'package:track_workouts/data/model/routine/routine.dart';
import 'package:track_workouts/data/services/routines_service.dart';
import 'package:track_workouts/handlers/error/error_handler.dart';
import 'package:track_workouts/handlers/router.dart';
import 'package:track_workouts/routes/base/base_model.dart';
import 'package:track_workouts/routes/create_routine/create_exercise/create_exercise_route.dart';

class CreateRoutineViewmodel extends BaseModel {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final RoutinesService routinesService;
  final void Function(String) onError;
  final TextEditingController exerciseNameController;
  final List<SelectableExercise> _selectableExercises;
  final _oldName;

  CreateRoutineViewmodel({@required this.routinesService, @required this.onError, Routine routine})
      : _selectableExercises = SelectableExercise.list(routinesService.exercises)..selectAll(routine?.exercises),
        exerciseNameController = TextEditingController(text: routine?.name),
        _oldName = routine?.name;

  bool get _editing => _oldName != null;

  bool get missingExercises {
    for (final exercise in _selectableExercises) {
      if (exercise.selected) return false;
    }
    return true;
  }

  bool get allExercisesSelected {
    for (final exercise in _selectableExercises) {
      if (!exercise.selected) return false;
    }
    return true;
  }

  bool get noExercisesMade => routinesService.exercises.isEmpty;

  List<Exercise> getExercisesBySelected(bool selected) {
    return _selectableExercises.where((exercise) => exercise.selected == selected).map((exercise) => exercise.exercise).toList();
  }

  int _getExerciseIndex(Exercise exercise) {
    return _selectableExercises.indexWhere((selectableExercise) => selectableExercise.exercise.name == exercise.name);
  }

  void select(Exercise exercise) {
    final index = _getExerciseIndex(exercise);
    _selectableExercises[index].toggleSelected();
    notifyListeners();
  }

  Future<void> edit(Exercise exercise) async {
    final result = await Router.pushNamed(CreateExerciseRoute.routeName, arguments: [exercise]);
    final exerciseResult = result as Exercise;
    if (exerciseResult == null) return;

    final index = _getExerciseIndex(exercise);
    final selectableExercise = _selectableExercises[index];
    _selectableExercises[index] = SelectableExercise(exerciseResult, selected: selectableExercise.selected);
    notifyListeners();
  }

  Future<void> createExercise() async {
    final result = await Router.pushNamed(CreateExerciseRoute.routeName);
    final exercise = result as Exercise;
    if (exercise == null) return;
    _selectableExercises.add(SelectableExercise(exercise));
    notifyListeners();
  }

  Future<void> delete(Exercise exercise) async {
    await ErrorHandler.handleErrors(
      run: () => routinesService.deleteExerciseWithName(exercise.name),
      onFailure: (failure) => onError(failure.message),
      onSuccess: (_) {
        final index = _getExerciseIndex(exercise);
        _selectableExercises.removeAt(index);
        notifyListeners();
      },
    );
  }

  Future<void> save() async {
    if (!formKey.currentState.validate()) return;
    if (!_selectableExercises.atLeastOneSelected()) {
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
      exercises: _selectableExercises.where((exercise) => exercise.selected).map((exercise) => exercise.exercise).toList(),
      name: exerciseNameController.text.trim(),
      image: 'default.png',
    );
    if (_editing) {
      routinesService.updateRoutine(_oldName, routine);
    } else {
      routinesService.addRoutine(routine);
    }
  }
}

// TODO: refactor this with selectable attribute
class SelectableExercise {
  final Exercise exercise;
  bool _selected;

  SelectableExercise(this.exercise, {bool selected}) : _selected = selected ?? false;

  static List<SelectableExercise> list(List<Exercise> exercises) =>
      exercises.map((exercise) => SelectableExercise(exercise)).toList();

  bool get selected => _selected;

  void toggleSelected() => _selected = !_selected;

  void setSelected(bool value) => _selected = value;

  SelectableExercise copy() => SelectableExercise(exercise, selected: _selected);
}

extension on List<SelectableExercise> {
  bool atLeastOneSelected() {
    for (final attribute in this) {
      if (attribute._selected) return true;
    }
    return false;
  }

  void selectAll(List<Exercise> selectedExercises) {
    if (selectedExercises == null) return;
    selectedExercises.forEach((selectedExercise) {
      final exercise = this.firstWhere((selectable) => selectable.exercise.name == selectedExercise.name);
      exercise.setSelected(true);
    });
  }
}
