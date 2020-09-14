import 'package:chopper/chopper.dart';
import 'package:track_workouts/constants/api_info.dart';

part 'workouts_api_repository.chopper.dart';

@ChopperApi(baseUrl: '/workouts')
abstract class WorkoutsApiRepository extends ChopperService {
  @Get()
  Future<Response> getWorkoutsData(@Query('to') String untilDate);

  @Get(path: '/{id}')
  Future<Response> getWorkoutData(@Path('id') String id);

  @Post()
  Future<Response> postWorkout(
    @Body() Map<String, dynamic> body,
  );

  static WorkoutsApiRepository create() {
    final client = ChopperClient(
      baseUrl: ApiInfo.API_PATH,
      services: [
        _$WorkoutsApiRepository(),
      ],
      converter: JsonConverter(),
    );
    return _$WorkoutsApiRepository(client);
  }
}
