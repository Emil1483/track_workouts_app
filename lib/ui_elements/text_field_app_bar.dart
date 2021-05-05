import 'package:flutter/material.dart';
import 'package:track_workouts/handlers/router.dart';
import 'package:track_workouts/style/theme.dart';
import 'package:track_workouts/ui_elements/main_text_field.dart';
import 'package:track_workouts/utils/validation_utils.dart';

class TextFieldAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController controller;
  final String labelText;

  TextFieldAppBar({this.controller, @required this.labelText});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primary,
      elevation: 4.0,
      child: SafeArea(
        child: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(bottom: 6.0, top: 6.0, right: 18.0),
          child: Row(
            children: [
              SizedBox(width: 4.0),
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => MRouter.pop(),
              ),
              SizedBox(width: 12.0),
              Expanded(
                child: MainTextField(
                  controller: controller,
                  labelText: labelText,
                  validator: Validation.notEmpty,
                  textStyle: TextStyles.h1,
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
