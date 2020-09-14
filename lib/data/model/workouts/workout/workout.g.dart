// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout.dart';

// **************************************************************************
// JsonModelGenerator
// **************************************************************************

@generatedSerializable
class Workout extends _Workout {
  Workout(
      {this.id, this.date, Map<String, List<Map<String, double>>> exercises})
      : this.exercises = Map.unmodifiable(exercises ?? {});

  @override
  String id;

  @override
  DateTime date;

  @override
  Map<String, List<Map<String, double>>> exercises;

  Workout copyWith(
      {String id,
      DateTime date,
      Map<String, List<Map<String, double>>> exercises}) {
    return Workout(
        id: id ?? this.id,
        date: date ?? this.date,
        exercises: exercises ?? this.exercises);
  }

  bool operator ==(other) {
    return other is _Workout &&
        other.id == id &&
        other.date == date &&
        MapEquality<String, List>(
                keys: DefaultEquality<String>(),
                values: ListEquality<Map>(MapEquality<String, double>(
                    keys: DefaultEquality<String>(),
                    values: DefaultEquality<double>())))
            .equals(other.exercises, exercises);
  }

  @override
  int get hashCode {
    return hashObjects([id, date, exercises]);
  }

  @override
  String toString() {
    return "Workout(id=$id, date=$date, exercises=$exercises)";
  }

  Map<String, dynamic> toJson() {
    return WorkoutSerializer.toMap(this);
  }
}

// **************************************************************************
// SerializerGenerator
// **************************************************************************

const WorkoutSerializer workoutSerializer = WorkoutSerializer();

class WorkoutEncoder extends Converter<Workout, Map> {
  const WorkoutEncoder();

  @override
  Map convert(Workout model) => WorkoutSerializer.toMap(model);
}

class WorkoutDecoder extends Converter<Map, Workout> {
  const WorkoutDecoder();

  @override
  Workout convert(Map map) => WorkoutSerializer.fromMap(map);
}

class WorkoutSerializer extends Codec<Workout, Map> {
  const WorkoutSerializer();

  @override
  get encoder => const WorkoutEncoder();
  @override
  get decoder => const WorkoutDecoder();
  static Workout fromMap(Map map) {
    return Workout(
        id: map['_id'] as String,
        date: _deserializeDate(map['date']),
        exercises: _deserializeExercises(map['exercises']));
  }

  static Map<String, dynamic> toMap(_Workout model) {
    if (model == null) {
      return null;
    }
    return {
      '_id': model.id,
      'date': _serializeDate(model.date),
      'exercises': model.exercises
    };
  }
}

abstract class WorkoutFields {
  static const List<String> allFields = <String>[id, date, exercises];

  static const String id = '_id';

  static const String date = 'date';

  static const String exercises = 'exercises';
}
