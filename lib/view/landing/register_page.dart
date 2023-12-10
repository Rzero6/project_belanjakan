import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_belanjakan/bloc/form_submission_state.dart';
import 'package:project_belanjakan/bloc/register_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_belanjakan/bloc/register_event.dart';
import 'package:project_belanjakan/bloc/register_state.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class Registerview extends StatefulWidget {
  const Registerview({super.key});

  @override
  State<Registerview> createState() => RegisterviewState();
}

class RegisterviewState extends State<Registerview> {
  final formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  bool isPasswordVisibleChanged = true;

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    emailController.dispose();
    numberController.dispose();
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const colorizeColors = [
      Colors.blue,
      Colors.purple,
      Colors.green,
      Colors.red,
      Colors.yellow,

    ];
    const colorizeTextStyle = TextStyle(
      fontSize: 50.0,
      fontWeight: FontWeight.bold,
    );
    return BlocProvider(
      create: (context) => RegisterBloc(),
      child: BlocListener<RegisterBloc, RegisterState>(
        listener: (context, state) {
          if (state.formSubmissionState is SubmissionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                key: Key("register-message-success"),
                content: Text('Register Success'),
              ),
            );
            Navigator.pop(context);
            //Navigator.push(context, MaterialPageRoute(builder: (_) => const UserList()));
          }
          if (state.formSubmissionState is SubmissionFailed) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                key: const Key("register-message-failed"),
                content: Text((state.formSubmissionState as SubmissionFailed)
                    .exception
                    .toString()),
              ),
            );
          }
        },
        child:
            BlocBuilder<RegisterBloc, RegisterState>(builder: (context, state) {
          return SafeArea(
            child: Scaffold(
              body: Form(
                key: formKey,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: Container(
                    alignment: Alignment.topCenter,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 10.h, horizontal: 1.w),
                            child: SizedBox(
                              width: double.infinity,
                              child: AnimatedTextKit(
                                animatedTexts: [
                                  ColorizeAnimatedText('Come Join Us',
                                      textStyle: colorizeTextStyle,
                                      colors: colorizeColors,
                                      textAlign: TextAlign.center),
                                  ColorizeAnimatedText('@belanjakan',
                                      textStyle: colorizeTextStyle,
                                      colors: colorizeColors,
                                      textAlign: TextAlign.center),
                                  ColorizeAnimatedText('Register',
                                      textStyle: colorizeTextStyle,
                                      colors: colorizeColors,
                                      textAlign: TextAlign.center),
                                ],
                                isRepeatingAnimation: true,
                              ),
                            ),
                          ),
                          TextFormField(
                            controller: usernameController,
                            key: const Key("register-input-username"),
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              prefixIcon: Icon(Icons.person),
                              labelText: 'Username',
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your username';
                              } else if (value.length < 3) {
                                return 'Username must be at least 3 characters';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 2.h),
                          TextFormField(
                              controller: emailController,
                              key: const Key('register-input-email'),
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
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
                          SizedBox(height: 2.h),
                          TextFormField(
                            controller: passwordController,
                            key: const Key('register-input-password'),
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              prefixIcon: const Icon(Icons.lock),
                              labelText: 'Password',
                              suffixIcon: IconButton(
                                onPressed: () {
                                  context.read<RegisterBloc>().add(
                                        IsPasswordVisibleChanged(),
                                      );
                                },
                                icon: Icon(!state.isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                color: !state.isPasswordVisible
                                    ? Colors.blue
                                    : Colors.grey,
                              ),
                            ),
                            obscureText: state.isPasswordVisible,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please Enter your Password';
                              }
                              if (value.length < 8) {
                                return 'Password must be at least 8 characters';
                              }
                              if (!value.contains(RegExp(r'[0-9]'))) {
                                return 'Password must contain at least one number';
                              }
                              if (!value.contains(
                                  RegExp(r'[!@#\$%^&*(),.?":{}|<>]'))) {
                                return 'Password must contain at least one special character';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 2.h),
                          TextFormField(
                              controller: numberController,
                              key: const Key('register-input-number'),
                              keyboardType: TextInputType.phone,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
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
                          SizedBox(height: 2.h),
                          TextFormField(
                              key: const Key("register-input-date"),
                              controller: dateController,
                              keyboardType: TextInputType.datetime,
                              onTap: _selectDate,
                              readOnly: true,
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                prefixIcon: const Icon(Icons.date_range),
                                labelText: 'Born Date',
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    _selectDate();
                                  },
                                  icon: const Icon(Icons.date_range_outlined),
                                  color: Colors.blue,
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please Enter your Born Date';
                                }
                                if (under18(value)) {
                                  return 'Please Get Older (18+)';
                                }
                                return null;
                              }),
                          SizedBox(height: 2.h),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              key: const Key("register-submit"),
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  context.read<RegisterBloc>().add(
                                        FormSubmitted(
                                            username: usernameController.text,
                                            password: passwordController.text,
                                            noTlp: numberController.text,
                                            tanggalLahir: dateController.text,
                                            email: emailController.text),
                                      );
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 16.0, horizontal: 16.0),
                                child:
                                    state.formSubmissionState is FormSubmitting
                                        ? const CircularProgressIndicator(
                                            color: Colors.white,
                                          )
                                        : const Text("Register"),
                              ),
                            ),
                          ),
                        ],
                      ),
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

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 100)),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        dateController.text =
            DateFormat('yyyy-MM-dd').format(picked).toString().split(" ")[0];
      });
    }
  }

  bool under18(String selectedDate) {
    DateTime picked;
    try {
      picked = DateFormat('yyyy-MM-dd').parse(selectedDate);
    } catch (e) {
      throw "salah format";
    }
    if ((DateTime.now().year - picked.year) < 18) {
      return true;
    }
    return false;
  }
}
