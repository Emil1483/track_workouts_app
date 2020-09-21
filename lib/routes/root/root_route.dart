import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:track_workouts/data/services/workouts_service.dart';
import 'package:track_workouts/handlers/error/failure.dart';
import 'package:track_workouts/handlers/router.dart';
import 'package:track_workouts/routes/base/base_widget.dart';
import 'package:track_workouts/routes/new_workout/choose_routine/choose_routine_route.dart';
import 'package:track_workouts/routes/root/color_utils.dart';
import 'package:track_workouts/routes/root/root_viewmodel.dart';
import 'package:track_workouts/routes/root/workouts_list_viewmodel.dart';
import 'package:track_workouts/routes/workout_details/workout_details_route.dart';
import 'package:track_workouts/style/theme.dart';
import 'package:track_workouts/ui_elements/date_widget.dart';
import 'package:track_workouts/ui_elements/list_element.dart';
import 'package:track_workouts/utils/models/week.dart';

class RootRoute extends StatelessWidget {
  static const String routeName = 'root';

  @override
  Widget build(BuildContext context) {
    return BaseWidget<RootViewmodel>(
      model: RootViewmodel(workoutsService: Provider.of<WorkoutsService>(context)),
      onModelReady: (model) => model.loadInitialWorkouts(),
      onDispose: (model) => model.dispose(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(title: Text('Track Workouts')),
        body: model.loading
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  _WeekSelector(),
                  Expanded(
                    child: PageView.builder(
                      controller: model.pageController,
                      itemCount: model.pageCount,
                      itemBuilder: (context, index) => _WorkoutsList(
                        week: model.getWeekFromIndex(index),
                      ),
                    ),
                  ),
                  _NewWorkoutButton(),
                ],
              ),
      ),
    );
  }
}

class _WorkoutsList extends StatelessWidget {
  final Week week;

  const _WorkoutsList({@required this.week});

  @override
  Widget build(BuildContext context) {
    return BaseWidget<WorkoutsListViewmodel>(
      model: WorkoutsListViewmodel(
        week: week,
        workoutsService: Provider.of<WorkoutsService>(context),
      ),
      onModelReady: (model) => model.getWorkouts(),
      builder: (context, model, child) {
        if (model.loading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (model.hasError) {
          return RefreshIndicator(
            onRefresh: () => model.getWorkouts(updateLoading: false),
            backgroundColor: AppColors.primary,
            child: ListView(
              children: _buildErrorWidgets(model.error),
            ),
          );
        }
        if (model.workouts.isEmpty) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
              alignment: Alignment(0, -0.45),
              child: Text(
                '😪\n\nno workouts this week',
                textAlign: TextAlign.center,
                style: getTextStyle(TextStyles.body2),
              ),
            ),
          );
        }
        return ListView(children: model.workouts.map(_buildWorkoutWidget).toList());
      },
    );
  }

  Widget _buildWorkoutWidget(FormattedWorkout workout) {
    return ListElement(
      onTap: () => Router.pushNamed(WorkoutDetailsRoute.routeName, arguments: [workout]),
      mainWidget: Row(
        children: [
          Text('●  ', style: getTextStyle(TextStyles.subtitle1).copyWith(color: ColorUtils.getColorFrom(workout))),
          DateWidget(date: workout.date, style: getTextStyle(TextStyles.subtitle1)),
        ],
      ),
    );
  }

  List<Widget> _buildErrorWidgets(Failure error) {
    return [
      SizedBox(height: 64.0),
      Center(child: Image.asset('assets/images/error.png', width: 128.0)),
      SizedBox(height: 32.0),
      Text(
        error.toString(),
        style: getTextStyle(TextStyles.caption),
        textAlign: TextAlign.center,
      ),
    ];
  }
}

class _WeekSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<RootViewmodel>(context);
    return AnimatedBuilder(
      animation: model.pageController,
      builder: (context, child) => Material(
        color: AppColors.black500,
        child: Container(
          height: 56.0,
          padding: EdgeInsets.symmetric(horizontal: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.chevron_left),
                color: AppColors.accent,
                disabledColor: AppColors.disabled,
                onPressed: model.cantGoLeft ? null : () => model.changeTab(-1),
              ),
              Text(
                model.currentWeek?.weekString ?? '',
                style: getTextStyle(TextStyles.caption),
              ),
              IconButton(
                icon: Icon(Icons.chevron_right),
                color: AppColors.accent,
                disabledColor: AppColors.disabled,
                onPressed: model.cantGoRight ? null : () => model.changeTab(1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NewWorkoutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.0,
      decoration: BoxDecoration(gradient: LinearGradient(colors: [AppColors.accent, AppColors.accent900])),
      child: Material(
        color: AppColors.transparent,
        child: InkWell(
          onTap: () => Router.pushNamed(ChooseRoutineRoute.routeName),
          child: Center(
            child: Text(
              'New Workout'.toUpperCase(),
              style: getTextStyle(TextStyles.button),
            ),
          ),
        ),
      ),
    );
  }
}
