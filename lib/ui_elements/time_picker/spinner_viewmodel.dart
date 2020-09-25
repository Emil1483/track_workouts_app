import 'package:flutter/material.dart';
import 'package:track_workouts/routes/base/base_model.dart';

class SpinnerViewmodel extends BaseModel {
  final ScrollController controller;
  final double itemHeight;

  int _selectedIndex = 0;

  SpinnerViewmodel({@required this.controller, @required this.itemHeight});

  get selectedIndex => _selectedIndex;

  bool onScrollNotification(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      controller.position.activity.velocity;
      final newIndex = (controller.offset / itemHeight).round() + 1;
      if (newIndex != _selectedIndex) {
        _selectedIndex = newIndex;
        notifyListeners();
      }
    } else if (notification is UserScrollNotification) {
      if (notification.direction.index == 0) {
        if (controller.offset == 0) {
          controller.jumpTo(itemHeight * 60 * 10);
        }
      }
    }
    return false;
  }
}
