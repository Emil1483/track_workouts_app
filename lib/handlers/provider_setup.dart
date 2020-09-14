import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:track_workouts/data/api/workouts_api_service.dart';
import 'package:track_workouts/data/repositories/workouts_repository.dart';
import 'package:track_workouts/data/services/workouts_service.dart';

List<SingleChildWidget> getProviders() {
  return [
    Provider<WorkoutsService>(
      create: (_) => WorkoutsService(WorkoutsRepository(WorkoutsApiService.create())),
      dispose: (_, service) => service.dispose(),
    ),
  ];
}
