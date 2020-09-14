import 'package:track_workouts/data/api/workouts_api_repository.dart';
import 'package:track_workouts/data/model/workouts/workout/workout.dart';
import 'package:track_workouts/data/model/workouts/workouts_data/workouts_data.dart';

class WorkoutsService {
  final WorkoutsApiRepository _workoutsApiRepository;

  final List<Workout> _workouts = [];

  WorkoutsService(this._workoutsApiRepository);

  List<Workout> get workouts => List.generate(
        _workouts.length,
        (i) => _workouts[i].copyWith(),
      );

  Future<void> loadWorkouts({DateTime toDate}) async {
    final to = toDate ?? DateTime.now();
    final response = await _workoutsApiRepository.getWorkoutsData(to.toIso8601String());
    final data = WorkoutsDataSerializer.fromMap(response.body);
    _workouts.addAll(data.workouts);
  }

  void dispose() {
    _workoutsApiRepository.client.dispose();
  }
}
