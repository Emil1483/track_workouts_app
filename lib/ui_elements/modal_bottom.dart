import 'package:flutter/material.dart';
import 'package:track_workouts/style/theme.dart';

class ModalBottom {
  static void showErrorModal(BuildContext context, String message) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.primary,
      builder: (context) => SizedBox(
        height: 128.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error, color: AppColors.error, size: 48.0),
            SizedBox(width: 16.0),
            Text(
              message,
              textAlign: TextAlign.center,
              style: getTextStyle(TextStyles.caption),
            ),
          ],
        ),
      ),
    );
  }
}
