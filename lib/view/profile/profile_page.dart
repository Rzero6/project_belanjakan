import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:project_belanjakan/model/user.dart';
import 'package:project_belanjakan/services/api/api_client.dart';
import 'package:project_belanjakan/services/notifications/services.dart';
import 'package:project_belanjakan/view/landing/login_page.dart';
import 'package:project_belanjakan/view/products/manage/list_view.dart';
import 'package:project_belanjakan/view/profile/edit_profile_page.dart';
import 'package:project_belanjakan/view/profile/my_product.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project_belanjakan/services/api/user_client.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  int? userID;
  User? userData;
  bool isLoading = true;
  final UserClient _userClient = UserClient();
  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  const SizedBox(
                    height: 25,
                  ),
                  profilePicWidget(),
                  const SizedBox(
                    height: 24,
                  ),
                  profileNameWidget(),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 3.w),
                    child: additionalMenu(),
                  ),
                ],
              ));
  }

  Future<void> loadData() async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    userData = await _userClient.getUser(sharedPrefs.getString('token')!);
    setState(() {
      isLoading = false;
    });
  }

  Center profilePicWidget() {
    return Center(
      child: Stack(
        children: [
          ClipOval(
            child: Material(
              color: Colors.transparent,
              child: Hero(
                tag: 'profilePic',
                child: Ink.image(
                  image: userData?.profilePicture == null
                      ? Image.network(
                          '${ApiClient().domainName}/images/profile.jpg',
                          fit: BoxFit.cover,
                          width: 128,
                          height: 128,
                        ).image
                      : Image.network(
                          '${ApiClient().domainName}${userData!.profilePicture}',
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.person,
                              size: 128,
                            );
                          },
                        ).image,
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
                        builder: (_) => const EditProfilePage())).then(
                  (value) {
                    isLoading = true;
                    loadData();
                  },
                );
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
    );
  }

  Column profileNameWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          userData?.name ?? "Not Found",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        const SizedBox(
          height: 4,
        ),
        Text(
          userData?.email ?? "Not Found",
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  Column additionalMenu() {
    return Column(
      children: [
        SizedBox(
          height: 5.h,
        ),
        Card(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.assignment),
                  title: const Text('Pesanan Saya'),
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const MyProduct())),
                ),
                const Divider(
                  height: 0,
                ),
                ListTile(
                  leading: const Icon(Icons.shopify_rounded),
                  title: const Text('Toko Saya'),
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const ItemsListView())),
                ),
              ],
            ),
          ),
        ),
        Card(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.notifications),
                  title: const Text('Notifications'),
                  onTap: () async {
                    await NotificationService.showNotification(
                        title: "Heey kamuu",
                        body: "Sinii ngocok dulu, dapat kupon diskon loh",
                        payload: {
                          "navigate": "true",
                        },
                        notificationLayout: NotificationLayout.Default,
                        category: NotificationCategory.Promo);
                  },
                ),
              ],
            ),
          ),
        ),
        Card(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                Theme(
                  data: ThemeData(highlightColor: Colors.transparent),
                  child: ListTile(
                    splashColor: Colors.transparent,
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: const Text(
                      'Logout',
                      style: TextStyle(color: Colors.red),
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Confirm Logout'),
                            content: const Text('Yakin ingin keluar ?'),
                            actions: <Widget>[
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Cancel'),
                              ),
                              ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.red)),
                                  onPressed: () {
                                    removeLoginData();
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => const Loginview()));
                                  },
                                  child: const Text('Logout'))
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> removeLoginData() async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    sharedPrefs.clear();
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
