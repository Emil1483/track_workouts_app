import 'package:flutter/material.dart';
import 'package:track_workouts/data/model/routine/routine.dart';
import 'package:track_workouts/data/model/workouts/workout/workout.dart';
import 'package:track_workouts/data/repositories/workouts_repository.dart';
import 'package:track_workouts/data/services/workouts_service.dart';
import 'package:track_workouts/routes/new_workout/choose_routine/choose_routine_viewmodel.dart';
import 'package:track_workouts/utils/date_time_utils.dart';

class NewWorkoutService {
  final WorkoutsRepository _workoutsRepository;
  final WorkoutsService _workoutsService;

  Routine _selectedRoutine;
  Workout _workout;

  NewWorkoutService(this._workoutsRepository, this._workoutsService) {
    _workoutsService.addListener((id) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _workoutsService.disposeListener(id));
      final workout = _workoutsService.workouts.first;
      if (workout.date.isAtSameMomentAs(DateTimeUtils.today)) {
        _workout = workout;
      }
    });
  }

  Routine get selectedRoutine => _selectedRoutine?.copy();

  Exercise findExercise(String exerciseName) {
    for (final routine in ChooseRoutineViewmodel.routines) {
      for (final exercise in routine.exercises) {
        if (exercise.name == exerciseName) return exercise;
      }
    }
    throw StateError('found no exercise with name \'$exerciseName\'');
  }

  void selectRoutine(Routine routine) {
    final Map<String, List<ActiveSet>> activeExercises = Routine.buildActiveExercises(routine.exercises);
    if (_workout != null) {
      _workout.exercises.forEach((exerciseName, sets) {
        final exercise = findExercise(exerciseName);
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
      exercises: routine.exercises,
      name: routine.name,
      activeExercises: activeExercises,
    );
  }

  List<ActiveSet> getActiveSets({@required String exerciseName}) => _selectedRoutine.getActiveSets(exerciseName);

  ActiveSet getActiveSet({@required String exerciseName}) => _selectedRoutine.getActiveSet(exerciseName);

  ActiveSet tryGetActiveSet({@required String exerciseName}) {
    try {
      return _selectedRoutine.getActiveSet(exerciseName);
    } on StateError catch (_) {
      return null;
    }
  }

  void addActiveSet({@required String exerciseName}) => _selectedRoutine.addActiveSet(exerciseName);

  void changeActiveSetAttribute({@required String exerciseName, @required AttributeName attributeName, @required double value}) =>
      _selectedRoutine.changeActiveSetAttribute(exerciseName, attributeName, value);

  Future<void> completeActiveSet({@required String exerciseName}) async {
    final activeSet = _selectedRoutine.getActiveSet(exerciseName);
    activeSet.checkOk();

    final workout = await _workoutsRepository.postWorkout(_selectedRoutine.activeExercises);

    activeSet.setCompleted(true);
    _workoutsService.updateWorkout(workout);
  }

  void editActiveSet({@required String exerciseName, @required int index}) => _selectedRoutine.editActiveSet(exerciseName, index);

  void dispose() {
    _workoutsRepository.workoutsApiService.dispose();
  }
}
