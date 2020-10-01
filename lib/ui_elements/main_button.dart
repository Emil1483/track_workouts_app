import 'package:flutter/material.dart';
import 'package:track_workouts/style/theme.dart';

class MainButton extends StatelessWidget {
  final Function onTap;
  final String text;
  final BorderRadiusGeometry borderRadius;
  final bool primaryColor;

  MainButton({@required this.onTap, @required this.text, this.borderRadius, this.primaryColor = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.0,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: _gradient),
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

  List<Color> get _gradient {
    if (onTap == null) return [AppColors.disabled, AppColors.white300];

    if (!primaryColor) return [AppColors.accent, AppColors.accent900];

    return [Color.lerp(AppColors.primary, AppColors.white, 0.05), AppColors.primary];
  }
}
