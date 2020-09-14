import 'package:track_workouts/data/model/workouts/workout/workout.dart';
import 'package:track_workouts/data/repositories/workouts_repository.dart';

class WorkoutsService {
  final WorkoutsRepository _workoutsRepository;

  List<Workout> _workouts;

  WorkoutsService(this._workoutsRepository);

  List<Workout> get workouts => List.generate(
        _workouts.length,
        (i) => _workouts[i].copyWith(),
      );

  Future<void> loadWorkouts({DateTime toDate}) async {
    _workouts = await _workoutsRepository.getWorkouts();
  }

  void dispose() {
    _workoutsRepository.workoutsApiService.dispose();
  }
}
