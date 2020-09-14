// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workouts_data.dart';

// **************************************************************************
// JsonModelGenerator
// **************************************************************************

@generatedSerializable
class WorkoutsData extends _WorkoutsData {
  WorkoutsData({this.options, this.totalWorkouts, List<dynamic> workouts})
      : this.workouts = List.unmodifiable(workouts ?? []);

  @override
  Options options;

  @override
  int totalWorkouts;

  @override
  List<Workout> workouts;

  WorkoutsData copyWith(
      {dynamic options, int totalWorkouts, List<dynamic> workouts}) {
    return WorkoutsData(
        options: options ?? this.options,
        totalWorkouts: totalWorkouts ?? this.totalWorkouts,
        workouts: workouts ?? this.workouts);
  }

  bool operator ==(other) {
    return other is _WorkoutsData &&
        other.options == options &&
        other.totalWorkouts == totalWorkouts &&
        ListEquality<dynamic>(DefaultEquality())
            .equals(other.workouts, workouts);
  }

  @override
  int get hashCode {
    return hashObjects([options, totalWorkouts, workouts]);
  }

  @override
  String toString() {
    return "WorkoutsData(options=$options, totalWorkouts=$totalWorkouts, workouts=$workouts)";
  }

  Map<String, dynamic> toJson() {
    return WorkoutsDataSerializer.toMap(this);
  }
}

// **************************************************************************
// SerializerGenerator
// **************************************************************************

const WorkoutsDataSerializer workoutsDataSerializer = WorkoutsDataSerializer();

class WorkoutsDataEncoder extends Converter<WorkoutsData, Map> {
  const WorkoutsDataEncoder();

  @override
  Map convert(WorkoutsData model) => WorkoutsDataSerializer.toMap(model);
}

class WorkoutsDataDecoder extends Converter<Map, WorkoutsData> {
  const WorkoutsDataDecoder();

  @override
  WorkoutsData convert(Map map) => WorkoutsDataSerializer.fromMap(map);
}

class WorkoutsDataSerializer extends Codec<WorkoutsData, Map> {
  const WorkoutsDataSerializer();

  @override
  get encoder => const WorkoutsDataEncoder();
  @override
  get decoder => const WorkoutsDataDecoder();
  static WorkoutsData fromMap(Map map) {
    return WorkoutsData(
        options: _deserializeOptions(map['options']),
        totalWorkouts: map['totalWorkouts'] as int,
        workouts: _deserializeWorkouts(map['workouts']));
  }

  static Map<String, dynamic> toMap(_WorkoutsData model) {
    if (model == null) {
      return null;
    }
    return {
      'options': _serializeOptions(model.options),
      'totalWorkouts': model.totalWorkouts,
      'workouts': _serializeWorkouts(model.workouts)
    };
  }
}

abstract class WorkoutsDataFields {
  static const List<String> allFields = <String>[
    options,
    totalWorkouts,
    workouts
  ];

  static const String options = 'options';

  static const String totalWorkouts = 'totalWorkouts';

  static const String workouts = 'workouts';
}
