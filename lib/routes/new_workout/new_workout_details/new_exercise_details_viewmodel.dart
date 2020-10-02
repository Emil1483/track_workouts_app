import 'package:flutter/material.dart';
import 'package:track_workouts/data/model/routine/routine.dart';
import 'package:track_workouts/data/model/workouts/workout/workout.dart';
import 'package:track_workouts/data/services/new_workout_service.dart';
import 'package:track_workouts/handlers/error/error_handler.dart';
import 'package:track_workouts/handlers/error/failure.dart';
import 'package:track_workouts/routes/base/base_model.dart';
import 'package:track_workouts/ui_elements/panel.dart';
import 'package:track_workouts/ui_elements/time_picker/time_picker_dialog.dart';
import 'package:track_workouts/utils/validation_utils.dart';

class NewExerciseDetailsViewmodel extends BaseModel {
  final GlobalKey<FormState> formKey = GlobalKey();
  final PanelController panelController = PanelController();

  final NewWorkoutService newWorkoutService;
  final Exercise exercise;
  final void Function(String) onError;

  final Map<AttributeName, TextEditingController> _controllers;

  NewExerciseDetailsViewmodel({@required this.newWorkoutService, @required this.exercise, @required this.onError})
      : _controllers = _buildControllers(newWorkoutService, exercise);

  static Map<AttributeName, TextEditingController> _buildControllers(NewWorkoutService newWorkoutService, Exercise exercise) {
    final activeSet = newWorkoutService.tryGetActiveSet(exerciseName: exercise.name);
    return Map.fromIterable(
      exercise.attributes.where((name) => name != AttributeName.pre_break),
      value: (name) {
        final value = activeSet == null ? null : activeSet.attributes[name];
        return TextEditingController(text: value?.toString());
      },
    );
  }

  List<ActiveSet> get activeSets => newWorkoutService.getActiveSets(exerciseName: exercise.name);

  TextEditingController getControllerFrom(AttributeName name) => _controllers[name];

  ActiveSet get _activeSet => newWorkoutService.getActiveSet(exerciseName: exercise.name);

  void initializeActiveSets() {
    final activeSets = newWorkoutService.getActiveSets(exerciseName: exercise.name);
    if (activeSets.isEmpty) newWorkoutService.addActiveSet(exerciseName: exercise.name);
  }

  String validateAttribute(AttributeName name, String value) {
    if (value.isNotEmpty) {
      final numberValidation = Validation.mustBeNumber(value);
      if (numberValidation != null) return Validation.mustBeNumber(value);
    }

    if (!(_activeSet.oneOf?.contains(name) ?? false)) return Validation.mustBeNumber(value);

    return null;
  }

  Future<void> pickPreBreak(BuildContext context) async {
    final attributes = _activeSet.attributes;
    if (!attributes.containsKey(AttributeName.pre_break)) {
      throw Failure('do not show time picker if the attribute does not exist');
    }

    final pickedTime = await TimePickerDialog.showTimePicker(context);
    if (pickedTime == null) return;

    newWorkoutService.changeActiveSetAttribute(
      exerciseName: exercise.name,
      attributeName: AttributeName.pre_break,
      value: pickedTime.inSeconds.toDouble(),
    );
    notifyListeners();
  }

  bool modifyIfPossible(double value, AttributeName attributeName) {
    final attributes = newWorkoutService.getActiveSet(exerciseName: exercise.name).attributes;
    if (!attributes.containsKey(attributeName)) return false;
    if (attributes[attributeName] != null) {
      if (attributes[attributeName] > 0) return false;
    }

    newWorkoutService.changeActiveSetAttribute(
      exerciseName: exercise.name,
      attributeName: attributeName,
      value: value,
    );

    _controllers[attributeName]?.text = value.toString();
    notifyListeners();

    return true;
  }

  Future<void> saveSets() async {
    if (!formKey.currentState.validate()) return;

    _controllers.forEach((attributeName, controller) {
      final value = double.tryParse(controller.text);
      newWorkoutService.changeActiveSetAttribute(
        exerciseName: exercise.name,
        attributeName: attributeName,
        value: value,
      );
    });

    await ErrorHandler.handleErrors(
      run: () async => newWorkoutService.completeActiveSet(exerciseName: exercise.name),
      onFailure: (failure) => onError(failure.message),
      onSuccess: (_) {
        newWorkoutService.addActiveSet(exerciseName: exercise.name);
        notifyListeners();
      },
    );
  }

  void editSet(int index) {
    newWorkoutService.editActiveSet(exerciseName: exercise.name, index: index);
    final activeSet = newWorkoutService.getActiveSet(exerciseName: exercise.name);
    _controllers.forEach((attributeName, controller) {
      final value = activeSet.attributes[attributeName];
      if (value != null) {
        controller.text = activeSet.attributes[attributeName].toString();
      }
    });
    notifyListeners();
  }
}
