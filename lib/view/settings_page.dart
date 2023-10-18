import 'package:flutter/material.dart';
import 'package:project_belanjakan/view/login_page.dart';
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
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const UserList()));
              },
              child: const Text('User List'),
            ),
            ElevatedButton(
                onPressed: () async {
                  removeLoginData();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => const Loginview()));
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Logout')),
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
