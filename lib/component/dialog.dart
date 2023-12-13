import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CustomDialog {
  static void showLoadingDialog(BuildContext context) {
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

  static void showHourGlassLoading(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            contentPadding: EdgeInsets.zero,
            content: SizedBox(
              width: 1.w,
              child: const SpinKitHourGlass(color: Colors.blue),
            ));
      },
    );
  }
}
