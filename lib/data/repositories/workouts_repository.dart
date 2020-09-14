import 'package:track_workouts/data/api/workouts_api_service.dart';
import 'package:track_workouts/data/model/workouts/workout/workout.dart';
import 'package:track_workouts/data/model/workouts/workouts_data/workouts_data.dart';
import 'package:track_workouts/handlers/error/error_handler.dart';

class WorkoutsRepository {
  final WorkoutsApiService workoutsApiService;

  WorkoutsRepository(this.workoutsApiService);

  Future<List<Workout>> getWorkouts({DateTime toDate}) async {
    return await ErrorHandler.catchCommonErrors(() async{
      final to = toDate ?? DateTime.now();
      final response = await workoutsApiService.getWorkoutsData(to.toIso8601String());
      final workoutsData = WorkoutsDataSerializer.fromMap(response.body);
      return workoutsData.workouts;
    });
  }
}
