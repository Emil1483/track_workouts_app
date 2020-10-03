import 'package:track_workouts/constants/api_info.dart';
import 'package:track_workouts/data/api/workouts_api_service.dart';
import 'package:track_workouts/data/model/routine/routine.dart';
import 'package:track_workouts/data/model/workouts/workout/workout.dart';
import 'package:track_workouts/data/model/workouts/workouts_data/workouts_data.dart';
import 'package:track_workouts/handlers/error/error_handler.dart';
import 'package:track_workouts/utils/string_utils.dart';

class WorkoutsRepository {
  final WorkoutsApiService workoutsApiService;

  WorkoutsRepository(this.workoutsApiService);

  Future<List<Workout>> getWorkouts({DateTime toDate}) async {
    return await ErrorHandler.catchCommonErrors(() async {
      final workoutsData = await getWorkoutsData(toDate: toDate);
      return workoutsData.workouts.copy();
    });
  }

  Future<WorkoutsData> getWorkoutsData({DateTime toDate}) async {
    return await ErrorHandler.catchCommonErrors(() async {
      final to = toDate ?? DateTime.now();
      final response = await workoutsApiService.getWorkoutsData(to.toIso8601String());
      return WorkoutsDataSerializer.fromMap(response.body);
    });
  }

  Future<Workout> postWorkout(Map<String, List<ActiveSet>> activeExercises) async {
    return await ErrorHandler.catchCommonErrors(() async {
      final List<Map<String, dynamic>> exercises = [];

      activeExercises.forEach((exerciseName, activeSets) {
        final List<Map<String, double>> sets = [];

        activeSets.forEach((activeSet) {
          final mySet = activeSet.attributes.map((name, value) => MapEntry(name.string.underscoreToCamelcase, value));

          mySet.removeWhere((name, value) => value == null);

          if (mySet.isNotEmpty) sets.add(mySet);
        });

        if (sets.isNotEmpty) {
          exercises.add({
            'name': exerciseName,
            'sets': sets,
          });
        }
      });

      final response = await workoutsApiService.postWorkout({
        'password': ApiInfo.API_PASSWORD,
        'date': DateTime.now().toIso8601String(),
        'exercises': exercises,
      });

      return WorkoutSerializer.fromMap((response.body as Map)['workout']);
    });
  }
}
