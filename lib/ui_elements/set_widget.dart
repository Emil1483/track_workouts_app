import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:track_workouts/data/model/workouts/workout/workout.dart';
import 'package:track_workouts/style/theme.dart';
import 'package:track_workouts/ui_elements/colored_container.dart';
import 'package:track_workouts/utils/map_utils.dart';
import 'package:track_workouts/utils/duration_utils.dart';

class SetWidget extends StatelessWidget {
  final Map<AttributeName, double> attributes;
  final int index;
  final Function onLongPress;

  const SetWidget({@required this.attributes, @required this.index, this.onLongPress});

  @override
  Widget build(BuildContext context) {
    Widget breakWidget;
    final filteredSet = attributes.copy()
      ..removeWhere((name, value) {
        if (name == AttributeName.pre_break) {
          breakWidget = _BreakWidget(duration: Duration(seconds: value.round()));
          return true;
        }
        return false;
      });
    final borderRadius = BorderRadius.circular(8.0);
    return Column(
      children: [
        breakWidget ?? Container(),
        Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: Material(
            color: AppColors.black500,
            borderRadius: borderRadius,
            child: InkWell(
              borderRadius: borderRadius,
              onLongPress: onLongPress,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: Text('Set #${index + 1}', style: getTextStyle(TextStyles.h2))),
                      if (filteredSet.isNotEmpty) VerticalDivider(width: 24.0, thickness: 0.65),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: filteredSet.entries.where((entry) => entry.value != null).map(_buildSetEntry).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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
