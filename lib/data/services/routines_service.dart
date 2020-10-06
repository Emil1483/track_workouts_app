import 'package:track_workouts/data/model/routine/routine.dart';
import 'package:track_workouts/handlers/error/failure.dart';

class RoutinesService {
  final List<Exercise> _exercises = [];

  List<Exercise> get exercises => _exercises.copy();

  Future<void> addExercise(Exercise newExercise) async {
    _exercises.forEach((existingExercise) {
      if (existingExercise.name.toLowerCase() == newExercise.name.toLowerCase()) {
        throw Failure('An exercise with that name already exists');
      }
    });
    _exercises.insert(0, newExercise);
  }
  
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
