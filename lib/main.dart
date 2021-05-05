import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:track_workouts/routes/root/root_route.dart';
import 'package:track_workouts/style/theme.dart';

import 'handlers/provider_setup.dart';
import 'handlers/router.dart';

main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: AppColors.black900,
  ));

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: getProviders(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: MRouter.navigatorKey,
        theme: appTheme,
        initialRoute: RootRoute.routeName,
        onGenerateRoute: MRouter.generateRoute,
      ),
    );
  }
}
