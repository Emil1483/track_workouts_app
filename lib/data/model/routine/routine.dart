import 'package:flutter/material.dart';
import 'package:track_workouts/data/model/workouts/workout/workout.dart';
import 'package:track_workouts/handlers/error/failure.dart';
import 'package:track_workouts/utils/map_utils.dart';
import 'package:track_workouts/utils/list_utils.dart';

class Routine {
  final String name;
  final List<Exercise> exercises;

  final Map<String, List<ActiveSet>> _activeExercises;

  Routine({@required this.name, @required this.exercises, Map<String, List<ActiveSet>> activeExercises})
      : _activeExercises = activeExercises ??
            Map.fromIterable(
              exercises,
              key: (exercise) => (exercise as Exercise).name,
              value: (_) => [],
            );

  Map<String, List<ActiveSet>> get activeExercises => _activeExercises.copy();

  List<ActiveSet> getActiveSets(String exerciseName) {
    if (!_activeExercises.containsKey(exerciseName)) throw StateError('exercise name does not exist');
    return _activeExercises[exerciseName];
  }

  ActiveSet getActiveSet(String exerciseName) {
    final activeSets = getActiveSets(exerciseName);
    if (!activeSets.onlyOneWhere((activeSet) => !activeSet.completed)) {
      throw StateError('only one active set cannot be completed at a time');
    }
    return activeSets.firstWhere((activeSet) => !activeSet.completed);
  }

  void addActiveSet(String exerciseName) {
    final activeSets = getActiveSets(exerciseName);

    final exercise = exercises.firstWhere((exercise) => exercise.name == exerciseName);

    final activeSet = ActiveSet(
      attributes: Map.fromIterable(exercise.attributes, value: (_) => null),
      oneOf: exercise.oneOf,
    );
    if (activeSets.isEmpty) {
      activeSet.removeAttribute(AttributeName.pre_break);
    }

    activeSets.add(activeSet);
  }

  void changeActiveSetAttribute(String exerciseName, AttributeName attributeName, double value) {
    final activeSet = getActiveSet(exerciseName);

    final attributes = activeSet.attributes;
    if (!attributes.containsKey(attributeName)) throw StateError('attribute name must exist in exercise');

    attributes[attributeName] = value;
  }

  void editActiveSet(String exerciseName, int index) {
    final activeSets = getActiveSets(exerciseName);
    final activeSet = getActiveSet(exerciseName);

    if (activeSet.checked) {
      activeSet.setCompleted(true);
    } else {
      activeSets.removeLast();
    }

    activeSets[index].setCompleted(false);
  }

  Routine copy() => Routine(
        name: name,
        exercises: exercises,
        activeExercises: _activeExercises.copy(),
      );
}

extension ActiveExercises on Map<String, List<ActiveSet>> {
  Map<String, List<ActiveSet>> copy() => Map.fromIterable(
        entries,
        key: (entry) => (entry as MapEntry<String, List<ActiveSet>>).key,
        value: (entry) => (entry as MapEntry<String, List<ActiveSet>>).value.copy(),
      );
}

extension Routines on List<Routine> {
  List<Routine> copy() => List.generate(length, (i) => this[i].copy());
}

class Exercise {
  final String name;
  final List<AttributeName> attributes;
  final int numberOfSets;
  final List<AttributeName> oneOf;

  Exercise({@required this.name, @required this.attributes, @required this.numberOfSets, this.oneOf}) {
    oneOf?.forEach((name) {
      assert(attributes.contains(name));
    });
  }
  Exercise copy() => Exercise(attributes: attributes.copy(), name: name, numberOfSets: numberOfSets, oneOf: oneOf?.copy());

  static const defaultAttributes = [AttributeName.pre_break, AttributeName.reps, AttributeName.weight];
}

class ActiveSet {
  bool _completed = false;
  bool _checked = false;
  final Map<AttributeName, double> attributes;
  final List<AttributeName> oneOf;

  ActiveSet({@required this.attributes, @required this.oneOf, bool completed, bool checked}) {
    if (completed != null) _completed = completed;
    if (checked != null) _checked = checked;
  }

  ActiveSet copy() => ActiveSet(attributes: attributes.copy(), oneOf: oneOf?.copy(), completed: _completed, checked: _checked);

  bool get completed => _completed;

  bool get checked => _checked;

  void setCompleted(bool completed) {
    _completed = completed;
    if (completed) _checked = true;
  }

  void checkOk() {
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
  }

  void removeAttribute(AttributeName attributeName) => attributes.remove(attributeName);
}

extension ActiveSets on List<ActiveSet> {
  List<ActiveSet> copy() => List.generate(length, (index) => this[index].copy());
}

extension AttributesExtension on Map<AttributeName, double> {
  bool allAreNull(List<AttributeName> names) {
    for (final name in names) {
      if (this[name] != null) return false;
    }
    return true;
  }

  bool onlyOneOf(List<AttributeName> names) => names.onlyOneWhere((name) => this[name] != null);
}
