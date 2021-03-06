import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:track_workouts/data/model/routine/routine.dart';
import 'package:track_workouts/data/model/workouts/workout/workout.dart';
import 'package:track_workouts/data/services/routines_service.dart';
import 'package:track_workouts/handlers/error/error_handler.dart';
import 'package:track_workouts/handlers/router.dart';
import 'package:track_workouts/routes/base/base_model.dart';

class CreateExerciseViewmodel extends BaseModel {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final List<SelectableAttribute> _selectableAttributes;

  int _numberOfSets;

  final RoutinesService routinesService;
  final void Function(String) onError;
  final TextEditingController exerciseNameController;
  final Exercise oldExercise;

  CreateExerciseViewmodel({@required this.routinesService, @required this.onError, this.oldExercise})
      : _selectableAttributes = AttributeName.values
            .map((name) => SelectableAttribute(
                  name,
                  selected: (oldExercise?.attributes ?? Exercise.defaultAttributes).contains(name),
                ))
            .toList()
              ..sort((a, b) {
                if (oldExercise == null) return 0;

                int indexA = oldExercise.attributes.indexOf(a.name);
                int indexB = oldExercise.attributes.indexOf(b.name);

                if (indexA == -1) indexA = AttributeName.values.length;
                if (indexB == -1) indexB = AttributeName.values.length;

                return indexA - indexB;
              }),
        exerciseNameController = TextEditingController(text: oldExercise?.name),
        _numberOfSets = oldExercise?.numberOfSets ?? 4;

  bool get _editing => oldExercise != null;

  List<SelectableAttribute> get selectableAttributes => _selectableAttributes.copy();

  int get numberOfSets => _numberOfSets;

  void changeNumberOfSets(double newValue) {
    _numberOfSets = newValue.round();
    notifyListeners();
  }

  void onReorderAttributes(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final attribute = _selectableAttributes.removeAt(oldIndex);
    _selectableAttributes.insert(newIndex, attribute);
    notifyListeners();
  }

  void select(SelectableAttribute selectedAttribute) {
    final attribute = _selectableAttributes.firstWhere((attribute) => attribute.name == selectedAttribute.name);
    attribute.toggleSelected();
    notifyListeners();
  }

  Future<void> save() async {
    if (!formKey.currentState.validate()) return;
    if (!_selectableAttributes.atLeastOneSelected()) {
      onError('Please select at least one attribute');
      return;
    }

    final exercise = Exercise(
      attributes: _selectableAttributes.where((attribute) => attribute.selected).map((attribute) => attribute.name).toList(),
      name: exerciseNameController.text.trim(),
      numberOfSets: _numberOfSets,
      id: oldExercise?.id,
    );

    await ErrorHandler.handleErrors(
      run: () => _saveExercise(exercise),
      onFailure: (failure) => onError(failure.message),
      onSuccess: (_) => MRouter.pop(exercise),
    );
  }

  Future<void> _saveExercise(Exercise exercise) async {
    if (_editing) {
      await routinesService.updateExercise(oldExercise.name, exercise);
    } else {
      await routinesService.addExercise(exercise);
    }
  }
}

class SelectableAttribute {
  final AttributeName name;
  bool _selected;

  SelectableAttribute(this.name, {bool selected}) : _selected = selected ?? false;

  bool get selected => _selected;

  void toggleSelected() => _selected = !_selected;

  SelectableAttribute copy() => SelectableAttribute(name, selected: _selected);
}

extension on List<SelectableAttribute> {
  List<SelectableAttribute> copy() => List.generate(length, (index) => this[index].copy());

  bool atLeastOneSelected() {
    for (final attribute in this) {
      if (attribute._selected) return true;
    }
    return false;
  }
}
