import 'package:flutter/material.dart';
import 'package:track_workouts/data/model/routine/routine.dart';
import 'package:track_workouts/data/services/routines_service.dart';
import 'package:track_workouts/handlers/error/error_handler.dart';
import 'package:track_workouts/handlers/router.dart';
import 'package:track_workouts/routes/base/base_model.dart';
import 'package:track_workouts/routes/create_routine/create_exercise/create_exercise_route.dart';

class CreateRoutineViewmodel extends BaseModel {
  final TextEditingController exerciseNameController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final RoutinesService routinesService;
  final void Function(String) onError;
  final List<SelectableExercise> _selectableExercises;

  CreateRoutineViewmodel({@required this.routinesService, @required this.onError})
      : _selectableExercises = routinesService.exercises.map((exercise) => SelectableExercise(exercise)).toList();

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

  Future<void> createExercise() async {
    final result = await Router.pushNamed(CreateExerciseRoute.routeName);
    final exercise = result as Exercise;
    if (exercise == null) return;
    _selectableExercises.add(SelectableExercise(exercise));
    notifyListeners();
  }

  void delete(Exercise exercise) {
    routinesService.deleteExerciseWithName(exercise.name);
    final index = _getExerciseIndex(exercise);
    _selectableExercises.removeAt(index);
    notifyListeners();
  }

  Future<void> save() async {
    if (!formKey.currentState.validate()) return;
    if (!_selectableExercises.atLeastOneSelected()) {
      onError('Please add at least one exercise');
      return;
    }

    await ErrorHandler.handleErrors(
      run: () => routinesService.addRoutine(
        Routine(
          exercises: _selectableExercises.map((exercise) => exercise.exercise).toList(),
          name: exerciseNameController.text.trim(),
          image: 'default.png',
        ),
      ),
      onFailure: (failure) => onError(failure.message),
      onSuccess: (_) => Router.pop(),
    );
  }
}

// TODO: refactor this with selectable attribute
class SelectableExercise {
  final Exercise exercise;
  bool _selected;

  SelectableExercise(this.exercise, {bool selected}) : _selected = selected ?? false;

  bool get selected => _selected;

  void toggleSelected() => _selected = !_selected;

  SelectableExercise copy() => SelectableExercise(exercise, selected: _selected);
}

extension on List<SelectableExercise> {
  bool atLeastOneSelected() {
    for (final attribute in this) {
      if (attribute._selected) return true;
    }
    return false;
  }
}
