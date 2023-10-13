// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:project_belanjakan/view/login.dart';
import 'package:project_belanjakan/component/form_component.dart';
import 'package:intl/intl.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  //*Untuk Validasi harus menggunakan GlobalKey
  final _formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController notelpController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  final DateFormat dateFormat = DateFormat.yMd();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InputForm(
                  validasi: (p0) {
                    if (p0 == null || p0.isEmpty) {
                      return 'Username Tidak Boleh Kosong';
                    }
                    if (p0.toLowerCase() == 'anjing') {
                      return 'Tidak Boleh menggunakan kata kasar';
                    }
                    return null;
                  },
                  controller: usernameController,
                  hintTxt: "Username",
                  helperTxt: "Ucup Surucup",
                  iconData: Icons.person),
              InputForm(
                  validasi: ((p0) {
                    if (p0 == null || p0.isEmpty) {
                      return 'Email Tidak Boleh Kosong';
                    }
                    if (!p0.contains('@')) {
                      return 'Email harus menggunakan @';
                    }
                    return null;
                  }),
                  controller: emailController,
                  hintTxt: "Email",
                  helperTxt: "ucup@gmail.com",
                  iconData: Icons.email),
              InputForm(
                  validasi:
                      //*Pola validasi lebih detail bisa menggunakan regex
                      ((p0) {
                    if (p0 == null || p0.isEmpty) {
                      return 'Password Tidak Boleh Kosong';
                    }
                    if (p0.length < 5) {
                      return 'Password minimal 5 digit';
                    }
                    return null;
                  }),
                  controller: passwordController,
                  hintTxt: "Password",
                  helperTxt: "xxxxxxx",
                  iconData: Icons.password,
                  password: true),
              InputForm(
                  validasi: ((p0) {
                    //* untuk melihat contoh penggunaan regex uncommand baris dibawah
                    //* final Regex regex = RegExp(r'^\0?[1-9]\d(1,14)$');
                    if (p0 == null || p0.isEmpty) {
                      return 'Nomor Telepon Tidak Boleh Kosong';
                    }
                    // if(!regex.hasMatch(p0))
                    //{
                    //return 'Nomor Telepon tidak valid';
                    //}
                    return null;
                  }),
                  controller: notelpController,
                  hintTxt: "No Telp",
                  helperTxt: "082123456789",
                  iconData: Icons.phone_android),
              InputForm(
                  validasi: ((p0) {
                    try {
                      if (p0 == null || p0.isEmpty) {
                        return 'Format Tanggal Salah [mm/dd/yyyy]';
                      }
                      final DateTime parsedDate = dateFormat.parseStrict(p0);
                      return null;
                    } catch (e) {
                      return 'Format Tanggal Salah [mm/dd/yyyy]';
                    }
                  }),
                  controller: dateController,
                  hintTxt: "Tanggal Lahir",
                  date: true,
                  iconData: Icons.date_range_outlined),
              ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      //scaffoldMesseger.of(context).showSnackBar(
                      //const SnackBar(content: Text('Processing Data')));
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('Register'),
                          content: const Text('Apakah Data Sudah Benar ?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Map<String, dynamic> formData = {};
                                formData['username'] = usernameController.text;
                                formData['password'] = passwordController.text;
                                //* Navigator.push(context, MaterialPageRoute(builderContext buildContext) => LoginView(data: formData ,)) );
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => LoginView(
                                              data: formData,
                                            )));
                              },
                              child: const Text('OK'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'Cancel'),
                              child: const Text('Cancel'),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  child: const Text('Register'))
            ],
          ),
        ),
      ),
    );
  }
}
