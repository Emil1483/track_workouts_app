import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:track_workouts/data/services/workouts_service.dart';
import 'package:track_workouts/routes/base/base_widget.dart';
import 'package:track_workouts/routes/root/root_viewmodel.dart';
import 'package:track_workouts/style/theme.dart';

class RootRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseWidget<RootViewmodel>(
      model: RootViewmodel(Provider.of<WorkoutsService>(context)),
      onModelReady: (model) => model.getWorkouts(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(title: Text('Track Workouts', style: getTextStyle(TextStyles.H1))),
        body: model.loading
            ? Center(child: CircularProgressIndicator())
            : model.hasError
                ? Center(child: Text(model.error.toString()))
                : ListView(
                    children: model.workouts.map(_buildWorkoutWidget).toList(),
                  ),
      ),
    );
  }

  Widget _buildWorkoutWidget(FormattedWorkout workout) {
    return Column(
      children: [
        Text(
          workout.date.toString(),
          style: getTextStyle(TextStyles.BODY1),
        ),
        Text(
          'number of exercises: ${workout.exercises.length}',
          style: getTextStyle(TextStyles.BODY1),
        ),
        SizedBox(height: 12.0),
      ],
    );
  }
}
