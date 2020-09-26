import 'package:flutter/material.dart';
import 'package:track_workouts/style/theme.dart';

class ColoredContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets margin;
  final Function onTap;
  final bool fill;

  ColoredContainer({@required this.child, this.margin, this.onTap, this.fill = true});

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(64.0);
    Color fillColor = AppColors.accent900;
    if (!fill) fillColor = fillColor.withAlpha(92);
    return Container(
      margin: margin ?? EdgeInsets.symmetric(vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        color: fillColor,
        border: Border.all(color: AppColors.accent900, width: 1.0),
      ),
      child: Material(
        color: AppColors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: borderRadius,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
            child: child,
          ),
        ),
      ),
    );
  }
}
