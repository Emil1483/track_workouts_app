import 'package:track_workouts/utils/string_utils.dart';

class Validation {
  static String mustBeNumber(String value) {
    if (value.isNullEmptyOrWhitespace) {
      return 'This field cannot be empty';
    }
    if (double.tryParse(value) == null) {
      return 'This field must be a number';
    }
    return null;
  }
}
