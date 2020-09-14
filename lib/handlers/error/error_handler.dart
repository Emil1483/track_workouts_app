import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/cupertino.dart';

import 'failure.dart';

class ErrorHandler {
  static const String noInternet = 'could not connect to the internet';

  static const String unknownError = 'an error has occurred';

  static const String couldNotConnect = 'could not connect to the server';

  static Future catchCommonErrors(Function function, {bool checkInternet = true}) async {
    if (checkInternet && !await DataConnectionChecker().hasConnection) throw Failure(ErrorHandler.noInternet);
    try {
      return await function();
    } on Failure catch (failure) {
      throw (failure);
    } on SocketException {
      throw Failure(ErrorHandler.couldNotConnect);
    } catch (e, stacktrace) {
      print('error: $e');
      print(stacktrace);
      throw Failure();
    }
  }

  static Future handleErrors<T>({
    @required Future<T> Function() run,
    @required Function(Failure) onFailure,
    @required Function(T) onSuccess,
  }) async {
    await Task(run).attempt().mapLeftToFailure().run().then((either) async {
      await either.fold((failure) async => await onFailure(failure), (success) async => await onSuccess(success));
    });
  }

  static Future<Either<Failure, dynamic>> getEither<T>(Future<T> Function() run) =>
      Task<T>(run).attempt().mapLeftToFailure().run();
}

extension TaskX<T extends Either<Object, U>, U> on Task<T> {
  Task<Either<Failure, U>> mapLeftToFailure() {
    return this.map<Either<Failure, U>>(
      (either) => either.leftMap((obj) {
        try {
          return obj as Failure;
        } catch (e) {
          throw obj;
        }
      }),
    );
  }
}
