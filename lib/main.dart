import 'package:flutter/material.dart';
import 'package:project_belanjakan/view/qr_scan/scan_qr_page.dart';
import 'package:project_belanjakan/view/splash_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SplashScreen(),
      // home: BarcodeScannerPageView(),
    );
  }
}
