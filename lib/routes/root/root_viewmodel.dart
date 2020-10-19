import 'package:flutter/cupertino.dart';
import 'package:track_workouts/data/model/workouts/workout/workout.dart';
import 'package:track_workouts/data/services/new_workout_service.dart';
import 'package:track_workouts/data/services/workouts_service.dart';
import 'package:track_workouts/handlers/error/error_handler.dart';
import 'package:track_workouts/handlers/router.dart';
import 'package:track_workouts/routes/base/base_model.dart';
import 'package:track_workouts/routes/new_workout/choose_routine/choose_routine_route.dart';
import 'package:track_workouts/routes/new_workout/new_workout/new_workout_route.dart';
import 'package:track_workouts/utils/models/week.dart';
import 'package:track_workouts/utils/date_time_utils.dart';

class RootViewmodel extends BaseModel {
  final WorkoutsService workoutsService;
  final NewWorkoutService newWorkoutService;

  _MyPageController _pageController;

  String _listenerId;

  RootViewmodel({@required this.workoutsService, @required this.newWorkoutService}) {
    _listenerId = workoutsService.addListener((_) => notifyListeners());
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
    workoutsService.disposeListener(_listenerId);
  }

  _MyPageController get pageController => _pageController;

  bool get hasChosenWorkout => newWorkoutService.selectedRoutine != null;

  bool get canChooseWorkout => workoutsService.workouts != null;

  Future<void> loadInitialWorkouts() async {
    setLoading(true);
    await ErrorHandler.handleErrors<void>(
      run: workoutsService.loadInitialWorkouts,
      onFailure: (failure) {
        _pageController = _MyPageController();
      },
      onSuccess: (success) {
        final firstDate = workoutsService.workouts.first.date;
        final currentWeek = getWeekFromIndex(0).start;
        final index = firstDate.weeksUntil(currentWeek);
        _pageController = _MyPageController(initialPage: index);
      },
    );
    setLoading(false);
  }

  Future<void> navigateToNewWorkout() async {
    await Router.pushNamed(
      hasChosenWorkout ? NewWorkoutRoute.routeName : ChooseRoutineRoute.routeName,
    );
    notifyListeners();
  }

  Week get currentWeek {
    final index = _pageController.currentPage;
    return getWeekFromIndex(index);
  }

  int get pageCount {
    if (!workoutsService.loadedAll) return null;
    final lastDate = workoutsService.workouts.last.date;
    return 1 + lastDate.weeksUntil(DateTime.now());
  }

  bool get cantGoLeft => _pageController.currentPage <= 0;

  bool get cantGoRight {
    if (!workoutsService.loadedAll) return false;
    final lastDate = workoutsService.workouts.last.date;
    final weeksToLastWorkout = lastDate.flooredToWeek.weeksUntil(currentWeek.start);
    return weeksToLastWorkout <= 0;
  }

  void changeTab(int change) {
    final newIndex = _pageController.currentPage + change;
    _pageController.animateToPage(
      newIndex,
      duration: Duration(milliseconds: 250),
      curve: Curves.easeInOutCubic,
    );
  }

  Week getWeekFromIndex(int index) => Week(
        DateTime.now().subtract(Duration(days: 7 * index)),
      );
}

class FormattedWorkout {
  final DateTime date;
  final List<FormattedExercise> exercises;
  final String id;

  FormattedWorkout({
    @required this.date,
    @required this.exercises,
    @required this.id,
  });

  @override
  String toString() => 'date = $date, id = $id, exercises = $exercises';

  factory FormattedWorkout.from(Workout workout) {
    final List<FormattedExercise> exercises = [];
    workout.exercises.forEach((name, sets) => exercises.add(FormattedExercise(name, sets)));
    return FormattedWorkout(
      date: workout.date,
      id: workout.id,
      exercises: exercises,
    );
  }
}

class FormattedExercise {
  final String name;
  final List<Map<AttributeName, double>> sets;

  FormattedExercise(this.name, this.sets);

  @override
  String toString() => 'name = $name, sets = $sets';
}

class _MyPageController extends PageController {
  _MyPageController({int initialPage = 0}) : super(initialPage: initialPage);

  int get currentPage {
    if (positions.isEmpty) return initialPage;
    return page.round();
  }
}
