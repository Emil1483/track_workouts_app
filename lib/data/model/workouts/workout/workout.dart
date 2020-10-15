import 'package:angel_serialize/angel_serialize.dart';
import 'package:track_workouts/utils/string_utils.dart';
import 'package:track_workouts/utils/num_utils.dart';

part 'workout.g.dart';

DateTime _deserializeDate(String timestamp) => DateTime.parse(timestamp);
String _serializeDate(DateTime date) => date.toIso8601String();

Map<String, List<Map<AttributeName, double>>> _deserializeExercises(Map<String, dynamic> map) {
  return Map<String, dynamic>.from(map).map(
    (name, sets) => MapEntry(
      name,
      _getSetsFromDynamic(sets),
    ),
  );
}

List<Map<AttributeName, double>> _getSetsFromDynamic(dynamic sets) {
  return List<dynamic>.from(sets).map(_getSetFromDynamic).toList();
}

Map<AttributeName, double> _getSetFromDynamic(dynamic setElement) {
  return Map<String, dynamic>.from(setElement).map(
    (setField, setValue) => MapEntry(_getAttributeEnum(setField), (setValue as num) + 0.0),
  );
}

AttributeName _getAttributeEnum(String string) {
  final formattedString = string.camelcaseToUnderscore;
  return AttributeName.values.firstWhere((name) => name.string == formattedString);
}

enum AttributeName { pre_break, reps, weight, band_level, time, body_mass }

enum Unit { kg, s }

extension AttributeNameExtension on AttributeName {
  String get string => this.toString().split('.')[1];

  String get formattedString => string.formatFromUnderscore;

  static const List<AttributeName> repeatingAttributes = [AttributeName.body_mass];

  static const List<AttributeName> optionalOneOf = [AttributeName.weight, AttributeName.band_level];

  static AttributeName fromString(String string) {
    return AttributeName.values.firstWhere((attributeName) => attributeName.toString() == string);
  }

  Unit get unit {
    switch (this) {
      case AttributeName.body_mass:
        return Unit.kg;
      case AttributeName.pre_break:
        return Unit.s;
      case AttributeName.time:
        return Unit.s;
      case AttributeName.weight:
        return Unit.kg;
      default:
        return null;
    }
  }
}

extension UnitExtension on Unit {
  String get string => this.toString().split('.')[1];
}

extension Attribute on MapEntry<AttributeName, double> {
  String get valueString {
    switch (key.unit) {
      case Unit.kg:
        return value.withMaxTwoDecimals;
      case Unit.s:
        return value.round().toString();
    }

    return value.round().toString();
  }

  String get formattedValueString {
    String result = valueString;
    Unit unit = key.unit;
    if (unit != null) result += ' ${unit.string}';
    return result;
  }
}

extension Workouts on List<Workout> {
  List<Workout> copy() => List.generate(length, (i) => this[i].copyWith());
}

extension AttributeNames on List<AttributeName> {
  List<AttributeName> copy() => List.from(this);

  Map<AttributeName, double> toMap() => Map.fromIterable(this, value: (_) => null);
}

@serializable
abstract class _Workout {
  @SerializableField(alias: '_id')
  String id;

  @SerializableField(deserializer: #_deserializeDate, serializer: #_serializeDate)
  DateTime date;

  @SerializableField(deserializer: #_deserializeExercises)
  Map<String, List<Map<AttributeName, double>>> exercises;
}
