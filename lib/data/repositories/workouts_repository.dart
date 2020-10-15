import 'package:track_workouts/constants/api_info.dart';
import 'package:track_workouts/data/api/workouts_api_service.dart';
import 'package:track_workouts/data/model/routine/routine.dart';
import 'package:track_workouts/data/model/workouts/workout/workout.dart';
import 'package:track_workouts/data/model/workouts/workouts_data/workouts_data.dart';
import 'package:track_workouts/handlers/error/error_handler.dart';
import 'package:track_workouts/utils/string_utils.dart';
import 'package:track_workouts/utils/date_time_utils.dart';

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
      final to = toDate ?? DateTimeUtils.today;
      final response = await workoutsApiService.getWorkoutsData(to.toIso8601String());
      return WorkoutsDataSerializer.fromMap(response.body);
    });
  }

  Future<Workout> postWorkout(Map<String, List<ActiveSet>> activeExercises, DateTime date) async {
    return await ErrorHandler.catchCommonErrors(() async {
      final List<Map<String, dynamic>> exercises = [];

      activeExercises.forEach((exerciseName, activeSets) {
        final List<Map<String, double>> sets = [];

        activeSets.forEach((activeSet) {
          final mySet = activeSet.attributes.map((name, value) => MapEntry(name.string.underscoreToCamelcase, value));

          mySet.removeWhere(
            (name, value) => value == null || name == AttributeName.pre_break.string.underscoreToCamelcase && value == 0,
          );

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
        'date': date.toIso8601String(),
        'exercises': exercises,
      });

      final body = response.body as Map;
      if (body['workout'] == null) return null;
      return WorkoutSerializer.fromMap(body['workout']);
    });
  }
}
