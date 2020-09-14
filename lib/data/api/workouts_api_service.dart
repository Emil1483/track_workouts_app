import 'package:chopper/chopper.dart';
import 'package:track_workouts/constants/api_info.dart';
import 'package:track_workouts/data/api/response_error_interceptor.dart';

part 'workouts_api_service.chopper.dart';

@ChopperApi(baseUrl: '/workouts')
abstract class WorkoutsApiService extends ChopperService {
  @Get()
  Future<Response> getWorkoutsData(@Query('to') String untilDate);

  @Get(path: '/{id}')
  Future<Response> getWorkoutData(@Path('id') String id);

  @Post()
  Future<Response> postWorkout(
    @Body() Map<String, dynamic> body,
  );

  static WorkoutsApiService create() {
    final client = ChopperClient(
      baseUrl: ApiInfo.API_PATH,
      services: [
        _$WorkoutsApiService(),
      ],
      converter: JsonConverter(),
      interceptors: [ResponseMobileInterceptor()],
    );
    return _$WorkoutsApiService(client);
  }
}
