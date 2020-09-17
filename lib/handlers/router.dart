import 'package:flutter/material.dart';
import 'package:track_workouts/routes/root/root_route.dart';
import 'package:track_workouts/routes/root/root_viewmodel.dart';
import 'package:track_workouts/routes/workout_details/exercise_details_route.dart';
import 'package:track_workouts/routes/workout_details/workout_details_route.dart';

class Router {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey(debugLabel: 'Main Navigator');

  static const String rootRoute = 'root';
  static const String workoutDetailsRoute = 'workoutDetails';
  static const String exerciseDetailsRoute = 'exerciseDetails';

  static Future<T> pushNamedAndRemoveUntil<T>(String pushRoute, {String untilRoute, List arguments}) {
    return navigatorKey.currentState.pushNamedAndRemoveUntil(
        pushRoute, untilRoute != null ? ModalRoute.withName(untilRoute) : (Route<dynamic> route) => false,
        arguments: arguments);
  }

  static void popUntil(String untilRoute) {
    navigatorKey.currentState.popUntil(ModalRoute.withName(untilRoute));
  }

  static Future<T> pushNamed<T>(String route, {Object arguments}) =>
      navigatorKey.currentState.pushNamed(route, arguments: arguments);

  static Future<T> pushReplacementNamed<T>(String route, {Object arguments}) =>
      navigatorKey.currentState.pushReplacementNamed(route, arguments: arguments);

  static void pop<T>([T result]) => navigatorKey.currentState.pop(result);

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case rootRoute:
        return MaterialPageRoute(builder: (context) => RootRoute(), settings: settings);
      case workoutDetailsRoute:
        final arguments = settings.arguments as List;
        FormattedWorkout workout = arguments[0];
        return MaterialPageRoute(builder: (context) => WorkoutDetailsRoute(workout: workout), settings: settings);
      case exerciseDetailsRoute:
        final arguments = settings.arguments as List;
        FormattedExercise exercise = arguments[0];
        return MaterialPageRoute(builder: (context) => ExerciseDetails(exercise: exercise), settings: settings);
      default:
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
