import 'package:track_workouts/data/model/workouts/workout/workout.dart';
import 'package:track_workouts/data/repositories/workouts_repository.dart';
import 'package:track_workouts/handlers/error/failure.dart';

class WorkoutsService {
  final WorkoutsRepository _workoutsRepository;

  List<Workout> _workouts;
  bool _loadedAll = false;
  bool _isLoading = false;

  WorkoutsService(this._workoutsRepository);

  bool get loadedAll => _loadedAll;

  List<Workout> get workouts => List.generate(
        _workouts.length,
        (i) => _workouts[i].copyWith(),
      );

  Future<void> loadInitialWorkouts() async {
    _workouts = await _workoutsRepository.getWorkouts();
    _loadedAll = false;
  }

  Future<void> loadMoreWorkouts() async {
    if (_isLoading || _loadedAll) return;

    if (_workouts == null || _workouts.isEmpty) throw Failure('workouts must not be empty');

    _isLoading = true;

    final toDate = _workouts.last.date.subtract(Duration(days: 1));

    final workoutsData = await _workoutsRepository.getWorkoutsData(toDate: toDate);
    final moreWorkouts = workoutsData.workouts;

    if (moreWorkouts.length < workoutsData.options.limit) {
      _loadedAll = true;
    }

    _workouts.addAll(moreWorkouts);

    _isLoading = false;
  }

  void dispose() {
    _workoutsRepository.workoutsApiService.dispose();
  }
}
