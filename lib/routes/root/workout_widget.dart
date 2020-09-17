import 'package:flutter/material.dart';
import 'package:track_workouts/routes/root/color_utils.dart';
import 'package:track_workouts/routes/root/root_viewmodel.dart';
import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:track_workouts/utils/date_time_utils.dart';
import 'package:track_workouts/style/theme.dart';

class WorkoutWidget extends StatelessWidget {
  final FormattedWorkout workout;

  const WorkoutWidget({@required this.workout});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 14.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                EasyRichText(
                  '●  ' + workout.date.formatDayMonthDate,
                  defaultStyle: getTextStyle(TextStyles.subtitle1),
                  patternList: [
                    EasyRichTextPattern(
                      targetString: '(st|nd|rd|th)',
                      superScript: true,
                      matchWordBoundaries: false,
                      style: getTextStyle(TextStyles.subtitle1),
                    ),
                    EasyRichTextPattern(
                      targetString: '●',
                      matchWordBoundaries: false,
                      style: getTextStyle(TextStyles.subtitle1).copyWith(color: ColorUtils.getColorFrom(workout)),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 6.0),
                  child: Icon(Icons.chevron_right),
                ),
              ],
            ),
          ),
          Divider(),
        ],
      ),
    );
  }
}
