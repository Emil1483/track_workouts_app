import 'package:angel_serialize/angel_serialize.dart';

part 'workout.g.dart';

DateTime _deserializeDate(String timestamp) => DateTime.parse(timestamp);
String _serializeDate(DateTime date) => date.toIso8601String();

Map<String, List<Map<String, double>>> _deserializeExercises(Map<String, dynamic> map) {
  return Map<String, dynamic>.from(map).map(
    (name, sets) => MapEntry(
      name,
      _getSetsFromDynamic(sets),
    ),
  );
}

List<Map<String, double>> _getSetsFromDynamic(dynamic sets) {
  return List<dynamic>.from(sets).map(_getSetFromDynamic).toList();
}

Map<String, double> _getSetFromDynamic(dynamic setElement) {
  return Map<String, dynamic>.from(setElement).map(
    (setField, setValue) => MapEntry(setField, (setValue as int) + 0.0),
  );
}

@serializable
abstract class _Workout {
  @SerializableField(alias: '_id')
  String id;

  @SerializableField(deserializer: #_deserializeDate, serializer: #_serializeDate)
  DateTime date;

  @SerializableField(deserializer: #_deserializeExercises)
  Map<String, List<Map<String, double>>> exercises;
}
