import 'package:flutter/material.dart';
import 'package:track_workouts/data/model/routine/routine.dart';
import 'package:track_workouts/data/model/suggested_weight/suggested_weight.dart';
import 'package:track_workouts/data/model/workouts/workout/workout.dart';
import 'package:track_workouts/data/repositories/workouts_repository.dart';
import 'package:track_workouts/data/services/routines_service.dart';
import 'package:track_workouts/data/services/workouts_service.dart';
import 'package:track_workouts/utils/date_time_utils.dart';
import 'package:track_workouts/utils/models/week.dart';

class NewWorkoutService {
  final WorkoutsRepository _workoutsRepository;
  final WorkoutsService _workoutsService;
  final RoutinesService _routinesService;

  final List<String> _removedIds = [];
  Routine _selectedRoutine;
  Workout _workout;

  NewWorkoutService(this._workoutsRepository, this._workoutsService, this._routinesService) {
    _workoutsService.addListener((id) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _workoutsService.disposeListener(id));
      final workouts = _workoutsService.workouts;
      if (workouts.isEmpty) return;

      final workout = workouts.first;
      if (workout.date.isAtSameMomentAs(DateTimeUtils.today)) {
        _workout = workout;
      }
    });
  }

  Routine get selectedRoutine => _selectedRoutine?.copyWith();

  List<Exercise> get notActiveExercises {
    final activeExerciseIds = _selectedRoutine.activeExercises.keys;
    return _routinesService.exercises.where((exercise) => !activeExerciseIds.contains(exercise.id)).toList();
  }

  SuggestedWeight getSuggestedWeightFor({@required String exerciseName}) {
    final currentWeek = Week(DateTime.now());
    final currentWeekWorkouts = _workoutsService.getWorkoutsDuring(currentWeek).reversed;

    final previousWeek = Week(DateTime.now().subtract(Duration(days: 7)));
    final previousWeekWorkouts = _workoutsService.getWorkoutsDuring(previousWeek).reversed;

    int currentExerciseIndex = 0;
    currentWeekWorkouts.forEach((workout) {
      if (workout.date.isAtSameMomentAs(DateTime.now().flooredToDay)) return;

      if (!workout.exercises.containsKey(exerciseName)) return;

      currentExerciseIndex++;
    });

    int previousExerciseIndex = 0;
    for (final workout in previousWeekWorkouts) {
      if (workout.exercises.containsKey(exerciseName)) {
        if (previousExerciseIndex >= currentExerciseIndex) {
          return SuggestedWeight(workout.exercises[exerciseName].maxWeight);
        }
        previousExerciseIndex++;
      }
    }

    int index = 0;
    for (final workout in currentWeekWorkouts) {
      if (!workout.exercises.containsKey(exerciseName)) continue;

      if (index >= currentExerciseIndex - 1) {
        return SuggestedWeight(workout.exercises[exerciseName].maxWeight, isTooMuch: true);
      }

      index++;
    }

    return null;
  }

  void addExerciseToActiveExercises(Exercise exercise) {
    _selectedRoutine.addExerciseToActiveExercises(exercise);
  }

  void updateCurrentRoutine() {
    final routine = _routinesService.getRoutineBy(_selectedRoutine.id);

    final updatedExercises = Routine.buildActiveExercises(routine.exerciseIds);

    _selectedRoutine = routine.copyWith(
      activeExercises: _selectedRoutine.activeExercises.merge(updatedExercises)
        ..removeWhere((id, sets) => _removedIds.contains(id)),
    );
  }

  void selectRoutine(String id) {
    _removedIds.clear();

    final routine = _routinesService.getRoutineBy(id);

    final activeExercises = Routine.buildActiveExercises(routine.exerciseIds);
    if (_workout != null) {
      _workout.exercises.forEach((exerciseName, sets) {
        final exercise = _routinesService.tryGetExerciseByName(exerciseName);
        if (exercise == null) return;

        activeExercises[exercise.id] = [
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

    _selectedRoutine = routine.copyWith(activeExercises: activeExercises);
  }

  void reorderExercises(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex--;

    final exercises = _selectedRoutine.activeExercises.entries.toList();

    final exercise = exercises.removeAt(oldIndex);
    exercises.insert(newIndex, exercise);

    _selectedRoutine = _selectedRoutine.copyWith(
      activeExercises: Map.fromIterable(
        exercises,
        key: (exercise) => (exercise as MapEntry<String, List<ActiveSet>>).key,
        value: (exercise) => (exercise as MapEntry<String, List<ActiveSet>>).value,
      ),
    );
  }

  void removeExercise(String id) {
    final exercises = _selectedRoutine.activeExercises;

    final result = exercises.remove(id);
    if (result == null) throw StateError('could not find exercise with id $id');

    _selectedRoutine = _selectedRoutine.copyWith(activeExercises: exercises);

    _removedIds.add(id);
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

  void _removePreBreakFromFirst(String exerciseId) {
    final sets = _selectedRoutine.getActiveSetsById(exerciseId);
    final attributes = sets.first.attributes;
    attributes.remove(AttributeName.pre_break);
  }

  void addActiveSet({@required String exerciseId}) {
    final activeSets = _selectedRoutine.getActiveSetsById(exerciseId);

    final allExercises = _routinesService.exercises;

    final exercise = allExercises.getExerciseFrom(exerciseId);

    final activeSet = ActiveSet(
      attributes: exercise.attributes.toMap(),
      exercise: exercise,
    );

    activeSets.add(activeSet);

    _removePreBreakFromFirst(exerciseId);
  }

  void changeActiveSetAttribute({@required String exerciseId, @required AttributeName attributeName, @required double value}) {
    final activeSet = _selectedRoutine.getActiveSetById(exerciseId);

    final attributes = activeSet.attributes;
    if (!attributes.containsKey(attributeName)) throw StateError('attribute name must exist in exercise');

    attributes[attributeName] = value;
  }

  Future<void> completeActiveSet({@required String exerciseId}) async {
    final activeSet = _selectedRoutine.getActiveSetById(exerciseId);
    activeSet.checkOk();

    await postWorkout();

    activeSet.setCompleted(true);
  }

  void editActiveSet({@required String exerciseId, @required int index}) {
    final activeSets = _selectedRoutine.getActiveSetsById(exerciseId);
    final activeSet = _selectedRoutine.getActiveSetById(exerciseId);

    if (activeSet.checked) {
      activeSet.setCompleted(true);
    } else {
      activeSets.removeLast();
    }

    activeSets[index].setCompleted(false);
  }

  ActiveSet deleteActiveSet({@required String exerciseId, @required int index}) {
    final activeSets = _selectedRoutine.getActiveSetsById(exerciseId);

    final activeSet = activeSets.removeAt(index);

    _removePreBreakFromFirst(exerciseId);

    return activeSet;
  }

  Future<void> postWorkout() async {
    final date = DateTimeUtils.today;
    final workout = await _workoutsRepository.postWorkout(
      _selectedRoutine.activeExercisesWithNames(_routinesService.exercises),
      date,
    );
    if (workout != null) {
      _workoutsService.updateWorkout(workout);
    } else {
      _workoutsService.deleteWorkout(date);
    }
  }

  void insertActiveSet({@required String exerciseId, @required int index, @required ActiveSet activeSet}) {
    final activeSets = _selectedRoutine.getActiveSetsById(exerciseId);
    activeSets.insert(index, activeSet);
  }

  void dispose() {
    _workoutsRepository.workoutsApiService.dispose();
  }
}

extension on List<Map<AttributeName, double>> {
  double get maxWeight {
    double result = 0;
    forEach((mySet) {
      final value = mySet[AttributeName.weight];
      if (value > result) result = value;
    });
    return result;
  }
}
