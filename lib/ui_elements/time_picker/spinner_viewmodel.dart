import 'package:flutter/material.dart';
import 'package:track_workouts/routes/base/base_model.dart';

class SpinnerViewmodel extends BaseModel {
  final ScrollController controller;
  final double itemHeight;
  final int interval;

  int _selectedIndex;

  SpinnerViewmodel({@required this.controller, @required this.itemHeight, @required this.interval})
      : _selectedIndex = (controller.initialScrollOffset / itemHeight).round() + 1;

  int get selectedIndex => _selectedIndex;

  bool onScrollNotification(ScrollNotification notification, BuildContext context) {
    if (notification is ScrollUpdateNotification) {
      final newIndex = (controller.offset / itemHeight).round() + 1;
      if (newIndex != _selectedIndex) {
        _selectedIndex = newIndex;
        Feedback.forLongPress(context);
        notifyListeners();
      }
    } else if (notification is UserScrollNotification) {
      if (notification.direction.index == 0) {
        if (controller.offset == 0) {
          controller.jumpTo(itemHeight * interval * 10);
        }
      }
    }
    return false;
  }

  int getClosestIndex(int index) {
    final offset = controller.offset;
    final currentIndex = (offset / itemHeight).round() + 1;
    final currentNormalizedIndex = currentIndex % (60 / interval);
    final normalizedIndex = index % (60 / interval);
    final diff = normalizedIndex - currentNormalizedIndex;
    return currentIndex + diff.round() - 1;
  }

  double getOffsetFromValue(int value) {
    final index = (value / interval).round();
    return getClosestIndex(index) * itemHeight;
  }

  void animateToOffset(double offset) => controller.animateTo(
        offset,
        duration: Duration(milliseconds: 200),
        curve: Curves.easeInOutCubic,
      );
  
  void jumpTo(int value) => controller.jumpTo(getOffsetFromValue(value));

  void animateToIndex(int index) => animateToOffset((index - 1) * itemHeight);
}
