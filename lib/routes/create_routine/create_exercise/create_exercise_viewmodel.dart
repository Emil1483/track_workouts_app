import 'package:flutter/cupertino.dart';
import 'package:track_workouts/data/model/workouts/workout/workout.dart';
import 'package:track_workouts/handlers/router.dart';
import 'package:track_workouts/routes/base/base_model.dart';

class CreateExerciseViewmodel extends BaseModel {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final List<SelectableAttribute> _selectableAttributes;

  final void Function(String) onError;

  CreateExerciseViewmodel({@required this.onError})
      : _selectableAttributes = AttributeName.values.map((name) => SelectableAttribute(name)).toList();

  List<SelectableAttribute> get selectableAttributes => _selectableAttributes.copy();

  void select(SelectableAttribute selectedAttribute) {
    final attribute = _selectableAttributes.firstWhere((attribute) => attribute.name == selectedAttribute.name);
    attribute.toggleSelected();
    notifyListeners();
  }

  void save() {
    if (!formKey.currentState.validate()) return;
    if (!_selectableAttributes.atLeastOneSelected()) {
      onError('Please select at least one attribute');
      return;
    }
    Router.pop();
  }
}

class SelectableAttribute {
  final AttributeName name;
  bool _selected;

  SelectableAttribute(this.name, [bool selected]) : _selected = selected ?? false;

  bool get selected => _selected;

  void toggleSelected() => _selected = !_selected;

  SelectableAttribute copy() => SelectableAttribute(name, _selected);
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
