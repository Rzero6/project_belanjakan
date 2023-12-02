import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_belanjakan/model/user.dart';
import 'package:project_belanjakan/services/api/api_client.dart';
import 'package:project_belanjakan/services/api/user_client.dart';
import 'package:project_belanjakan/services/convert/string_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final UserClient _userClient = UserClient();
  User? userData;
  File? imageFile;
  final formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController oldPasswordController = TextEditingController();

  bool isPasswordVisibleChanged = true;
  bool isOldPasswordVisibleChanged = true;
  bool isLoading = true;

  void showOptionToPick() {
    showCupertinoModalPopup(
      context: context,
      builder: ((context) => CupertinoActionSheet(
            title: const Text("Select Picture from"),
            actions: <CupertinoActionSheetAction>[
              CupertinoActionSheetAction(
                child: const Text('Camera'),
                onPressed: () async {
                  pickImageFromCamera();
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
    final pickedImage = await picker.pickImage(
        source: ImageSource.gallery,
        maxHeight: 720,
        maxWidth: 720,
        imageQuality: 50);
    if (pickedImage == null) return;
    setState(() {
      imageFile = File(pickedImage.path);
      Navigator.pop(context);
    });
  }

  Future<void> pickImageFromCamera() async {
    final ImagePicker picker = ImagePicker();
    final pickedImage = await picker.pickImage(
        source: ImageSource.camera,
        maxHeight: 720,
        maxWidth: 720,
        imageQuality: 50);
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
  }

  Future<void> savingData() async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    try {
      bool success = await editUser();
      if (success) {
        Navigator.pop(context);
        setState(() {
          sharedPrefs.setString('username', userData!.name);
          sharedPrefs.setString('email', userData!.email);
          sharedPrefs.setString('profile_pic', userData!.profilePicture!);
        });
      }
    } catch (e) {
      rethrow;
    } finally {
      setState(() {
        isLoading = false;
      });
    }
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
                  Center(
                    child: Stack(
                      children: [
                        ClipOval(
                          child: Material(
                            color: Colors.transparent,
                            child: Ink.image(
                              image: imageFile != null
                                  ? Image.file(imageFile!).image
                                  : Image.network(
                                      '${ApiClient().domainName}${userData!.profilePicture!}',
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Image.asset(
                                          'assets/images/profile_placeholder.jpg',
                                          fit: BoxFit.cover,
                                          width: 128,
                                          height: 128,
                                        );
                                      },
                                    ).image,
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
                            validator: (value) => value == ''
                                ? 'Please Enter your Username'
                                : null,
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
                                    isPasswordVisibleChanged =
                                        !isPasswordVisibleChanged;
                                  });
                                },
                                icon: Icon(!isPasswordVisibleChanged
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                color: !isPasswordVisibleChanged
                                    ? Colors.blue
                                    : Colors.grey,
                              ),
                            ),
                            obscureText: isPasswordVisibleChanged,
                            validator: (value) => value == ''
                                ? 'Please Enter your Password'
                                : null,
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
                                    setState(() {
                                      isLoading = true;
                                    });
                                    savingData();
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 16),
                                  child: isLoading
                                      ? const CircularProgressIndicator(
                                          color: Colors.white,
                                        )
                                      : const Text('Save'),
                                )),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.red)),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 16),
                                  child: Text(
                                    'Cancel',
                                  ),
                                )),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ));
  }

  Future<void> loadData() async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    userData = await _userClient.getUser(sharedPrefs.getString('token')!);
    setState(() {
      usernameController.text = userData!.name;
      emailController.text = userData!.email;
      numberController.text = userData!.phone;
      isLoading = false;
    });
  }

  Future<bool> editUser() async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    String image = await ConvertImageString.imgToStr(imageFile!);
    userData = User(
        name: usernameController.text,
        password: passwordController.text,
        email: emailController.text,
        phone: numberController.text,
        profilePicture: image);
    try {
      userData = await _userClient.updateUser(
          userData!, sharedPrefs.getString('token')!);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User updated'),
        ),
      );
      return true;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
      return false;
    }
  }
}
