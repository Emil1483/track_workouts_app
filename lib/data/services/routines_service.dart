import 'package:track_workouts/data/model/routine/routine.dart';

class RoutinesService {
  final List<Exercise> _exercises = [];

  List<Exercise> get exercises => _exercises.copy();

  void addExercise(Exercise exercise) => _exercises.insert(0, exercise);

  //TODO: make sure each exercise has a unique  name
  void deleteExerciseWithName(String name) {
    _exercises.removeWhere((exercise) => exercise.name == name);
  }

  void dispose() {
    //TODO: delete if not in use
  }
}

extension on List<Exercise> {
  List<Exercise> copy() => List.generate(length, (index) => this[index].copy());
}
