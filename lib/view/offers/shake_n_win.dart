import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:project_belanjakan/database/sql_helper_user.dart';
import 'package:project_belanjakan/model/coupon.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

class ShakeNWin extends StatefulWidget {
  const ShakeNWin({super.key});

  @override
  State<ShakeNWin> createState() => _ShakeNWinState();
}

class _ShakeNWinState extends State<ShakeNWin> {
  double _accelometerValueY = 0.0;
  bool rewarded = false;
  int countShake = 0;
  bool isLoading = true;
  late int userId;
  Coupon? couponData;

  void getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('userID')!;
  }

  void checkWin() {
    if (countShake >= 5) {
      countShake = 0;
      setState(() {
        rewarded = true;
      });
      showRewardDialog();
    }
  }

  String generateCouponCode() {
    String code = 'CPN';
    final random = Random();
    int randomNumber;
    for (int i = 0; i < 7; i++) {
      randomNumber = random.nextInt(9);
      code += randomNumber.toString();
    }
    return code;
  }

  Coupon generateCoupon() {
    int discount = generateDiscount();
    return couponData =
        Coupon(userId: userId, code: generateCouponCode(), discount: discount);
  }

  void showRewardDialog() {
    couponData = generateCoupon();
    addCoupon(couponData!);
    AudioPlayer().play(AssetSource('audio/wawww.mp3'));
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Align(
                alignment: Alignment.center, child: Text('Selamat!')),
            content: SizedBox(
              width: double.infinity,
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRect(
                    child: Lottie.asset('assets/animation/rewarded.json'),
                  ),
                  const Text("Anda dapat kupon diskon sebesar"),
                  Text(
                    "${couponData?.discount}%",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'))
            ],
          );
        });
  }

  int generateDiscount() {
    int value = 0;
    final random = Random();
    final randomNumber = random.nextDouble() * 100;

    if (randomNumber < 1) {
      value = 60;
    } else if (randomNumber < 2.5) {
      value = 50;
    } else if (randomNumber < 5) {
      value = 40;
    } else if (randomNumber < 7.5) {
      value = 25;
    } else if (randomNumber < 20) {
      value = 20;
    } else if (randomNumber < 35) {
      value = 10;
    } else {
      value = 5;
    }
    return value;
  }

  @override
  void initState() {
    getUserId();
    userAccelerometerEvents.listen((event) {
      _accelometerValueY = event.y;
      if (_accelometerValueY.abs() > 15 && rewarded == false) {
        countShake++;
        checkWin();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: rewarded
            ? Center(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Kesempatan Ngocoknya sudah abis nanti lagi yaa'),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Kembali'))
                ],
              ))
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('KOCOK HAPEMU SEKARANG'),
                  const Text(
                      'Kocok sekuat mungkin untuk mendapatkan KUPON DISKON'),
                  ClipRect(
                      child: Lottie.asset('assets/animation/phone_shake.json')),
                ],
              ),
      ),
    );
  }

  Future<void> addCoupon(Coupon data) async {
    await SQLHelperUser.addCouponForUsers(data);
  }
}
