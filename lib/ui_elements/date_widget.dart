import 'package:flutter/material.dart';
import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:track_workouts/utils/date_time_utils.dart';

class DateWidget extends StatelessWidget {
  final DateTime date;
  final TextStyle style;

  const DateWidget({@required this.date, @required this.style});

  @override
  Widget build(BuildContext context) {
    return EasyRichText(
      date.formatDayMonthDate,
      defaultStyle: style,
      patternList: [
        EasyRichTextPattern(
          targetString: '(st|nd|rd|th)',
          superScript: true,
          matchWordBoundaries: false,
          style: style,
        ),
      ],
    );
  }
}
