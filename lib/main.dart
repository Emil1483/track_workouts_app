import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:track_workouts/style/theme.dart';

import 'handlers/router.dart';

main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: Router.navigatorKey,
      theme: appTheme,
      initialRoute: Router.rootRoute,
      onGenerateRoute: Router.generateRoute,
    );
  }
}
