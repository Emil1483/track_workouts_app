import 'package:track_workouts/data/model/workouts/workout/workout.dart';
import 'package:track_workouts/data/repositories/workouts_repository.dart';
import 'package:track_workouts/utils/models/week.dart';

class WorkoutsService {
  final WorkoutsRepository _workoutsRepository;

  List<Workout> _workouts;
  bool _loadedAll = false;

  WorkoutsService(this._workoutsRepository);

  bool get loadedAll => _loadedAll;

  List<Workout> get workouts => _workouts == null ? null : _workouts.copy();

  Future<void> loadInitialWorkouts() async {
    _workouts = await _workoutsRepository.getWorkouts();
  }

  Future<void> expandWorkoutsToInclude(Week week) async {
    if (_workouts == null) _workouts = [];

    while (!_loadedAll && (_workouts.isEmpty || _workouts.last.date.isBefore(week.end))) {
      final toDate = _workouts.isEmpty ? null : _workouts.last.date.subtract(Duration(days: 1));
      final workoutsData = await _workoutsRepository.getWorkoutsData(toDate: toDate);
      final workouts = workoutsData.workouts;
      _workouts.addAll(workouts);

      _loadedAll = workouts.length < workoutsData.options.limit;
    }
  }

  void dispose() {
    _workoutsRepository.workoutsApiService.dispose();
  }
}
