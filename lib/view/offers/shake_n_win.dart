import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';
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

  void checkWin() {
    if (countShake >= 5) {
      countShake = 0;
      setState(() {
        rewarded = true;
      });
      showRewardDialog();
    }
  }

  void showRewardDialog() {
    int discount = generateDiscount();
    Vibration.vibrate();
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
                    "$discount%",
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

    if (randomNumber < 2.5) {
      value = 60;
    } else if (randomNumber < 7.5) {
      value = 50;
    } else if (randomNumber < 10) {
      value = 40;
    } else if (randomNumber < 12.5) {
      value = 25;
    } else if (randomNumber < 25) {
      value = 20;
    } else if (randomNumber < 50) {
      value = 10;
    } else {
      value = 5;
    }
    return value;
  }

  @override
  void initState() {
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
            ? const Center(
                child: Text('Kesempatan Ngocoknya sudah abis nanti lagi yaa'))
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
}
