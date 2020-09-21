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

  Exercise({@required this.name, @required this.attributes});

  static const defaultAttributes = [AttributeName.pre_break, AttributeName.reps, AttributeName.weight];
}
