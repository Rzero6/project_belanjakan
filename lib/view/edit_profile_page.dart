import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_belanjakan/database/sql_helper_user.dart';
import 'package:project_belanjakan/model/user.dart';
import 'package:project_belanjakan/view/camera_profile/camera.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  User? userData;
  String imagePath = 'assets/images/user/profile_picture.jpg';
  late File imageFile;
  final formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController oldPasswordController = TextEditingController();

  bool isPasswordVisibleChanged = true;
  bool isOldPasswordVisibleChanged = true;

  void showOptionToPick() {
    showCupertinoModalPopup(
      context: context,
      builder: ((context) => CupertinoActionSheet(
            title: const Text("Select Picture from"),
            actions: <CupertinoActionSheetAction>[
              CupertinoActionSheetAction(
                child: const Text('Camera'),
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CameraView(
                          onPictureTaken: (String returnedPath) {
                            setState(() {
                              imagePath = returnedPath;
                            });
                          },
                        ),
                      ));
                },
              ),
              CupertinoActionSheetAction(
                child: const Text('Gallery'),
                onPressed: () {
                  pickImageFromGallery();
                },
              )
            ],
          )),
    );
  }

  Future<void> pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage == null) return;
    setState(() {
      imageFile = File(pickedImage.path);
      Navigator.pop(context);
    });
  }

  @override
  void initState() {
    loadData();
    super.initState();
    imageFile = File(imagePath);
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
              Positioned(
                bottom: 0,
                right: 3,
                child: GestureDetector(
                  onTap: () => showOptionToPick(),
                  child: ClipOval(
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      color: Theme.of(context).colorScheme.primary,
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 20,
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: usernameController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    labelText: 'Username',
                  ),
                  validator: (value) =>
                      value == '' ? 'Please Enter your Username' : null,
                ),
                TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.email),
                      labelText: 'Email',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please Enter your Email';
                      } else if (!value.contains('@')) {
                        return 'Email must contain @ character';
                      }
                      return null;
                    }),
                TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock),
                    labelText: 'Password',
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isPasswordVisibleChanged = !isPasswordVisibleChanged;
                        });
                      },
                      icon: Icon(!isPasswordVisibleChanged
                          ? Icons.visibility
                          : Icons.visibility_off),
                      color:
                          !isPasswordVisibleChanged ? Colors.blue : Colors.grey,
                    ),
                  ),
                  obscureText: isPasswordVisibleChanged,
                  validator: (value) =>
                      value == '' ? 'Please Enter your Password' : null,
                ),
                TextFormField(
                    controller: numberController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.phone),
                      labelText: 'Phone Number',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please Enter your Phone Number';
                      } else if (value.startsWith('+') ||
                          value.startsWith('0')) {
                        return null;
                      } else {
                        return 'Phone Number must start with + or 0';
                      }
                    }),
                const SizedBox(
                  height: 40,
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Edit Success'),
                            ),
                          );
                          editUser();
                          Navigator.pop(context);
                        }
                      },
                      child: const Text('Save')),
                )
              ],
            ),
          ),
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
      usernameController.text = userData!.username!;
      emailController.text = userData!.email!;
      numberController.text = userData!.phone!;
    });
  }

  Future<void> editUser() async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    User userData = User(
        username: usernameController.text,
        password: passwordController.text,
        email: emailController.text,
        phone: numberController.text,
        dateOfBirth: sharedPrefs.getString('dob'));
    setState(() {
      sharedPrefs.setString('username', userData.username!);
      sharedPrefs.setString('password', userData.password!);
      sharedPrefs.setString('email', userData.email!);
      sharedPrefs.setString('phone', userData.phone!);
    });
    await SQLHelperUser.editUsers(sharedPrefs.getInt('userID')!, userData);
  }
}
