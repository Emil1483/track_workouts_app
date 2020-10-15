import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:track_workouts/data/model/routine/routine.dart';
import 'package:track_workouts/data/model/workouts/workout/workout.dart';
import 'package:track_workouts/data/services/new_workout_service.dart';
import 'package:track_workouts/data/services/time_panel_service.dart';
import 'package:track_workouts/handlers/error/error_handler.dart';
import 'package:track_workouts/handlers/error/failure.dart';
import 'package:track_workouts/routes/base/base_model.dart';
import 'package:track_workouts/ui_elements/time_picker/time_picker_dialog.dart';
import 'package:track_workouts/utils/validation_utils.dart';
import 'package:track_workouts/utils/num_utils.dart';

class NewExerciseDetailsViewmodel extends BaseModel {
  final GlobalKey<FormState> formKey = GlobalKey();

  final NewWorkoutService newWorkoutService;
  final TimePanelService timePanelService;
  final Exercise exercise;
  final void Function(String) onError;

  Map<AttributeName, TextEditingController> _controllers;

  NewExerciseDetailsViewmodel(BuildContext context, {@required this.exercise, @required this.onError})
      : newWorkoutService = Provider.of<NewWorkoutService>(context),
        timePanelService = Provider.of<TimePanelService>(context) {
    timePanelService.addListener(_updatePreBreak);
  }

  List<ActiveSet> get activeSets => newWorkoutService.getActiveSets(exerciseId: exercise.id).copy();

  TextEditingController getControllerFrom(AttributeName name) => _controllers == null ? null : _controllers[name];

  ActiveSet get _activeSet => newWorkoutService.getActiveSet(exerciseId: exercise.id);

  void _updatePreBreak() {
    if (modifyIfPossible(timePanelService.countdownTime.inSeconds.toDouble(), AttributeName.pre_break)) {
      timePanelService.panelController.close();
    }
  }

  Future<void> buildTextControllers() async {
    final activeSet = newWorkoutService.tryGetActiveSet(exerciseId: exercise.id);
    final prefs = await SharedPreferences.getInstance();

    _controllers = Map.fromIterable(
      exercise.attributes.where((name) => name != AttributeName.pre_break),
      value: (name) {
        final attributeName = name as AttributeName;
        final attributes = activeSet?.attributes;
        final attribute = attributes == null ? null : attributes[attributeName];
        final value = attribute ?? prefs.getDouble(attributeName.string);
        return TextEditingController(text: value?.withMaxTwoDecimals);
      },
    );

    notifyListeners();
  }

  void initializeActiveSets() {
    final activeSets = newWorkoutService.getActiveSets(exerciseId: exercise.id);
    if (activeSets.isEmpty) newWorkoutService.addActiveSet(exerciseId: exercise.id);
  }

  String validateAttribute(AttributeName name, String value) {
    if (value.isNotEmpty) {
      final numberValidation = Validation.mustBeNumber(value);
      if (numberValidation != null) return Validation.mustBeNumber(value);
    }

    if (!(exercise.optionalOneOf?.contains(name) ?? false)) return Validation.mustBeNumber(value);

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
      exerciseId: exercise.id,
      attributeName: AttributeName.pre_break,
      value: pickedTime.inSeconds.toDouble(),
    );
    notifyListeners();
  }

  bool modifyIfPossible(double value, AttributeName attributeName) {
    final attributes = newWorkoutService.getActiveSet(exerciseId: exercise.id).attributes;
    if (!attributes.containsKey(attributeName)) return false;
    if (attributes[attributeName] != null) {
      if (attributes[attributeName] > 0) return false;
    }

    newWorkoutService.changeActiveSetAttribute(
      exerciseId: exercise.id,
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
        exerciseId: exercise.id,
        attributeName: attributeName,
        value: value,
      );
    });

    setLoading(true);

    await ErrorHandler.handleErrors(
      run: () async => newWorkoutService.completeActiveSet(exerciseId: exercise.id),
      onFailure: (failure) => onError(failure.message),
      onSuccess: (_) async {
        final prefs = await SharedPreferences.getInstance();

        _controllers.forEach((name, controller) async {
          if (!AttributeNameExtension.repeatingAttributes.contains(name)) return;

          await prefs.setDouble(name.string, double.parse(controller.text));
        });

        newWorkoutService.addActiveSet(exerciseId: exercise.id);
      },
    );

    setLoading(false);
  }

  void editSet(int index) {
    newWorkoutService.editActiveSet(exerciseId: exercise.id, index: index);
    final activeSet = newWorkoutService.getActiveSet(exerciseId: exercise.id);
    _controllers.forEach((attributeName, controller) {
      final value = activeSet.attributes[attributeName];
      if (value != null) {
        controller.text = value.withMaxTwoDecimals;
      } else {
        controller.clear();
      }
    });
    notifyListeners();
  }

  void deleteSet(int index) {
    final activeSet = newWorkoutService.deleteActiveSet(exerciseId: exercise.id, index: index);
    notifyListeners();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ErrorHandler.handleErrors(
        run: () => newWorkoutService.postWorkout(),
        onFailure: (failure) {
          onError(failure.message);
          newWorkoutService.insertActiveSet(exerciseId: exercise.id, index: index, activeSet: activeSet);
          notifyListeners();
        },
        onSuccess: (_) {},
      );
    });
  }

  @override
  void dispose() {
    timePanelService.removeListener(_updatePreBreak);
    super.dispose();
  }
}
