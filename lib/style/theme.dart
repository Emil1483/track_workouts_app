import 'package:flutter/material.dart';

ThemeData get appTheme => ThemeData(
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.black500,
      fontFamily: 'Proxima',
      accentColor: AppColors.accent,
    );

class AppColors {
  static const primary = Color(0xFF0a1a2a);

  static const accent = Color(0xFFfa5d3e);
  static const accent900 = Color(0xFFac1f04);

  static const black200 = Color(0xFF303436);
  static const black500 = Color(0xFF1f2223);
  static const black900 = Color(0xFF181a1b);

  static const white = Color(0xFFFFFFFF);
}

enum TextStyles { h1, body1, caption }

TextStyle getTextStyle(TextStyles textStyle) {
  switch (textStyle) {
    case TextStyles.h1:
      return TextStyle(
        fontSize: 24,
        color: AppColors.white,
        fontWeight: FontWeight.w700,
        fontStyle: FontStyle.italic,
        letterSpacing: 1,
      );
    case TextStyles.body1:
      return TextStyle(
        fontSize: 14,
        color: AppColors.white,
        letterSpacing: 0.5,
      );
    case TextStyles.caption:
      return TextStyle(
        fontSize: 16.0,
        color: AppColors.white,
        letterSpacing: 0.7,
        fontWeight: FontWeight.w600,
      );
  }
  return null;
}
