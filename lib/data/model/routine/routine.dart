import 'package:flutter/material.dart';
import 'package:track_workouts/data/model/workouts/workout/workout.dart';
import 'package:track_workouts/handlers/error/failure.dart';
import 'package:track_workouts/utils/map_utils.dart';
import 'package:track_workouts/utils/list_utils.dart';
import 'package:uuid/uuid.dart';

class Routine {
  final String name;
  final List<String> exerciseIds;
  final String image;

  final Map<String, List<ActiveSet>> _activeExercises;

  Routine({
    @required this.name,
    @required this.exerciseIds,
    @required this.image,
    Map<String, List<ActiveSet>> activeExercises,
  }) : _activeExercises = activeExercises ?? buildActiveExercises(exerciseIds);

  static Map<String, List<ActiveSet>> buildActiveExercises(List<String> exerciseIds) {
    return Map.fromIterable(
      exerciseIds,
      key: (id) => id,
      value: (_) => [],
    );
  }

  Map<String, List<ActiveSet>> get activeExercises => _activeExercises.copy();

  List<Exercise> getExercises(List<Exercise> allExercises) => exerciseIds.map((id) => allExercises.getExerciseFrom(id)).toList();

  bool hasSameExercises(Routine other) {
    if (exerciseIds.length != other.exerciseIds.length) return false;
    for (final otherId in other.exerciseIds) {
      if (!exerciseIds.contains(otherId)) return false;
    }
    return true;
  }

  List<ActiveSet> getActiveSetsById(String id) {
    if (!_activeExercises.containsKey(id)) throw StateError('exercise with id $id does not exist');
    return _activeExercises[id];
  }

  ActiveSet getActiveSetById(String id) {
    final activeSets = getActiveSetsById(id);
    if (!activeSets.onlyOneWhere((activeSet) => !activeSet.completed)) {
      throw StateError('only one active set can be completed at a time');
    }
    return activeSets.firstWhere((activeSet) => !activeSet.completed);
  }

  void addActiveSetWithId(String id, List<Exercise> allExercises) {
    final activeSets = getActiveSetsById(id);

    final exercise = allExercises.firstWhere((exercise) => exercise.id == id);

    final activeSet = ActiveSet(
      attributes: exercise.attributes.toMap(),
      exercise: exercise,
    );
    if (activeSets.isEmpty) {
      activeSet.removeAttribute(AttributeName.pre_break);
    }

    activeSets.add(activeSet);
  }

  void changeActiveSetAttributeWithId(String id, AttributeName attributeName, double value) {
    final activeSet = getActiveSetById(id);

    final attributes = activeSet.attributes;
    if (!attributes.containsKey(attributeName)) throw StateError('attribute name must exist in exercise');

    attributes[attributeName] = value;
  }

  void editActiveSetWithId(String id, int index) {
    final activeSets = getActiveSetsById(id);
    final activeSet = getActiveSetById(id);

    if (activeSet.checked) {
      activeSet.setCompleted(true);
    } else {
      activeSets.removeLast();
    }

    activeSets[index].setCompleted(false);
  }

  Routine copy() => Routine(
        name: name,
        exerciseIds: exerciseIds.copy(),
        image: image,
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
  final String id;
  final String name;
  final List<AttributeName> attributes;
  final int numberOfSets;

  Exercise({@required this.name, @required this.attributes, @required this.numberOfSets, String id})
      : this.id = id ?? Uuid().v1();

  List<AttributeName> get oneOf {
    final result = attributes.where((attribute) => AttributeNameExtension.oneOf.contains(attribute)).toList();
    return result.length <= 1 ? null : result;
  }

  Exercise copy() => Exercise(attributes: attributes.copy(), name: name, numberOfSets: numberOfSets, id: id);

  static const defaultAttributes = [AttributeName.pre_break, AttributeName.reps, AttributeName.weight];
}

extension ExerciseIds on List<String> {
  List<String> copy() => List.from(this);
}

extension Exercises on List<Exercise> {
  Exercise getExerciseFrom(String id) => firstWhere((exercise) => exercise.id == id);

  List<Exercise> copy() => List.generate(length, (index) => this[index].copy());
}

class ActiveSet {
  bool _completed = false;
  bool _checked = false;
  final Map<AttributeName, double> attributes;
  final Exercise exercise;

  ActiveSet({@required this.attributes, @required this.exercise, bool completed, bool checked}) {
    if (completed != null) _completed = completed;
    if (checked != null) _checked = checked;
  }

  ActiveSet copy() => ActiveSet(attributes: attributes.copy(), exercise: exercise, completed: _completed, checked: _checked);

  bool get completed => _completed;

  bool get checked => _checked;

  void setCompleted(bool completed) {
    _completed = completed;
    if (completed) _checked = true;
  }

  void checkOk() {
    final oneOf = exercise.oneOf;
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
