import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:track_workouts/handlers/error/failure.dart';

class ResponseMobileInterceptor implements ResponseInterceptor {
  @override
  FutureOr<Response> onResponse(Response response) {
    if (!response.isSuccessful) {
      final errorText = (response.body ?? {})['error'];
      if (errorText != null) throw Failure(errorText);
      print([response.statusCode, response.body]);
      throw Failure();
    }
    return response;
  }
}
