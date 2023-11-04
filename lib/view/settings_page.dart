import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:project_belanjakan/view/items_list.dart';
import 'package:project_belanjakan/view/login_page.dart';
import 'package:project_belanjakan/view/notification/services.dart';
import 'package:project_belanjakan/view/payment/quick_pay.dart';
import 'package:project_belanjakan/view/profile_page.dart';
import 'package:project_belanjakan/view/user_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.notifications),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const QuickPayView(
                              id: 1,
                            )));
              },
              label: const Text('Quick Pay'),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.notifications),
              onPressed: () async {
                await NotificationService.showNotification(
                    title: "Heey kamuu",
                    body: "Sinii ngocok dulu, dapat kupon diskon loh",
                    payload: {
                      "navigate": "true",
                    },
                    notificationLayout: NotificationLayout.Default,
                    category: NotificationCategory.Promo);
              },
              label: const Text('Test Notification'),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.person),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const ProfileView()));
              },
              label: const Text('Profile'),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.add_box_outlined),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const ItemsListView()));
              },
              label: const Text('Add Items'),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.people),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const UserList()));
              },
              label: const Text('User List'),
            ),
            ElevatedButton.icon(
                icon: const Icon(Icons.power_settings_new),
                onPressed: () async {
                  removeLoginData();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => const Loginview()));
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                label: const Text('Logout')),
          ],
        ),
      ),
    );
  }

  Future<void> removeLoginData() async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    sharedPrefs.clear();
  }
}
