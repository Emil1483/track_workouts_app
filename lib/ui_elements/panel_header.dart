import 'package:flutter/material.dart';
import 'package:track_workouts/style/theme.dart';

class PanelHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(top: 13.0),
      alignment: Alignment.topCenter,
      child: Container(
        width: 35.0,
        height: 2.0,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
    );
  }
}
