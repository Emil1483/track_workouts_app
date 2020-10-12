import 'package:flutter/material.dart';
import 'package:track_workouts/data/model/routine/routine.dart';
import 'package:track_workouts/data/model/workouts/workout/workout.dart';
import 'package:track_workouts/data/repositories/workouts_repository.dart';
import 'package:track_workouts/data/services/routines_service.dart';
import 'package:track_workouts/data/services/workouts_service.dart';
import 'package:track_workouts/utils/date_time_utils.dart';

class NewWorkoutService {
  final WorkoutsRepository _workoutsRepository;
  final WorkoutsService _workoutsService;
  final RoutinesService _routinesService;

  Routine _selectedRoutine;
  Workout _workout;

  NewWorkoutService(this._workoutsRepository, this._workoutsService, this._routinesService) {
    _workoutsService.addListener((id) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _workoutsService.disposeListener(id));
      final workout = _workoutsService.workouts.first;
      if (workout.date.isAtSameMomentAs(DateTimeUtils.today)) {
        _workout = workout;
      }
    });
  }

  Routine get selectedRoutine => _selectedRoutine?.copy();

  void selectRoutine(Routine routine) {
    final Map<String, List<ActiveSet>> activeExercises = Routine.buildActiveExercises(routine.exerciseIds);
    if (_workout != null) {
      _workout.exercises.forEach((exerciseName, sets) {
        final exercise = _routinesService.getExerciseByName(exerciseName);
        activeExercises[exerciseName] = [
          ...sets.map(
            (mySet) => ActiveSet(
              checked: true,
              completed: true,
              attributes: mySet,
              exercise: exercise,
            ),
          ),
          ActiveSet(
            attributes: exercise.attributes.toMap(),
            exercise: exercise,
          ),
        ];
      });
    }

    _selectedRoutine = Routine(
      image: routine.image,
      exerciseIds: routine.exerciseIds,
      name: routine.name,
      activeExercises: activeExercises,
    );
  }

  List<ActiveSet> getActiveSets({@required String exerciseId}) => _selectedRoutine.getActiveSetsById(exerciseId);

  ActiveSet getActiveSet({@required String exerciseId}) => _selectedRoutine.getActiveSetById(exerciseId);

  ActiveSet tryGetActiveSet({@required String exerciseId}) {
    try {
      return _selectedRoutine.getActiveSetById(exerciseId);
    } on StateError catch (_) {
      return null;
    }
  }

  void addActiveSet({@required String exerciseId}) => _selectedRoutine.addActiveSetWithId(exerciseId, _routinesService.exercises);

  void changeActiveSetAttribute({@required String exerciseId, @required AttributeName attributeName, @required double value}) =>
      _selectedRoutine.changeActiveSetAttributeWithId(exerciseId, attributeName, value);

  Future<void> completeActiveSet({@required String exerciseId}) async {
    final activeSet = _selectedRoutine.getActiveSetById(exerciseId);
    activeSet.checkOk();

    final workout = await _workoutsRepository.postWorkout(_selectedRoutine.activeExercises);

    activeSet.setCompleted(true);
    _workoutsService.updateWorkout(workout);
  }

  void editActiveSet({@required String exerciseId, @required int index}) => _selectedRoutine.editActiveSetWithId(exerciseId, index);

  void dispose() {
    _workoutsRepository.workoutsApiService.dispose();
  }
}
