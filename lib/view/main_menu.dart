// main_menu_view.dart
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:project_belanjakan/view/grid.dart';
import 'package:project_belanjakan/view/items_list.dart';
import 'package:project_belanjakan/view/offers/daily_offers.dart';
import 'package:project_belanjakan/view/settings_page.dart';

class MainMenuView extends StatefulWidget {
  // final User userData;
  const MainMenuView({super.key});

  @override
  State<MainMenuView> createState() => _MainMenuViewState();
}

class _MainMenuViewState extends State<MainMenuView> {
  var currentPageIndex = 0;

  void onNavBarTapped(int index) {
    setState(() {
      currentPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const MyGridView(),
      const DailyOffers(),
      const ItemsListView(),
      const SettingsView(),
    ];
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: pages[currentPageIndex],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 70,
          decoration: const BoxDecoration(
              border: Border(
            top: BorderSide(
                color: Color.fromARGB(255, 225, 225, 225), width: 0.5),
          )),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: GNav(
              gap: 8,
              hoverColor: Colors.blue,
              tabActiveBorder: Border.all(color: Colors.blue, width: 2),
              padding: const EdgeInsets.all(10),
              tabs: const [
                GButton(icon: Icons.home, text: 'Home'),
                GButton(
                  icon: Icons.monetization_on_rounded,
                  text: 'Offers',
                ),
                GButton(
                  icon: Icons.shop,
                  text: 'Items',
                ),
                GButton(
                  icon: Icons.settings_rounded,
                  text: 'Settings',
                ),
              ],
              duration: const Duration(milliseconds: 500),
              selectedIndex: currentPageIndex,
              activeColor: Colors.blue,
              color: Colors.black54,
              onTabChange: (int index) {
                setState(() {
                  currentPageIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}

// class MainMenuView extends StatelessWidget {
//   const MainMenuView({super.key});

    // return DefaultTabController(
    //   length: 4,
    //   child: Scaffold(
    //     appBar: AppBar(
    //       title: const Text('Main Menu'),
    //       bottom: const TabBar(
    //         tabs: [
    //           Tab(text: 'Grid'),
    //           Tab(text: 'Profile'),
    //           Tab(text: 'Calls'),
    //           Tab(text: 'Settings'),
    //         ],
    //       ),
    //     ),
    //     body: const TabBarView(
    //       children: [
    //         MyGridView(),
    //         ListNamaView(),
    //         Center(child: Text('Calls')),
    //         Center(child: Text('Settings')),
    //       ],
    //     ),
    //   ),
    // );
//   }
// }
