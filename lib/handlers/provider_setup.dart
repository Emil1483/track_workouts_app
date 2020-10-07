import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:track_workouts/data/api/workouts_api_service.dart';
import 'package:track_workouts/data/repositories/workouts_repository.dart';
import 'package:track_workouts/data/services/new_workout_service.dart';
import 'package:track_workouts/data/services/routines_service.dart';
import 'package:track_workouts/data/services/workouts_service.dart';

List<SingleChildWidget> getProviders() {
  final workoutsService = WorkoutsService(WorkoutsRepository(WorkoutsApiService.create()));
  final routinesService = RoutinesService();
  return [
    Provider<WorkoutsService>(
      create: (_) => workoutsService,
      dispose: (_, service) => service.dispose(),
    ),
    Provider<RoutinesService>(
      create: (_) => routinesService,
      dispose: (_, service) => service.dispose(),
    ),
    Provider<NewWorkoutService>(
      create: (_) => NewWorkoutService(WorkoutsRepository(WorkoutsApiService.create()), workoutsService, routinesService),
      dispose: (_, service) => service.dispose(),
    ),
  ];
}
