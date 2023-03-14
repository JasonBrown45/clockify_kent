import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import 'activity/state/timer_state.dart';
import 'auth/state/user_auth_state.dart';
import 'activity/state/activity_state.dart';
import 'auth/presentation/email_page.dart';
import 'model/activity.dart';
import 'model/user.dart';

late Box userBox;
late Box activityBox;
void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  Directory appPath = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appPath.path);
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(ActivityAdapter());

  userBox = await Hive.openBox<User>('user');
  activityBox = await Hive.openBox<Activity>('activity');

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => AuthState()),
      ChangeNotifierProvider(create: (context) => ActivityState()),
      ChangeNotifierProvider(create: (context) => TimerState()),
    ],
    child: const MainApp(),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromRGBO(34, 57, 123, 1.0)),
      ),
      home: const EmailPage(),
    );
  }
}
