import 'package:track_workouts/data/model/routine/routine.dart';
import 'package:track_workouts/data/repositories/workouts_repository.dart';

class NewWorkoutService {
  final WorkoutsRepository _workoutsRepository;

  Routine _selectedRoutine;

  NewWorkoutService(this._workoutsRepository);

  Routine get selectedRoutine => _selectedRoutine?.copy();

  void selectRoutine(Routine routine) {
    _selectedRoutine = routine.copy();
  }

  void dispose() {
    _workoutsRepository.workoutsApiService.dispose();
  }
}
