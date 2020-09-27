import 'package:flutter/material.dart';
import 'package:track_workouts/data/model/routine/routine.dart';
import 'package:track_workouts/data/model/workouts/workout/workout.dart';
import 'package:track_workouts/data/repositories/workouts_repository.dart';

class NewWorkoutService {
  final WorkoutsRepository _workoutsRepository;

  Routine _selectedRoutine;

  NewWorkoutService(this._workoutsRepository);

  Routine get selectedRoutine => _selectedRoutine?.copy();

  void selectRoutine(Routine routine) {
    _selectedRoutine = routine.copy();
  }

  List<ActiveSet> getActiveSets({@required String exerciseName}) => _selectedRoutine.getActiveSets(exerciseName);

  ActiveSet getActiveSet({@required String exerciseName}) => _selectedRoutine.getActiveSet(exerciseName);

  void addActiveSet({@required String exerciseName}) => _selectedRoutine.addActiveSet(exerciseName);

  void changeActiveSetAttribute({@required String exerciseName, @required AttributeName attributeName, @required double value}) =>
      _selectedRoutine.changeActiveSetAttribute(exerciseName, attributeName, value);

  void completeActiveSet({@required String exerciseName}) => _selectedRoutine.completeActiveSet(exerciseName);

  void dispose() {
    _workoutsRepository.workoutsApiService.dispose();
  }
}
