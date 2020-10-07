import 'package:flutter/cupertino.dart';
import 'package:track_workouts/data/model/routine/routine.dart';
import 'package:track_workouts/data/model/workouts/workout/workout.dart';
import 'package:track_workouts/data/services/routines_service.dart';
import 'package:track_workouts/handlers/error/error_handler.dart';
import 'package:track_workouts/handlers/router.dart';
import 'package:track_workouts/routes/base/base_model.dart';

class CreateExerciseViewmodel extends BaseModel {
  final TextEditingController exerciseNameController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final List<SelectableAttribute> _selectableAttributes;

  int _numberOfSets = 4;

  final RoutinesService routinesService;
  final void Function(String) onError;

  CreateExerciseViewmodel({@required this.routinesService, @required this.onError})
      : _selectableAttributes = AttributeName.values
            .map((name) => SelectableAttribute(
                  name,
                  selected: Exercise.defaultAttributes.contains(name),
                ))
            .toList();

  List<SelectableAttribute> get selectableAttributes => _selectableAttributes.copy();

  int get numberOfSets => _numberOfSets;

  void changeNumberOfSets(double newValue) {
    _numberOfSets = newValue.round();
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
    );

    await ErrorHandler.handleErrors(
      run: () => routinesService.addExercise(exercise),
      onFailure: (failure) => onError(failure.message),
      onSuccess: (_) => Router.pop(exercise),
    );
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