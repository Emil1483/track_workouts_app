import 'package:flutter/material.dart';
import 'package:track_workouts/routes/base/base_widget.dart';
import 'package:track_workouts/routes/root/root_viewmodel.dart';
import 'package:track_workouts/style/theme.dart';

class RootRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseWidget<RootViewmodel>(
      model: RootViewmodel(),
      onModelReady: (model) => model.getWorkouts(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(title: Text('Track Workouts', style: getTextStyle(TextStyles.H1))),
        body: model.loading
            ? Center(child: CircularProgressIndicator())
            : Text(
                'hello',
                style: getTextStyle(TextStyles.BODY1),
              ),
      ),
    );
  }
}
