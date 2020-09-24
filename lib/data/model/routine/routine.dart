import 'package:flutter/material.dart';
import 'package:track_workouts/data/model/workouts/workout/workout.dart';

class Routine {
  final String name;
  final List<Exercise> exercises;

  Routine({@required this.name, @required this.exercises});

  Routine copy() => Routine(name: name, exercises: exercises);
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
