import 'package:flutter/material.dart';
import 'package:track_workouts/data/model/routine/routine.dart';
import 'package:track_workouts/data/model/workouts/workout/workout.dart';
import 'package:track_workouts/routes/base/base_model.dart';
import 'package:track_workouts/utils/map_utils.dart';

class NewExerciseDetailsViewmodel extends BaseModel {
  final List<ActiveSet> _activeSets;

  NewExerciseDetailsViewmodel(Exercise exercise)
      : _activeSets = [ActiveSet(attributes: Map.fromIterable(exercise.attributes, value: (_) => null))];

  List<ActiveSet> get activeSets => _activeSets.copy();
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
}

extension on List<ActiveSet> {
  List<ActiveSet> copy() => List.generate(length, (index) => this[index].copy());
}
