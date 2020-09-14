import 'package:track_workouts/handlers/error/error_handler.dart';

class Failure {
  final String message;

  Failure([this.message = ErrorHandler.unknownError]) : assert(message != null);

  @override
  String toString() => message;

  Failure copy() => Failure(message);
}
