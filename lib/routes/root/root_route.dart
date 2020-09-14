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
        appBar: AppBar(title: Text('Track Workouts', style: getTextStyle(TextStyles.h1))),
        body: model.loading
            ? Center(
                child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.accent)),
              )
            : RefreshIndicator(
                onRefresh: () async => model.getWorkouts(startLoading: false),
                backgroundColor: AppColors.primary,
                color: AppColors.accent,
                child: _WorkoutsWidget(),
              ),
      ),
    );
  }
}

class _WorkoutsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<RootViewmodel>(context);
    if (model.hasError) {
      return ListView(
        children: _buildErrorWidgets(context),
      );
    }
    return ListView.builder(
      itemCount: model.workouts.length + 1,
      itemBuilder: (context, index) {
        if (index >= model.workouts.length) {
          print('load more please 👍');
          return Container();
        }

        final workout = model.workouts[index];
        return Column(
          children: [
            Text(
              workout.date.toString(),
              style: getTextStyle(TextStyles.body1),
            ),
            Text(
              'number of exercises: ${workout.exercises.length}',
              style: getTextStyle(TextStyles.body1),
            ),
            SizedBox(height: 12.0),
          ],
        );
      },
    );
  }

  List<Widget> _buildErrorWidgets(BuildContext context) {
    final model = Provider.of<RootViewmodel>(context);
    return [
      SizedBox(height: 64.0),
      Center(child: Image.asset('assets/images/error.png', width: 128.0)),
      SizedBox(height: 32.0),
      Text(
        model.error.toString(),
        style: getTextStyle(TextStyles.caption),
        textAlign: TextAlign.center,
      ),
    ];
  }
}
