import 'package:flutter/material.dart';
import 'package:track_workouts/style/theme.dart';

class MainButton extends StatelessWidget {
  final List<Function> onTaps;
  final List<String> texts;
  final BorderRadiusGeometry borderRadius;
  final bool primaryColor;
  final bool disabled;
  final bool loading;

  MainButton({
    @required this.onTaps,
    @required this.texts,
    this.borderRadius,
    this.primaryColor = false,
    this.disabled = false,
    this.loading = false,
  }) : assert(onTaps.length == texts.length);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.0,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: _gradient),
        borderRadius: borderRadius,
      ),
      child: Material(
        color: AppColors.transparent,
        child: loading
            ? Center(
                child: Container(
                  width: 24.0,
                  height: 24.0,
                  child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.white)),
                ),
              )
            : Row(
                children: _mapOnTaps(
                  (onTap, text) => Expanded(
                    child: InkWell(
                      key: ValueKey(onTap),
                      onTap: disabled ? null : onTap,
                      borderRadius: borderRadius,
                      child: Center(
                        child: Text(
                          text.toUpperCase(),
                          style: getTextStyle(TextStyles.button),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  List<Color> get _gradient {
    if (disabled) return [AppColors.disabled, AppColors.white300];

    if (!primaryColor) return [AppColors.accent, AppColors.accent900];

    return [Color.lerp(AppColors.primary, AppColors.white, 0.05), AppColors.primary];
  }

  List<Widget> _mapOnTaps(Widget Function(Function, String) function) {
    final List<Widget> result = [];
    for (int i = 0; i < texts.length; i++) {
      result.add(function(onTaps[i], texts[i]));
      if (i < texts.length - 1)
        result.add(Padding(
          padding: EdgeInsets.symmetric(vertical: 12.0),
          child: VerticalDivider(),
        ));
    }
    return result;
  }
}
