import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:track_workouts/data/model/routine/routine.dart';
import 'package:track_workouts/data/services/routines_service.dart';
import 'package:track_workouts/handlers/router.dart';
import 'package:track_workouts/routes/base/base_widget.dart';
import 'package:track_workouts/routes/create_routine/create_routine/create_routine_viewmodel.dart';
import 'package:track_workouts/style/theme.dart';
import 'package:track_workouts/ui_elements/main_button.dart';
import 'package:track_workouts/ui_elements/text_field_app_bar.dart';

class CreateRoutine extends StatelessWidget {
  static const String routeName = 'createRoutine';

  @override
  Widget build(BuildContext context) {
    return BaseWidget<CreateRoutineViewmodel>(
      model: CreateRoutineViewmodel(routinesService: Provider.of<RoutinesService>(context)),
      builder: (context, model, child) => Scaffold(
        appBar: TextFieldAppBar(labelText: 'Workout Name'),
        floatingActionButton: FloatingActionButton(
          onPressed: () => showModalBottomSheet(
            context: context,
            builder: (_) => ChangeNotifierProvider.value(
              value: model,
              child: _AddExerciseSheet(),
            ),
            backgroundColor: AppColors.primary,
          ),
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
      ),
    );
  }
}

class _AddExerciseSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<CreateRoutineViewmodel>(context);
    return Material(
      color: AppColors.primary,
      child: Stack(
        children: [
          ListView(children: model.exercises.map((exercise) => _ExerciseWidget(exercise: exercise)).toList()),
          Positioned(
            bottom: 16.0,
            right: 16.0,
            child: FloatingActionButton(
              onPressed: model.createExercise,
              child: Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExerciseWidget extends StatelessWidget {
  final Exercise exercise;

  const _ExerciseWidget({@required this.exercise});

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<CreateRoutineViewmodel>(context);
    return Dismissible(
      key: ValueKey(exercise),
      onDismissed: (_) => model.deleteExercise(exercise),
      background: Container(color: AppColors.accent900),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) async => await showDialog(context: context, builder: _buildConfirmDialog),
      child: InkWell(
        onTap: () {},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(exercise.name, style: getTextStyle(TextStyles.h2)),
                  Icon(Icons.chevron_right),
                ],
              ),
            ),
            Divider(),
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmDialog(BuildContext context) {
    final buttonStyle = getTextStyle(TextStyles.button).copyWith(color: AppColors.accent);
    return AlertDialog(
      backgroundColor: AppColors.primary,
      title: Text('Confirm', style: getTextStyle(TextStyles.h1)),
      content: Text(
        'Are you sure you wish to delete the "${exercise.name}" exercise?',
        style: getTextStyle(TextStyles.body1),
      ),
      actions: [
        FlatButton(
          onPressed: () => Router.pop(true),
          child: Text("DELETE", style: buttonStyle),
        ),
        FlatButton(
          onPressed: () => Router.pop(false),
          child: Text("CANCEL", style: buttonStyle),
        ),
      ],
    );
  }
}
