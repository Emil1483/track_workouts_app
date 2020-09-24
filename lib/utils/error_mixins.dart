import 'package:flutter/material.dart';
import 'package:track_workouts/ui_elements/modal_bottom.dart';

mixin ErrorStateless on StatelessWidget {
  final _ContextWrapper contextWrapper = _ContextWrapper();

  @mustCallSuper
  @override
  Widget build(BuildContext context) {
    contextWrapper.context = context;
    return null;
  }

  void onError(String message) {
    ModalBottom.showErrorModal(contextWrapper.context, message);
  }
}

class _ContextWrapper {
  BuildContext context;
}
