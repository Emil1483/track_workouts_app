import 'package:flutter/material.dart';
import 'package:track_workouts/handlers/router.dart';
import 'package:track_workouts/style/theme.dart';
import 'package:track_workouts/ui_elements/main_text_field.dart';
import 'package:track_workouts/utils/validation_utils.dart';

class TextFieldAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String labelText;

  TextFieldAppBar({@required this.labelText});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primary,
      elevation: 4.0,
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(bottom: 12.0, top: 24.0, right: 18.0),
        child: Row(
          children: [
            SizedBox(width: 4.0),
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Router.pop(),
            ),
            SizedBox(width: 12.0),
            Expanded(
              child: MainTextField(
                labelText: labelText,
                validator: Validation.notEmpty,
                textStyle: TextStyles.h1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(98.0);
}
