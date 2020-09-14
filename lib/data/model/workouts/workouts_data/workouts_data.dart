import 'package:angel_serialize/angel_serialize.dart';
import 'package:track_workouts/data/model/workouts/options/options.dart';
import 'package:track_workouts/data/model/workouts/workout/workout.dart';

part 'workouts_data.g.dart';

Options _deserializeOptions(Map<String, dynamic> map) => OptionsSerializer.fromMap(map);
Map<String, dynamic> _serializeOptions(Options options) => OptionsSerializer.toMap(options);

List<Workout> _deserializeWorkouts(List<dynamic> maps) =>
    maps.map((map) => WorkoutSerializer.fromMap(map as Map<String, dynamic>)).toList();
List<dynamic> _serializeWorkouts(List<Workout> workouts) => workouts.map((workout) => WorkoutSerializer.toMap(workout)).toList();

@serializable
abstract class _WorkoutsData {
  @SerializableField(deserializer: #_deserializeOptions, serializer: #_serializeOptions)
  Options options;

  @SerializableField(alias: 'totalWorkouts')
  int totalWorkouts;

  @SerializableField(deserializer: #_deserializeWorkouts, serializer: #_serializeWorkouts)
  List<Workout> workouts;
}
