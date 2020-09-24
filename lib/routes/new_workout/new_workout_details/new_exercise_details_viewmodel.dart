import 'package:flutter/material.dart';
import 'package:track_workouts/data/model/routine/routine.dart';
import 'package:track_workouts/data/model/workouts/workout/workout.dart';
import 'package:track_workouts/handlers/error/error_handler.dart';
import 'package:track_workouts/handlers/error/failure.dart';
import 'package:track_workouts/routes/base/base_model.dart';
import 'package:track_workouts/utils/map_utils.dart';
import 'package:track_workouts/utils/list_utils.dart';
import 'package:track_workouts/utils/validation_utils.dart';

class NewExerciseDetailsViewmodel extends BaseModel {
  final GlobalKey<FormState> formKey = GlobalKey();

  final Exercise exercise;
  final void Function(String) onError;

  final List<ActiveSet> _activeSets;
  final Map<AttributeName, TextEditingController> _controllers;

  NewExerciseDetailsViewmodel({@required this.exercise, @required this.onError})
      : _activeSets = [_getActiveSet(exercise)..removeAttribute(AttributeName.pre_break)],
        _controllers = Map.fromIterable(exercise.attributes, value: (_) => TextEditingController());

  static ActiveSet _getActiveSet(Exercise exercise) {
    return ActiveSet(attributes: Map.fromIterable(exercise.attributes, value: (_) => null), oneOf: exercise.oneOf);
  }

  List<ActiveSet> get activeSets => _activeSets.copy();

  TextEditingController getControllerFrom(AttributeName name) => _controllers[name];

  String validateAttribute(AttributeName name, String value) {
    if (value.isNotEmpty) {
      final numberValidation = Validation.mustBeNumber(value);
      if (numberValidation != null) return Validation.mustBeNumber(value);
    }

    if (!(_activeSets.last.oneOf?.contains(name) ?? false)) return Validation.mustBeNumber(value);

    return null;
  }

  Future<void> saveSets() async {
    if (!formKey.currentState.validate()) return;

    _controllers.forEach((attributeName, controller) {
      final attributes = _activeSets.last.attributes;
      if (!attributes.containsKey(attributeName)) return;
      attributes[attributeName] = double.tryParse(controller.text);
    });

    await ErrorHandler.handleErrors(
      run: () async => _activeSets.last.completeSet(),
      onFailure: (failure) => onError(failure.message),
      onSuccess: (_) {
        _activeSets.last.completeSet();
        _activeSets.add(_getActiveSet(exercise));
        notifyListeners();
      },
    );
  }

  void updateField(AttributeName attributeName, String valueString) {
    _activeSets.last.attributes[attributeName] = double.tryParse(valueString);
  }
}

class ActiveSet {
  bool _completed = false;
  final Map<AttributeName, double> attributes;
  final List<AttributeName> oneOf;

  ActiveSet({@required this.attributes, @required this.oneOf, bool completed}) {
    if (completed != null) _completed = completed;
  }

  ActiveSet copy() => ActiveSet(attributes: attributes.copy(), oneOf: oneOf?.copy(), completed: _completed);

  bool get completed => _completed;

  void completeSet() {
    attributes.forEach((name, value) {
      if (oneOf?.contains(name) ?? false) {
        if (attributes.allAreNull(oneOf)) {
          throw Failure('You must also submit either ${oneOf.format((name) => name.formattedString, 'or')}');
        }
        if (!attributes.onlyOneOf(oneOf)) {
          throw Failure('${oneOf.format((name) => name.formattedString)} cannot be submitted together');
        }
        return;
      }
      if (value == null) throw Failure('${name.formattedString} is required');
    });

    attributes.removeWhere((_, value) => value == null);

    _completed = true;
  }

  void removeAttribute(AttributeName attributeName) => attributes.remove(attributeName);
}

extension on List<ActiveSet> {
  List<ActiveSet> copy() => List.generate(length, (index) => this[index].copy());
}

extension AttributesExtension on Map<AttributeName, double> {
  bool allAreNull(List<AttributeName> names) {
    for (final name in names) {
      if (this[name] != null) return false;
    }
    return true;
  }

  bool onlyOneOf(List<AttributeName> names) {
    bool foundOne = false;
    for (final name in names) {
      if (this[name] != null) {
        if (foundOne) return false;
        foundOne = true;
      }
    }
    return foundOne;
  }
}
