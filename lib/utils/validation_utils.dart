import 'package:track_workouts/utils/string_utils.dart';

class Validation {
  static String mustBeNumber(String value) {
    if (value.isNullEmptyOrWhitespace) {
      return 'Field cannot be empty';
    }
    if (double.tryParse(value) == null) {
      return 'Field must be a number';
    }
    return null;
  }
}
