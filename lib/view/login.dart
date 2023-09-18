import 'package:flutter/material.dart';
import 'package:project_belanjakan/view/grid.dart';

import 'package:project_belanjakan/view/register.dart';
import 'package:project_belanjakan/component/form_component.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginView extends StatefulWidget {
  //*
  //*
  final Map? data;

  const LoginView({super.key, this.data});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    //*TextEditingController
    TextEditingController usernameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    Map? dataForm = widget.data;
    return Scaffold(
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //*username
              InputForm(
                validasi: (p0) {
                  if (p0 == null || p0.isEmpty) {
                    return "username tidak boleh kosong";
                  }
                  return null;
                },
                password: false,
                controller: usernameController,
                hintTxt: "Username",
                iconData: Icons.person,
              ),
              //*password
              InputForm(
                validasi: (p0) {
                  if (p0 == null || p0.isEmpty) {
                    return "password kosong";
                  }
                  return null;
                },
                password: true,
                controller: passwordController,
                hintTxt: "Password",
                iconData: Icons.lock,
              ),

              TextButton(
                  onPressed: () {
                    Map<String, dynamic> formData = {};
                    formData['username'] = usernameController.text;
                    formData['password'] = passwordController.text;
                    pushRegister(context);
                  },
                  child: const Text('Belum punya akun ?')),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: SizedBox(
                  width: 350,
                  height: 50,
                  child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (dataForm!['username'] ==
                                  usernameController.text &&
                              dataForm['password'] == passwordController.text) {
                            Fluttertoast.showToast(msg: "login Success");
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const MyGridView()));
                          } else {
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text('Password Salah'),
                                content: TextButton(
                                    onPressed: () => pushRegister(context),
                                    child: const Text('Daftar DIsini !!')),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, 'Cancel'),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, 'OK'),
                                    child: const Text('Cancel'),
                                  ),
                                ],
                              ),
                            );
                          }
                        }
                      },
                      child: const Text('Login')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void pushRegister(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const RegisterView(),
      ),
    );
  }
}
