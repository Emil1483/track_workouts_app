import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:track_workouts/data/services/workouts_service.dart';
import 'package:track_workouts/handlers/error/failure.dart';
import 'package:track_workouts/routes/base/base_widget.dart';
import 'package:track_workouts/routes/root/root_viewmodel.dart';
import 'package:track_workouts/routes/root/workouts_list_viewmodel.dart';
import 'package:track_workouts/style/theme.dart';
import 'package:track_workouts/utils/models/week.dart';

class RootRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseWidget<RootViewmodel>(
      model: RootViewmodel(workoutsService: Provider.of<WorkoutsService>(context)),
      onDispose: (model) => model.dispose(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(title: Text('Track Workouts', style: getTextStyle(TextStyles.h1))),
        body: Column(
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
    final rootModel = Provider.of<RootViewmodel>(context, listen: false);
    return BaseWidget<WorkoutsListViewmodel>(
      model: WorkoutsListViewmodel(
        week: week,
        workoutsService: Provider.of<WorkoutsService>(context),
      ),
      onModelReady: (model) async {
        await model.getWorkouts();
        if (model.hasError) {
          rootModel.disableSetPageController();
          return;
        }

        rootModel.onWorkoutsLoaded();
      },
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
        return ListView(
          children: _buildWorkoutWidgets(model.workouts),
        );
      },
    );
  }

  List<Widget> _buildWorkoutWidgets(List<FormattedWorkout> workouts) {
    return workouts
        .map(
          (workout) => Container(
            color: AppColors.primary,
            margin: EdgeInsets.only(bottom: 12.0),
            padding: EdgeInsets.symmetric(vertical: 6.0),
            child: Column(
              children: [
                Text(
                  workout.date.toString(),
                  style: getTextStyle(TextStyles.body1),
                ),
                Text(
                  'number of exercises: ${workout.exercises.length}',
                  style: getTextStyle(TextStyles.body1),
                ),
              ],
            ),
          ),
        )
        .toList();
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
