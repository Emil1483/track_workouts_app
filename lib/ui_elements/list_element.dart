import 'package:flutter/material.dart';
import 'package:track_workouts/style/theme.dart';

class ListElement extends StatelessWidget {
  final Widget mainWidget;
  final Function onTap;
  final bool centered;
  final Color color;

  const ListElement({
    @required this.mainWidget,
    @required this.onTap,
    this.centered = false,
    this.color = AppColors.transparent,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 14.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: centered ? CrossAxisAlignment.center : CrossAxisAlignment.start,
                children: [
                  Expanded(child: mainWidget),
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
      ),
    );
  }
}
