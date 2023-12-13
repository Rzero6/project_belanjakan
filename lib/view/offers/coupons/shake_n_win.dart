import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
import 'package:project_belanjakan/model/coupon.dart';
import 'package:project_belanjakan/services/api/coupon_client.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import 'package:responsive_sizer/responsive_sizer.dart';

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
  late String token;
  Coupon? couponData;

  void loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('userID')!;
    token = prefs.getString('token')!;
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
    String code = 'SNW';
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
    return couponData = Coupon(
        name: "Shake N' Win",
        idUser: userId,
        code: generateCouponCode(),
        discount: discount,
        expiresAt:
            DateTime.now().add(const Duration(days: 1)).toIso8601String());
  }

  void addCouponToDatabase() async {
    await CouponClient.addCoupon(couponData!, token);
  }

  void showRewardDialog() async {
    couponData = generateCoupon();
    addCouponToDatabase();
    AudioPlayer().play(AssetSource('audio/wawww.mp3'));
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Align(
                alignment: Alignment.center, child: Text('Selamat!')),
            content: SizedBox(
              width: double.infinity,
              height: 28.h,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRect(
                    child: Lottie.asset('assets/animation/rewarded.json'),
                  ),
                  SizedBox(
                    height: 1.h,
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
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK')),
              )
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
    loadData();
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
      appBar: AppBar(
        title: const Text('Shake N Win'),
      ),
      body: rewarded
          ? Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 2.h, horizontal: 10.w),
                      child:
                          SpinKitSpinningLines(color: Colors.blue, size: 25.w),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 2.h, horizontal: 10.w),
                      child:
                          SpinKitSpinningLines(color: Colors.blue, size: 25.w),
                    ),
                  ],
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 6.h, horizontal: 10.w),
                  child: SpinKitSpinningLines(color: Colors.blue, size: 25.w),
                ),
                const Text(
                    'Kesempatan Shake and Win sudah abis nanti lagi yaa'),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  child: SizedBox(
                    height: 6.h,
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Kembali')),
                  ),
                ),
              ],
            ))
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5.w),
                  child: const Text(
                    'KOCOK HAPEMU SEKARANG',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: SizedBox(
                    width: double.infinity,
                    height: 10.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        SizedBox(
                          width: 2.w,
                        ),
                        const Text(
                          'yang',
                          style: TextStyle(fontSize: 40.0),
                        ),
                        SizedBox(width: 2.w),
                        SizedBox(width: 2.w),
                        DefaultTextStyle(
                          style: const TextStyle(
                              fontSize: 30.0,
                              fontFamily: 'Horizon',
                              color: Colors.blue,
                              fontWeight: FontWeight.bold),
                          child: AnimatedTextKit(
                            repeatForever: true,
                            animatedTexts: [
                              RotateAnimatedText('KUAT'),
                              RotateAnimatedText('KENCANG'),
                              RotateAnimatedText('CEPAT'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
                  child: const Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Kocok sekuat mungkin untuk mendapatkan\nKUPON DISKON',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                ClipRect(
                    child: Lottie.asset('assets/animation/phone_shake.json')),
              ],
            ),
    );
  }
}
