import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:track_workouts/data/model/workouts/workout/workout.dart';
import 'package:track_workouts/style/theme.dart';
import 'package:track_workouts/ui_elements/colored_container.dart';
import 'package:track_workouts/utils/map_utils.dart';
import 'package:track_workouts/utils/duration_utils.dart';

class SetWidget extends StatelessWidget {
  static const double verticalPadding = 8.0;

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
          if (value > 0) {
            breakWidget = BreakWidget(duration: Duration(seconds: value.round()));
          } else {
            breakWidget = SizedBox(height: 12.0);
          }
          return true;
        }
        return false;
      });
    final borderRadius = BorderRadius.circular(8.0);
    return Column(
      children: [
        breakWidget ?? Container(),
        Padding(
          padding: EdgeInsets.symmetric(vertical: verticalPadding),
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

class BreakWidget extends StatelessWidget {
  final Duration duration;
  final Function onTap;

  const BreakWidget({@required this.duration, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ColoredContainer(
      fill: onTap == null,
      onTap: onTap,
      child: AutoSizeText(
        duration?.breakText ?? 'Set Break',
        maxLines: 1,
        style: getTextStyle(TextStyles.h3),
      ),
    );
  }
}
