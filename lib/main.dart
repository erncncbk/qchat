import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:qchat/core/constants/navigation/navigation_constant.dart';
import 'package:qchat/core/init/navigation/navigation_route.dart';
import 'package:qchat/core/init/notifier/provider_list.dart';
import 'package:qchat/locator.dart';

import 'core/init/navigation/navigation_service.dart';

void main() async {
  setupLocator();

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp();
  runApp(MultiProvider(
      providers: [...AppProvider.instance!.dependItem], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      // theme: Provider.of<ThemeNotifier>(context, listen: false).currentTheme,
      initialRoute: NavigationConstants.splashPage,
      navigatorKey: NavigationService.instance.navigatorKey,
      onGenerateRoute: NavigationRoute.instance!.generateRoute,
    );
  }
}
