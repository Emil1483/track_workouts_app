import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:track_workouts/data/api/workouts_api_repository.dart';
import 'package:track_workouts/data/services/workouts_service.dart';

List<SingleChildWidget> getProviders() {
  return [
    Provider<WorkoutsService>(
      create: (_) => WorkoutsService(WorkoutsApiRepository.create()),
      dispose: (_, service) => service.dispose(),
    ),
  ];
}
