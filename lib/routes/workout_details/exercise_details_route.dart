import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:track_workouts/data/model/workouts/workout/workout.dart';
import 'package:track_workouts/routes/base/base_widget.dart';
import 'package:track_workouts/routes/root/root_viewmodel.dart';
import 'package:track_workouts/routes/workout_details/exercise_details_viewmodel.dart';
import 'package:track_workouts/style/theme.dart';
import 'package:track_workouts/ui_elements/colored_container.dart';
import 'package:track_workouts/utils/duration_utils.dart';
import 'package:track_workouts/utils/map_utils.dart';

class ExerciseDetailsRoute extends StatelessWidget {
  static const String routeName = 'exerciseDetails';

  final FormattedExercise exercise;

  const ExerciseDetailsRoute({@required this.exercise});

  @override
  Widget build(BuildContext context) {
    return BaseWidget<ExerciseDetailsViewmodel>(
      model: ExerciseDetailsViewmodel(exercise: exercise),
      builder: (context, model, child) {
        final List<Widget> setWidgets = [];
        model.forEachFormattedSet((formattedSet, index) => setWidgets.add(_buildSetWidget(formattedSet, index)));

        return Scaffold(
          appBar: AppBar(title: Text(model.exerciseName)),
          body: ListView(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            children: [
              _RepeatedAttributes(attributes: model.repeatedAttributes),
              ...setWidgets,
            ],
          ),
        );
      },
    );
  }

  Widget _buildSetWidget(Map<AttributeName, double> formattedSet, int index) {
    Widget breakWidget;
    final filteredSet = formattedSet.copy()
      ..removeWhere((name, value) {
        if (name == AttributeName.pre_break) {
          breakWidget = _BreakWidget(duration: Duration(seconds: value.round()));
          return true;
        }
        return false;
      });
    return Column(
      children: [
        breakWidget ?? Container(),
        Container(
          margin: EdgeInsets.only(top: 8.0),
          padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          decoration: BoxDecoration(
            color: AppColors.black500,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: Text('Set #${index + 1}', style: getTextStyle(TextStyles.h2))),
                if (filteredSet.isNotEmpty) VerticalDivider(width: 24.0, thickness: 0.65),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: filteredSet.entries.map(_buildSetEntry).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSetEntry(MapEntry<AttributeName, double> entry) {
    final name = entry.key.formattedString;
    final value = entry.formattedValueString;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          name,
          style: getTextStyle(TextStyles.body1),
        ),
        Text(
          value,
          style: getTextStyle(TextStyles.body1).copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class _RepeatedAttributes extends StatelessWidget {
  final Map<AttributeName, double> attributes;

  const _RepeatedAttributes({@required this.attributes});

  @override
  Widget build(BuildContext context) {
    if (attributes.isEmpty) return Container();

    return Column(
      children: [
        SizedBox(height: 16.0),
        Wrap(
          alignment: WrapAlignment.center,
          children: attributes.entries.map((attribute) {
            final name = attribute.key.formattedString;
            final value = attribute.formattedValueString;
            return ColoredContainer(
              margin: EdgeInsets.symmetric(horizontal: 3.0, vertical: 3.0),
              child: Text('$name: $value', style: getTextStyle(TextStyles.caption)),
            );
          }).toList(),
        ),
        Divider(height: 24.0),
      ],
    );
  }
}

class _BreakWidget extends StatelessWidget {
  final Duration duration;

  const _BreakWidget({@required this.duration});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: ColoredContainer(
        child: AutoSizeText(
          '${duration.formatMinuteSeconds} break',
          maxLines: 1,
          style: getTextStyle(TextStyles.h3),
        ),
      ),
    );
  }
}
