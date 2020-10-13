import 'package:flutter/material.dart';
import 'package:track_workouts/data/model/workouts/workout/workout.dart';
import 'package:track_workouts/handlers/error/failure.dart';
import 'package:track_workouts/utils/map_utils.dart';
import 'package:track_workouts/utils/list_utils.dart';
import 'package:uuid/uuid.dart';

class Routine {
  final String id;
  final String name;
  final List<String> exerciseIds;
  final String image;

  final Map<String, List<ActiveSet>> _activeExercises;

  Routine({
    @required String id,
    @required this.name,
    @required this.exerciseIds,
    @required this.image,
    Map<String, List<ActiveSet>> activeExercises,
  })  : _activeExercises = activeExercises ?? buildActiveExercises(exerciseIds),
        id = id ?? Uuid().v1();

  static Map<String, List<ActiveSet>> buildActiveExercises(List<String> exerciseIds) {
    return Map.fromIterable(
      exerciseIds,
      key: (id) => id,
      value: (_) => [],
    );
  }

  Map<String, List<ActiveSet>> get activeExercises => _activeExercises.copy();

  Map<String, List<ActiveSet>> activeExercisesWithNames(List<Exercise> allExercises) {
    return _activeExercises.map((id, sets) => MapEntry(allExercises.getExerciseFrom(id).name, sets));
  }

  void addExerciseToActiveExercises(Exercise exercise) => _activeExercises[exercise.id] = [];

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

  void insertActiveSetWithId(String id, int index, ActiveSet activeSet) {
    final activeSets = getActiveSetsById(id);
    activeSets.insert(index, activeSet);
  }

  Routine copyWith({String name, List<String> exerciseIds, Map<String, List<ActiveSet>> activeExercises, String id}) => Routine(
        id: id ?? this.id,
        name: name ?? this.name,
        exerciseIds: exerciseIds ?? this.exerciseIds.copy(),
        image: image ?? this.image,
        activeExercises: activeExercises ?? _activeExercises.copy(),
      );
}

extension ActiveExercises on Map<String, List<ActiveSet>> {
  Map<String, List<ActiveSet>> copy() => Map.fromIterable(
        entries,
        key: (entry) => (entry as MapEntry<String, List<ActiveSet>>).key,
        value: (entry) => (entry as MapEntry<String, List<ActiveSet>>).value.copy(),
      );

  Map<String, List<ActiveSet>> merge(Map<String, List<ActiveSet>> other) {
    final result = this.copy();

    other.forEach((key, value) {
      if (result.containsKey(key)) return;
      result[key] = value;
    });

    forEach((key, value) {
      if (other.containsKey(key)) return;
      if (result[key].whereChecked.isEmpty) result.remove(key);
    });

    return result;
  }
}

extension Routines on List<Routine> {
  List<Routine> copy() => List.generate(length, (i) => this[i].copyWith());
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

  List<ActiveSet> get whereChecked => this.where((activeSet) => activeSet._checked).toList();
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
