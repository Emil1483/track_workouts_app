import 'package:flutter/material.dart';
import 'package:track_workouts/data/model/routine/routine.dart';
import 'package:track_workouts/data/model/workouts/workout/workout.dart';
import 'package:track_workouts/routes/base/base_model.dart';
import 'package:track_workouts/utils/map_utils.dart';

class NewExerciseDetailsViewmodel extends BaseModel {
  final GlobalKey<FormState> formKey = GlobalKey();

  final Exercise exercise;

  final List<ActiveSet> _activeSets;
  final Map<AttributeName, TextEditingController> _controllers;

  NewExerciseDetailsViewmodel(this.exercise)
      : _activeSets = [_getActiveSet(exercise)..removeAttribute(AttributeName.pre_break)],
        _controllers = Map.fromIterable(exercise.attributes, value: (_) => TextEditingController());

  static ActiveSet _getActiveSet(Exercise exercise) {
    return ActiveSet(attributes: Map.fromIterable(exercise.attributes, value: (_) => null));
  }

  List<ActiveSet> get activeSets => _activeSets.copy();

  TextEditingController getControllerFrom(AttributeName name) => _controllers[name];

  void saveSets() {
    if (!formKey.currentState.validate()) return;

    _controllers.forEach((attributeName, controller) {
      final attributes = _activeSets.last.attributes;
      if (!attributes.containsKey(attributeName)) return;
      attributes[attributeName] = double.tryParse(controller.text);
    });

    _activeSets.last.completeSet();
    _activeSets.add(_getActiveSet(exercise));
    notifyListeners();
  }

  void updateField(AttributeName attributeName, String valueString) {
    _activeSets.last.attributes[attributeName] = double.tryParse(valueString);
  }
}

class ActiveSet {
  bool _completed = false;
  final Map<AttributeName, double> attributes;

  ActiveSet({@required this.attributes, bool completed}) {
    if (completed != null) _completed = completed;
  }

  ActiveSet copy() => ActiveSet(attributes: attributes.copy(), completed: _completed);

  bool get completed => _completed;

  void completeSet() {
    attributes.forEach((_, value) {
      assert(value != null);
    });
    _completed = true;
  }

  void removeAttribute(AttributeName attributeName) => attributes.remove(attributeName);
}

extension on List<ActiveSet> {
  List<ActiveSet> copy() => List.generate(length, (index) => this[index].copy());
}
