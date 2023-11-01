import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:project_belanjakan/database/sql_helper_user.dart';
import 'package:project_belanjakan/model/user.dart';
import 'package:project_belanjakan/view/edit_profile_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  int? userID;
  User? userData;

  String imagePath = 'assets/images/user/profile_picture.jpg';
  late File imageFile;

  @override
  void initState() {
    imageFile = File(imagePath);
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        const SizedBox(
          height: 25,
        ),
        Center(
          child: Stack(
            children: [
              ClipOval(
                child: Material(
                  color: Colors.transparent,
                  child: Hero(
                    tag: 'profilePic',
                    child: Ink.image(
                      image: imageFile.existsSync()
                          ? FileImage(imageFile) as ImageProvider
                          : const AssetImage(
                              'assets/images/profile_placeholder.jpg'),
                      fit: BoxFit.cover,
                      width: 128,
                      height: 128,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 3,
                child: GestureDetector(
                  onTap: () async {
                    Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const EditProfilePage()))
                        .then((value) => loadData());
                  },
                  child: ClipOval(
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      color: Theme.of(context).colorScheme.primary,
                      child: const Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 24,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              userData?.username ?? "",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              userData?.email ?? "",
              style: const TextStyle(color: Colors.grey),
            )
          ],
        )
      ],
    ));
  }

  Future<User?> getUserById(int id) async {
    return await SQLHelperUser.getUserById(id);
  }

  Future<void> loadData() async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();

    setState(() {
      userData = User(
          id: sharedPrefs.getInt('userID'),
          username: sharedPrefs.getString('username'),
          password: sharedPrefs.getString('password'),
          email: sharedPrefs.getString('email'),
          phone: sharedPrefs.getString('phone'));
    });
  }
}

class FullScreenProfilePic extends StatelessWidget {
  const FullScreenProfilePic({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Hero(
        tag: 'profilePic',
        child: PhotoView(
          imageProvider:
              const AssetImage('assets/images/profile_placeholder.jpg'),
          maxScale: 1.2,
          minScale: 0.6,
        ),
      ),
    );
  }
}
