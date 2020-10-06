import 'package:flutter/material.dart';
import 'package:track_workouts/style/theme.dart';

class MainTextField extends StatelessWidget {
  final String labelText;
  final String Function(String) validator;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final TextStyles textStyle;

  const MainTextField({
    @required this.labelText,
    @required this.validator,
    this.keyboardType,
    this.controller,
    this.textStyle = TextStyles.caption,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: getTextStyle(textStyle),
      validator: validator,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: getTextStyle(textStyle),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.accent, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.white, width: 0.5),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.error, width: 1.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.error, width: 2.0),
        ),
      ),
    );
  }
}
