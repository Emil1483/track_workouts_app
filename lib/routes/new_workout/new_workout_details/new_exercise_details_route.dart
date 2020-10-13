import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:provider/provider.dart';
import 'package:track_workouts/data/model/routine/routine.dart';
import 'package:track_workouts/data/model/workouts/workout/workout.dart';
import 'package:track_workouts/data/services/new_workout_service.dart';
import 'package:track_workouts/routes/base/base_widget.dart';
import 'package:track_workouts/routes/new_workout/new_workout_details/new_exercise_details_viewmodel.dart';
import 'package:track_workouts/routes/new_workout/new_workout_details/time_panel/timer_panel.dart';
import 'package:track_workouts/style/theme.dart';
import 'package:track_workouts/ui_elements/confirm_dialog.dart';
import 'package:track_workouts/ui_elements/dismiss_background.dart';
import 'package:track_workouts/ui_elements/main_button.dart';
import 'package:track_workouts/ui_elements/main_text_field.dart';
import 'package:track_workouts/ui_elements/panel.dart';
import 'package:track_workouts/ui_elements/panel_header.dart';
import 'package:track_workouts/ui_elements/set_widget.dart';
import 'package:track_workouts/utils/error_mixins.dart';
import 'package:track_workouts/utils/map_utils.dart';
import 'package:track_workouts/utils/num_utils.dart';

class NewExerciseDetailsRoute extends StatelessWidget with ErrorStateless {
  static const String routeName = 'newWorkoutDetails';

  final Exercise exercise;

  NewExerciseDetailsRoute({@required this.exercise});

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BaseWidget<NewExerciseDetailsViewmodel>(
      model: NewExerciseDetailsViewmodel(
        exercise: exercise,
        onError: onError,
        newWorkoutService: Provider.of<NewWorkoutService>(context),
      ),
      onModelReady: (model) async {
        model.initializeActiveSets();
        await model.buildTextControllers();
      },
      builder: (context, model, child) {
        final List<Widget> setWidgets = [];
        for (int i = 0; i < model.activeSets.length; i++) {
          final activeSet = model.activeSets[i];
          if (activeSet.completed) {
            setWidgets.add(
              Dismissible(
                key: ValueKey(activeSet),
                onDismissed: (_) => model.deleteSet(i),
                background: DismissBackground(rightPadding: 12.0),
                direction: DismissDirection.endToStart,
                confirmDismiss: (_) => ConfirmDialog.showConfirmDialog(
                  context,
                  'Are you sure you wish to delete set #$i?',
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: SetWidget(
                    attributes: activeSet.attributes,
                    index: i,
                    onLongPress: () => model.editSet(i),
                  ),
                ),
              ),
            );
          } else {
            setWidgets.add(_ActiveSetWidget(attributes: activeSet.attributes));
          }
        }
        setWidgets.add(SizedBox(height: 64.0));

        final panelHeight = 52.0;
        final borderRadius = 18.0;

        return Scaffold(
          appBar: AppBar(title: AutoSizeText(exercise.name, maxLines: 1)),
          body: SlidingUpPanel(
            controller: model.panelController,
            color: AppColors.black950,
            minHeight: panelHeight,
            parallaxEnabled: true,
            backdropTapClosesPanel: true,
            backdropEnabled: true,
            borderRadius: BorderRadius.vertical(top: Radius.circular(borderRadius)),
            header: PanelHeader(),
            body: Padding(
              padding: EdgeInsets.only(bottom: panelHeight - borderRadius),
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                children: setWidgets,
              ),
            ),
            panel: TimePanel(),
          ),
        );
      },
    );
  }
}

class _ActiveSetWidget extends StatelessWidget {
  final Map<AttributeName, double> attributes;

  const _ActiveSetWidget({@required this.attributes});

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<NewExerciseDetailsViewmodel>(context, listen: false);

    final formattedAttributes = attributes.copy();

    Widget breakWidget;
    if (formattedAttributes.containsKey(AttributeName.pre_break)) {
      final duration = formattedAttributes[AttributeName.pre_break].toDurationFromSeconds();
      formattedAttributes.remove(AttributeName.pre_break);

      breakWidget = BreakWidget(
        duration: duration,
        onTap: () => model.pickPreBreak(context),
      );
    }

    final borderRadius = 8.0;

    return Column(
      children: [
        breakWidget ?? Container(),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: SetWidget.verticalPadding),
          decoration: BoxDecoration(
            color: AppColors.black500,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: Column(
            children: [
              _AttributesTextFields(formattedAttributes: formattedAttributes),
              MainButton(
                onTaps: [() => model.saveSets()],
                texts: ['Save'],
                loading: model.loading,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(borderRadius),
                  bottomRight: Radius.circular(borderRadius),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AttributesTextFields extends StatelessWidget {
  final Map<AttributeName, double> formattedAttributes;

  const _AttributesTextFields({@required this.formattedAttributes});

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<NewExerciseDetailsViewmodel>(context, listen: false);
    return Form(
      key: model.formKey,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          children: formattedAttributes.entries.map(
            (attribute) {
              final AttributeName attributeName = attribute.key;
              final name = attributeName.formattedString;
              final unit = attributeName.unit;
              final unitString = unit == null ? '' : ' (${unit.string})';
              return Padding(
                padding: EdgeInsets.only(bottom: 14.0),
                child: MainTextField(
                  controller: model.getControllerFrom(attributeName),
                  validator: (value) => model.validateAttribute(attributeName, value),
                  labelText: name + unitString,
                  keyboardType: TextInputType.number,
                ),
              );
            },
          ).toList(),
        ),
      ),
    );
  }
}
