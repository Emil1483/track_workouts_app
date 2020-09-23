import 'package:flutter/material.dart';
import 'package:track_workouts/style/theme.dart';

class MainButton extends StatelessWidget {
  final Function onTap;
  final String text;
  final BorderRadiusGeometry borderRadius;

  MainButton({@required this.onTap, @required this.text, this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.0,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [AppColors.accent, AppColors.accent900]),
        borderRadius: borderRadius,
      ),
      child: Material(
        color: AppColors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: borderRadius,
          child: Center(
            child: Text(
              text.toUpperCase(),
              style: getTextStyle(TextStyles.button),
            ),
          ),
        ),
      ),
    );
  }
}
