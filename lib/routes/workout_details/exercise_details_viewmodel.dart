import 'package:flutter/material.dart';
import 'package:track_workouts/data/model/workouts/workout/workout.dart';
import 'package:track_workouts/routes/base/base_model.dart';
import 'package:track_workouts/routes/root/root_viewmodel.dart';
import 'package:track_workouts/utils/map_utils.dart';

class ExerciseDetailsViewmodel extends BaseModel {
  final FormattedExercise exercise;

  List<Map<AttributeName, double>> _formattedSets;
  Map<AttributeName, double> _repeatedAttributes;

  ExerciseDetailsViewmodel({@required this.exercise}) {
    _formattedSets = exercise.sets.copy();
    if (exercise.sets.length <= 1) {
      _repeatedAttributes = {};
      return;
    }

    _repeatedAttributes = exercise.sets.first.copy();
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

  List<Map<AttributeName, double>> get formattedSets => _formattedSets.copy();

  Map<AttributeName, double> get repeatedAttributes => _repeatedAttributes.copy();

  void forEachFormattedSet(void Function(Map<AttributeName, double> formattedSet, int index) function) {
    for (int i = 0; i < _formattedSets.length; i++) {
      function(_formattedSets[i], i);
    }
  }
}
