import 'package:flutter/material.dart';
import 'package:track_workouts/style/theme.dart';

class ListElement extends StatelessWidget {
  final Widget mainWidget;
  final Function onTap;
  final Function onLongPress;
  final bool centered;
  final Color color;
  final bool draggable;
  final double dividerThickness;
  final Widget icon;

  const ListElement({
    @required this.mainWidget,
    @required this.onTap,
    this.onLongPress,
    this.centered = false,
    this.color = AppColors.transparent,
    this.draggable = false,
    this.dividerThickness = 0.4,
    this.icon = const Icon(Icons.chevron_right),
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
                  onLongPress: onLongPress,
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
                          child: Opacity(
                            opacity: draggable ? 0.0 : 1.0,
                            child: icon,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (draggable)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: icon,
                ),
            ],
          ),
          Divider(thickness: dividerThickness),
        ],
      ),
    );
  }
}
