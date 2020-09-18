import 'package:flutter/material.dart';
import 'package:track_workouts/data/model/workouts/workout/workout.dart';
import 'package:track_workouts/routes/base/base_model.dart';
import 'package:track_workouts/routes/root/root_viewmodel.dart';
import 'package:track_workouts/utils/string_utils.dart';

class ExerciseDetailsViewmodel extends BaseModel {
  final FormattedExercise exercise;

  List<Map<AttributeName, double>> _formattedSets;
  Map<AttributeName, double> _repeatedAttributes;

  ExerciseDetailsViewmodel({@required this.exercise}) {
    _formattedSets = List.generate(exercise.sets.length, (index) => Map.from(exercise.sets[index]));
    if (exercise.sets.length <= 1) {
      _repeatedAttributes = {};
      return;
    }

    _repeatedAttributes = Map<AttributeName, double>.from(exercise.sets.first);
    for (int i = 1; i < exercise.sets.length; i++) {
      final currentSet = exercise.sets[i];
      currentSet.forEach((name, value) {
        if (_repeatedAttributes[name] != value) _repeatedAttributes.remove(name);
      });
    }

    _formattedSets.forEach(
      (mySet) => mySet.removeWhere(
        (name, _) => _repeatedAttributes.containsKey(name),
      ),
    );
  }

  String get exerciseName => exercise.name.formatFromCamelcase;

  List<Map<AttributeName, double>> get formattedSets =>
      List.generate(_formattedSets.length, (index) => Map.from(_formattedSets[index]));

  Map<AttributeName, double> get repeatedAttributes => Map.from(_repeatedAttributes);

  void forEachFormattedSet(void Function(Map<AttributeName, double> formattedSet, int index) function) {
    for (int i = 0; i < _formattedSets.length; i++) {
      function(_formattedSets[i], i);
    }
  }
}
