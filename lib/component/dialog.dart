import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CustomDialog {
  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: SizedBox(
              width: 1.w,
              child: Lottie.asset('assets/animation/loading_cart.json',
                  fit: BoxFit.cover)),
        );
      },
    );
  }
}
