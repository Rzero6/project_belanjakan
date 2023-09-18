import 'package:flutter/material.dart';
import 'package:project_belanjakan/view/login.dart';
import 'package:project_belanjakan/view/main_menu.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MainMenuView(),
    );
  }
}
