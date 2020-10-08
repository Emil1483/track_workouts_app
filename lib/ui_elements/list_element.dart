import 'package:flutter/material.dart';
import 'package:track_workouts/style/theme.dart';

class ListElement extends StatelessWidget {
  final Widget mainWidget;
  final Function onTap;
  final bool centered;
  final Color color;
  final bool draggable;
  final double dividerThickness;
  final IconData icon;

  const ListElement({
    @required this.mainWidget,
    @required this.onTap,
    this.centered = false,
    this.color = AppColors.transparent,
    this.draggable = false,
    this.dividerThickness = 0.4,
    this.icon = Icons.chevron_right,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: onTap,
                  borderRadius: draggable
                      ? BorderRadius.only(
                          topRight: Radius.circular(12.0),
                          bottomRight: Radius.circular(12.0),
                        )
                      : null,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 14.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: centered ? CrossAxisAlignment.center : CrossAxisAlignment.start,
                      children: [
                        Expanded(child: mainWidget),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 6.0),
                          child: draggable ? Container() : Icon(icon),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (draggable)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Icon(icon),
                ),
            ],
          ),
          Divider(thickness: dividerThickness),
        ],
      ),
    );
  }
}
