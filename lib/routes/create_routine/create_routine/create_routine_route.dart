import 'package:flutter/material.dart';
import 'package:track_workouts/handlers/router.dart';
import 'package:track_workouts/routes/create_routine/create_exercise/create_exercise_route.dart';
import 'package:track_workouts/style/theme.dart';
import 'package:track_workouts/ui_elements/main_button.dart';
import 'package:track_workouts/ui_elements/text_field_app_bar.dart';

class CreateRoutine extends StatelessWidget {
  static const String routeName = 'createRoutine';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TextFieldAppBar(labelText: 'Workout Name'),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showModalBottomSheet(context: context, builder: _buildBottomSheet, backgroundColor: AppColors.primary),
        child: Icon(Icons.add),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(),
          ),
          MainButton(
            onTaps: [() {}],
            texts: ['save'],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSheet(BuildContext context) {
    return Material(
      color: AppColors.primary,
      child: Stack(
        children: [
          ListView(),
          Positioned(
            bottom: 16.0,
            right: 16.0,
            child: FloatingActionButton(
              onPressed: () => Router.pushNamed(CreateExerciseRoute.routeName),
              child: Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}