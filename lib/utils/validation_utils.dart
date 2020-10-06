import 'package:track_workouts/utils/string_utils.dart';

class Validation {
  static String notEmpty(String value) {
    if (value.isNullEmptyOrWhitespace) {
      return 'This field cannot be empty';
    }
    return null;
  }

  static String mustBeNumber(String value) {
    final emptyString = notEmpty(value);
    if (emptyString != null) return emptyString;
    if (double.tryParse(value) == null) {
      return 'This field must be a number';
    }
    return null;
  }
}
