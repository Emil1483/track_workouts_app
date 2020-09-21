import 'package:flutter/material.dart';

ThemeData get appTheme => ThemeData(
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.black900,
      fontFamily: 'Proxima',
      accentColor: AppColors.accent,
      appBarTheme: AppBarTheme(textTheme: TextTheme(headline6: getTextStyle(TextStyles.h1))),
      dividerTheme: DividerThemeData(
        color: AppColors.transparentWhite,
        space: 0.0,
      ),
      iconTheme: IconThemeData(
        color: AppColors.white,
      ),
    );

class AppColors {
  static const primary = Color(0xFF0a1a2a);
  static const primary700 = Color(0xFF102942);

  static const accent = Color(0xFFfa5d3e);
  static const accent900 = Color(0xFFac1f04);

  static const black200 = Color(0xFF303436);
  static const black500 = Color(0xFF1f2223);
  static const black900 = Color(0xFF181a1b);

  static const white = Color(0xFFFFFFFF);
  static const white300 = Color(0xFF727272);

  static const transparentWhite = Color(0x33FFFFFF);

  static const disabled = Color(0xFF999999);

  static const transparent = Color(0x00000000);
}

enum TextStyles { h1, h2, h3, body1, body2, subtitle1, button, caption }

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
    case TextStyles.h2:
      return TextStyle(
        fontSize: 18,
        color: AppColors.white,
        fontWeight: FontWeight.w700,
        letterSpacing: 1,
      );
    case TextStyles.h3:
      return TextStyle(
        fontSize: 16,
        color: AppColors.white,
        fontWeight: FontWeight.w700,
        fontStyle: FontStyle.italic,
        letterSpacing: 0.8,
      );
    case TextStyles.body1:
      return TextStyle(
        fontSize: 14,
        color: AppColors.white,
        letterSpacing: 0.5,
      );
    case TextStyles.body2:
      return TextStyle(
        fontSize: 14,
        color: AppColors.white300,
        letterSpacing: 0.75,
        fontWeight: FontWeight.w600,
      );
    case TextStyles.subtitle1:
      return TextStyle(
        fontSize: 16,
        color: AppColors.white,
        letterSpacing: 0.6,
        fontStyle: FontStyle.italic,
      );
    case TextStyles.button:
      return TextStyle(
        fontSize: 16,
        color: AppColors.white,
        letterSpacing: 0.7,
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.italic,
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
