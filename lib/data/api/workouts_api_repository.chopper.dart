// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workouts_api_repository.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations
class _$WorkoutsApiRepository extends WorkoutsApiRepository {
  _$WorkoutsApiRepository([ChopperClient client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = WorkoutsApiRepository;

  @override
  Future<Response<dynamic>> getWorkoutsData(String untilDate) {
    final $url = '/workouts';
    final $params = <String, dynamic>{'to': untilDate};
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getWorkoutData(String id) {
    final $url = '/workouts/$id';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> postWorkout(Map<String, dynamic> body) {
    final $url = '/workouts';
    final $body = body;
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<dynamic, dynamic>($request);
  }
}
