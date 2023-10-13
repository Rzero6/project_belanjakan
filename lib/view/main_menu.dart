// main_menu_view.dart
import 'package:flutter/material.dart';
import 'package:project_belanjakan/view/grid.dart';
import 'package:project_belanjakan/view/view_list.dart';

class MainMenuView extends StatelessWidget {
  const MainMenuView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Main Menu'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Grid'),
              Tab(text: 'Profile'),
              Tab(text: 'Calls'),
              Tab(text: 'Settings'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            MyGridView(),
            ListNamaView(),
            Center(child: Text('Calls')),
            Center(child: Text('Settings')),
          ],
        ),
      ),
    );
  }
}
