import 'package:flutter/material.dart';
import 'package:project_belanjakan/services/notifications/services.dart';
import 'package:project_belanjakan/view/landing/splash_screen.dart';
import 'package:project_belanjakan/view/address/address_page.dart';
//import 'package:project_belanjakan/view/payment/';
import 'package:project_belanjakan/view/payment/payment_method.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  await NotificationService.initializeNotification();
  runApp(const ProviderScope(
    child: MainApp(),
  ));
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
        home: PaymentScreen(),
      );
    });
  }
}
