import 'dart:async';
import 'dart:convert';

import 'package:chopper/chopper.dart';
import 'package:track_workouts/handlers/error/error_handler.dart';
import 'package:track_workouts/handlers/error/failure.dart';

class ResponseMobileInterceptor implements ResponseInterceptor {
  @override
  FutureOr<Response> onResponse(Response response) {
    if (!response.isSuccessful) {
      final message = jsonDecode(response.error)['error'];
      throw Failure(message ?? ErrorHandler.unknownError);
    }
    return response;
  }
}
