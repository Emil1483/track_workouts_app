import 'package:flutter/material.dart';
import 'package:track_workouts/routes/root/root_viewmodel.dart';

class ColorUtils {
  static Color getColorFrom(FormattedWorkout workout) {
    final List<double> hues = [];
    workout.exercises.forEach((exercise) {
      final hash = exercise.name.hashCode.toString();
      final subHash = hash.substring(hash.length - 3);
      final hashNumber = int.parse(subHash);
      hues.add(hashNumber * 360 / 1000);
    });
    final hue = hues.reduce((a, b) => a + b) / hues.length;

    final setLengths = workout.exercises.map((exercise) => exercise.sets.length);
    final totalSets = setLengths.reduce((a, b) => a + b);
    final saturation = totalSets / 28;

    return HSVColor.fromAHSV(1.0, hue, saturation, 1.0).toColor();
  }
}
