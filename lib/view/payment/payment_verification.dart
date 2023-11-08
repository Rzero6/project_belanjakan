import 'package:flutter/material.dart';
import 'package:project_belanjakan/model/user.dart';
import 'package:project_belanjakan/model/item.dart';
import 'package:project_belanjakan/view/main_menu.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project_belanjakan/view/receipt/preview_screen.dart';
import 'package:project_belanjakan/view/receipt/pdf_view.dart';
import 'package:uuid/uuid.dart';

class PaymentVerificationView extends StatefulWidget {
  final int id;
  const PaymentVerificationView({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<PaymentVerificationView> createState() =>
      _PaymentVerificationViewState();
}

class _PaymentVerificationViewState extends State<PaymentVerificationView> {
  User? userData;
  TextEditingController passwordController = TextEditingController();
  bool isPasswordVisibleChanged = false;
  bool isloading = false;
  String id = const Uuid().v1();
  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Qris Payment Verification"),
      ),
      body: Column(children: [
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
              color: !isPasswordVisibleChanged ? Colors.blue : Colors.grey,
            ),
          ),
          obscureText: isPasswordVisibleChanged,
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              isloading = true;
            });
            verify(context);
          },
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            child: isloading
                ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                : const Text("Submit Payment"),
          ),
        ),
      ]),
    );
  }

  Future<void> loadData() async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    userData = User(
        id: sharedPrefs.getInt('userID'),
        username: sharedPrefs.getString('username'),
        password: sharedPrefs.getString('password'),
        email: sharedPrefs.getString('email'),
        phone: sharedPrefs.getString('phone'),
        profilePic: sharedPrefs.getString("profile_pic"));
  }

  Future<void> verify(BuildContext context) async {
    String verifyMessage;
    verifyMessage = checkPassword() ? "Berhasil Bayar" : "Gagal Bayar";
    Future.delayed(const Duration(seconds: 3), () {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(verifyMessage),
      ));
      isloading = false;
      if (verifyMessage == "Berhasil Bayar") {
        createPdf(userData!, id, context, widget.id);
        setState(() {
          const uuid = Uuid();
          id = uuid.v1();
        });
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const MainMenuView()));
      }
    });
  }

  bool checkPassword() {
    if (passwordController.text == userData?.password) {
      return true;
    }
    return false;
  }
}
