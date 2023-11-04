import 'package:flutter/material.dart';
import 'package:project_belanjakan/view/notification/services.dart';
import 'package:project_belanjakan/view/splash_screen.dart';

void main() async {
  await NotificationService.initializeNotification();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      home: const SplashScreen(),
    );
  }
}
