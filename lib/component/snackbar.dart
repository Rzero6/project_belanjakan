import 'package:flutter/material.dart';

class CustomSnackBar {
  static void showSnackBar(BuildContext context, String msg, Color bg) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: bg,
        action: SnackBarAction(
            label: 'Hide',
            textColor: Colors.white,
            onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }
}
