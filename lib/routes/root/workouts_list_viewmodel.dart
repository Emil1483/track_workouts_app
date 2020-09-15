import 'package:flutter/material.dart';
import 'package:track_workouts/data/services/workouts_service.dart';
import 'package:track_workouts/handlers/error/error_handler.dart';
import 'package:track_workouts/handlers/error/failure.dart';
import 'package:track_workouts/routes/base/base_model.dart';
import 'package:track_workouts/routes/root/root_viewmodel.dart';
import 'package:track_workouts/utils/models/week.dart';

class WorkoutsListViewmodel extends BaseModel {
  final WorkoutsService workoutsService;
  final Week week;

  Failure _failure;

  WorkoutsListViewmodel({
    @required this.workoutsService,
    @required this.week,
  });

  List<FormattedWorkout> get workouts => workoutsService.workouts
      .where((workout) => week.contains(workout.date))
      .map((workout) => FormattedWorkout.from(workout))
      .toList();
  Failure get error => _failure.copy();
  bool get hasError => _failure != null;

  Future<void> getWorkouts({bool updateLoading = true}) async {
    if (updateLoading) setLoading(true);
    await ErrorHandler.handleErrors<void>(
      run: () => workoutsService.expandWorkoutsToInclude(week),
      onFailure: (failure) => _failure = failure,
      onSuccess: (_) => _failure = null,
    );
    setLoading(false);
  }
}
