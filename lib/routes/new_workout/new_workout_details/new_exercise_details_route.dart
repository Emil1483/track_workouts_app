import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:provider/provider.dart';
import 'package:track_workouts/data/model/routine/routine.dart';
import 'package:track_workouts/data/model/suggested_weight/suggested_weight.dart';
import 'package:track_workouts/data/model/workouts/workout/workout.dart';
import 'package:track_workouts/routes/base/base_widget.dart';
import 'package:track_workouts/routes/new_workout/new_workout_details/new_exercise_details_viewmodel.dart';
import 'package:track_workouts/routes/new_workout/new_workout_details/time_panel/timer_panel.dart';
import 'package:track_workouts/style/theme.dart';
import 'package:track_workouts/ui_elements/confirm_dialog.dart';
import 'package:track_workouts/ui_elements/dismiss_background.dart';
import 'package:track_workouts/ui_elements/main_button.dart';
import 'package:track_workouts/ui_elements/main_text_field.dart';
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
        context,
        exercise: exercise,
        onError: onError,
      ),
      onModelReady: (model) async {
        model.initializeActiveSets();
        model.getSuggestedWeight();
        await model.buildTextControllers();
      },
      onDispose: (model) => model.dispose(),
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

        return Scaffold(
          appBar: AppBar(title: AutoSizeText(exercise.name, maxLines: 1)),
          body: TimePanelWrapper(
            child: ListView(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              children: [
                if (model.suggestedWeight.isNotEmpty) _SuggestedWeight(model.suggestedWeight),
                ...setWidgets,
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SuggestedWeight extends StatelessWidget {
  final SuggestedWeight suggestedWeight;

  const _SuggestedWeight(this.suggestedWeight);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Column(
        children: [
          Text(
            'Suggested weight',
            style: getTextStyle(TextStyles.subtitle1),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 6.0),
          Text(
            _weightSuggestion,
            style: getTextStyle(TextStyles.caption),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 18.0),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 52.0),
            child: Divider(thickness: 0.6),
          ),
        ],
      ),
    );
  }

  String get _weightSuggestion {
    final from = suggestedWeight.min;
    final to = suggestedWeight.max;

    if (from == null) return 'less than $to kg';

    if (to == null) return 'more than $from kg';

    if (from > to) return '$from kg';

    if (from == to) return '$from kg';

    return 'from $from to $to kg';
    // String result = suggestedWeight.isTooMuch ? 'less than ' : '';
    // result += suggestedWeight.value.withMaxTwoDecimals;
    // result += ' kg';
    // return result;
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
