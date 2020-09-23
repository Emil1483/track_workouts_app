import 'package:flutter/material.dart';
import 'package:track_workouts/style/theme.dart';

class ColoredContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets margin;
  final Function onTap;

  ColoredContainer({@required this.child, this.margin, this.onTap});

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(64.0);
    return Padding(
      padding: margin ?? EdgeInsets.symmetric(vertical: 12.0),
      child: Material(
        borderRadius: borderRadius,
        color: AppColors.accent900,
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
