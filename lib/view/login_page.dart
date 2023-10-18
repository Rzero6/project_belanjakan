import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_belanjakan/bloc/form_submission_state.dart';
import 'package:project_belanjakan/bloc/login_bloc.dart';
import 'package:project_belanjakan/bloc/login_event.dart';
import 'package:project_belanjakan/bloc/login_state.dart';
import 'package:project_belanjakan/model/user.dart';
import 'package:project_belanjakan/view/main_menu.dart';
import 'package:project_belanjakan/view/register_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Loginview extends StatefulWidget {
  const Loginview({super.key});

  @override
  State<Loginview> createState() => _LoginviewState();
}

class _LoginviewState extends State<Loginview> {
  final formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(),
      child: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state.formSubmissionState is SubmissionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Login Success'),
              ),
            );
            User userData =
                (state.formSubmissionState as SubmissionSuccess).user;
            saveLoginData(userData);
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (_) => const MainMenuView()));
          }
          if (state.formSubmissionState is SubmissionFailed) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text((state.formSubmissionState as SubmissionFailed)
                    .exception
                    .toString()),
              ),
            );
          }
        },
        child: BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
          return SafeArea(
            child: Scaffold(
              body: Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(20),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.shopify_rounded,
                                    color: Colors.blue, size: 150),
                                Text(
                                  "BELANJAKAN",
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30),
                                ),
                              ]),
                        ),
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
                          controller: passwordController,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.lock),
                            labelText: 'Password',
                            suffixIcon: IconButton(
                              onPressed: () {
                                context.read<LoginBloc>().add(
                                      IsPasswordVisibleChanged(),
                                    );
                              },
                              icon: Icon(
                                state.isPasswordVisible
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: state.isPasswordVisible
                                    ? Colors.grey
                                    : Colors.blue,
                              ),
                            ),
                          ),
                          obscureText: state.isPasswordVisible,
                          validator: (value) =>
                              value == '' ? 'Please enter your Password' : null,
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                context.read<LoginBloc>().add(
                                      FormSubmitted(
                                          username: usernameController.text,
                                          password: passwordController.text),
                                    );
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16.0, horizontal: 16.0),
                              child: state.formSubmissionState is FormSubmitting
                                  ? const CircularProgressIndicator(
                                      color: Colors.white)
                                  : const Text("Login"),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Belum mempunyai Akun ? '),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const Registerview(),
                                  ),
                                );
                              },
                              child: const Text('Register'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Future<void> saveLoginData(User userData) async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    await sharedPrefs.setInt('userID', userData.id!);
    await sharedPrefs.setString('username', userData.username!);
    await sharedPrefs.setString('password', userData.password!);
    await sharedPrefs.setString('email', userData.email!);
    await sharedPrefs.setString('phone', userData.phone!);
    await sharedPrefs.setString('dob', userData.dateOfBirth!);
  }
}
