import 'package:flutter/material.dart';
import 'package:track_workouts/style/theme.dart';

class DismissBackground extends StatelessWidget {
  final double rightPadding;

  const DismissBackground({@required this.rightPadding});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: rightPadding),
      color: AppColors.accent900,
      alignment: Alignment.centerRight,
      child: Icon(Icons.delete),
    );
  }
}
