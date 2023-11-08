import 'package:flutter/material.dart';
import 'package:project_belanjakan/view/notification/services.dart';
import 'package:project_belanjakan/view/splash_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

void main() async {
  await NotificationService.initializeNotification();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(builder: (context, orientation, deviceType) {
      Device.orientation == Orientation.portrait
          ? SizedBox(
              width: 100.w,
              height: 20.5.h,
            )
          : SizedBox(
              width: 100.w,
              height: 12.5.h,
            );
      Device.screenType == ScreenType.tablet
          ? SizedBox(
              width: 100.w,
              height: 20.5.h,
            )
          : SizedBox(
              width: 100.w,
              height: 12.5.h,
            );
      return MaterialApp(
        navigatorKey: navigatorKey,
        home: const SplashScreen(),
      );
    });
  }
}
