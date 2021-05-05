import 'dart:async';

import 'package:flutter/material.dart';
import 'package:track_workouts/handlers/error/error_handler.dart';
import 'package:track_workouts/handlers/error/failure.dart';

abstract class MustHandleErrors<T> {
  final Function function;

  MustHandleErrors(this.function);
}

class MustHandleErrors0<T> extends MustHandleErrors<T> {
  MustHandleErrors0(FutureOr<T> Function() f) : super(f);

  Future<T> call({@required Function(Failure) onFailure, @required Function(T) onSuccess}) async {
    return await ErrorHandler.handleErrors<T>(
      run: () async => await function(),
      onFailure: onFailure,
      onSuccess: onSuccess,
    );
  }
}

class MustHandleErrors1<A, T> extends MustHandleErrors<T> {
  MustHandleErrors1(FutureOr<T> Function(A) f) : super(f);

  Future<T> call(A x,
      {@required Function(Failure) onFailure, @required Function(T) onSuccess}) async {
    return await ErrorHandler.handleErrors<T>(
      run: () async => await function(x),
      onFailure: onFailure,
      onSuccess: onSuccess,
    );
  }
}
