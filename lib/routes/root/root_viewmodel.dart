import 'package:track_workouts/routes/base/base_model.dart';

class RootViewmodel extends BaseModel {
  final List<Workout> _workouts = [];

  List<Workout> get workouts => List.generate(_workouts.length, (index) => _workouts[index].copy());

  Future<void> getWorkouts() async {
    setLoading(true);
    await Future.delayed(Duration(seconds: 1));
    setLoading(false);
  }
}

class Workout {
  final DateTime date;
  final List<Exercise> exercises;

  Workout(this.date, this.exercises);

  Workout copy() => Workout(date, exercises);
}

class Exercise {
  final String name;
  final List<Map<String, double>> sets;

  Exercise(this.name, this.sets);
}
