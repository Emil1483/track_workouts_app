import 'package:flutter/cupertino.dart';
import 'package:track_workouts/data/model/workouts/workout/workout.dart';
import 'package:track_workouts/data/services/workouts_service.dart';
import 'package:track_workouts/routes/base/base_model.dart';
import 'package:track_workouts/utils/models/week.dart';
import 'package:track_workouts/utils/date_time_utils.dart';

class RootViewmodel extends BaseModel {
  final WorkoutsService workoutsService;

  final _MyPageController pageController = _MyPageController();
  bool _hasSetPageController = false;

  RootViewmodel({@required this.workoutsService});

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  Week get currentWeek {
    final index = pageController.currentPage;
    return getWeekFromIndex(index);
  }

  int get pageCount {
    if (!workoutsService.loadedAll) return null;
    final lastDate = workoutsService.workouts.last.date;
    return 1 + lastDate.weeksUntil(DateTime.now());
  }

  bool get cantGoLeft => pageController.currentPage <= 0;

  bool get cantGoRight {
    if (!workoutsService.loadedAll) return false;
    final lastDate = workoutsService.workouts.last.date;
    final weeksToLastWorkout = lastDate.flooredToWeek.weeksUntil(currentWeek.start);
    return weeksToLastWorkout <= 0;
  }

  void onWorkoutsLoaded() {
    if (workoutsService.loadedAll) notifyListeners();

    if (!_hasSetPageController) {
      _hasSetPageController = true;

      final firstDate = workoutsService.workouts.first.date;
      final index = firstDate.weeksUntil(DateTime.now());
      pageController.jumpToPage(index);
    }
  }

  void disableSetPageController() => _hasSetPageController = true;

  void changeTab(int change) {
    final newIndex = pageController.currentPage + change;
    pageController.animateToPage(
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
  final List<Map<String, double>> sets;

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
