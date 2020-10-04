import 'package:flutter/material.dart';
import 'package:track_workouts/data/model/workouts/workouts_data/workouts_data.dart';
import 'package:uuid/uuid.dart';
import 'package:track_workouts/data/model/workouts/workout/workout.dart';
import 'package:track_workouts/data/repositories/workouts_repository.dart';
import 'package:track_workouts/utils/models/week.dart';

class Listener {
  final Function(String) listener;
  final String id;

  Listener({@required this.listener, @required this.id});
}

class WorkoutsService {
  final WorkoutsRepository _workoutsRepository;

  final List<Listener> _listeners = [];

  List<Workout> _workouts;
  bool _loadedAll = false;

  WorkoutsService(this._workoutsRepository);

  bool get loadedAll => _loadedAll;

  List<Workout> get workouts => _workouts == null ? null : _workouts.copy();

  String addListener(Function(String) listener) {
    final id = Uuid().v1();
    _listeners.add(Listener(listener: listener, id: id));
    return id;
  }

  void disposeListener(String id) => _listeners.removeWhere((listener) => listener.id == id);

  void _notifyListeners() => _listeners.forEach((listener) => listener.listener(listener.id));

  void _addWorkouts(WorkoutsData workoutsData) {
    if (_workouts == null) _workouts = [];

    final workouts = workoutsData.workouts;
    _workouts.addAll(workouts);
    _loadedAll = workouts.length < workoutsData.options.limit;
  }

  Future<void> loadInitialWorkouts() async {
    final workoutsData = await _workoutsRepository.getWorkoutsData();
    await Future.delayed(Duration(seconds: 1));
    _addWorkouts(workoutsData);
    _notifyListeners();
  }

  Future<void> expandWorkoutsToInclude(Week week) async {
    if (_workouts == null) _workouts = [];

    bool addedToWorkouts = false;
    while (!workoutsContains(week)) {
      final toDate = _workouts.isEmpty ? null : _workouts.last.date.subtract(Duration(days: 1));
      final workoutsData = await _workoutsRepository.getWorkoutsData(toDate: toDate);
      _addWorkouts(workoutsData);

      addedToWorkouts = true;
    }

    if (addedToWorkouts) _notifyListeners();
  }

  void updateWorkout(Workout workout) {
    int index = 0;
    while (index < _workouts.length) {
      final currentDate = _workouts[index].date;
      if (currentDate.isBefore(workout.date)) {
        _workouts.insert(index, workout);
        break;
      }
      if (currentDate.isAtSameMomentAs(workout.date)) {
        _workouts[index] = workout;
        break;
      }
      index++;
    }
    _notifyListeners();
  }

  bool workoutsContains(Week week) {
    if (_workouts == null) return false;
    if (_workouts.isEmpty) return false;
    if (_loadedAll) return true;
    return !_workouts.last.date.isAfter(week.start);
  }

  void dispose() {
    _workoutsRepository.workoutsApiService.dispose();
  }
}
