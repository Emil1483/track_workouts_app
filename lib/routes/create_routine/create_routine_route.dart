import 'package:flutter/material.dart';
import 'package:track_workouts/handlers/router.dart';
import 'package:track_workouts/style/theme.dart';
import 'package:track_workouts/ui_elements/main_button.dart';
import 'package:track_workouts/ui_elements/main_text_field.dart';
import 'package:track_workouts/utils/validation_utils.dart';

class CreateRoutine extends StatelessWidget {
  static const String routeName = 'createRoutine';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TextFieldAppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(),
          ),
          MainButton(
            onTaps: [() {}],
            texts: ['save'],
          ),
        ],
      ),
    );
  }
}

class TextFieldAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primary,
      elevation: 4.0,
      child: Container(
        alignment: Alignment.bottomCenter,
        padding: EdgeInsets.only(bottom: 12.0, right: 18.0),
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
                labelText: 'Workout Name',
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
  Size get preferredSize => Size.fromHeight(92.0);
}
