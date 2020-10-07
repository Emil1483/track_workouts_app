import 'package:flutter/material.dart';
import 'package:track_workouts/handlers/router.dart';
import 'package:track_workouts/style/theme.dart';

class ConfirmDialog extends StatelessWidget {
  final String contentText;

  const ConfirmDialog({@required this.contentText});

  static Future<bool> showConfirmDialog(BuildContext context, String contentString) {
    return showDialog(context: context, builder: (_) => ConfirmDialog(contentText: contentString));
  }

  @override
  Widget build(BuildContext context) {
    final buttonStyle = getTextStyle(TextStyles.button).copyWith(color: AppColors.accent);
    return AlertDialog(
      backgroundColor: AppColors.primary,
      title: Text('Confirm', style: getTextStyle(TextStyles.h1)),
      content: Text(contentText, style: getTextStyle(TextStyles.body1)),
      actions: [
        FlatButton(
          onPressed: () => Router.pop(true),
          child: Text("DELETE", style: buttonStyle),
        ),
        FlatButton(
          onPressed: () => Router.pop(false),
          child: Text("CANCEL", style: buttonStyle),
        ),
      ],
    );
  }
}
