import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:track_workouts/handlers/router.dart';
import 'package:track_workouts/style/theme.dart';

class ExerciseDetailsAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String exerciseName;

  const ExerciseDetailsAppBar({this.exerciseName});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primary,
      elevation: 4.0,
      child: SafeArea(
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(right: 18.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 4.0),
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Router.pop(),
              ),
              SizedBox(width: 12.0),
              Expanded(
                child: AutoSizeText(
                  exerciseName,
                  style: getTextStyle(TextStyles.h1),
                  maxLines: 2,
                  minFontSize: 16.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(98.0);
}
