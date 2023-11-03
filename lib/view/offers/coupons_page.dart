import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_belanjakan/database/sql_helper_user.dart';
import 'package:project_belanjakan/view/offers/shake_n_win.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CouponsPage extends StatefulWidget {
  const CouponsPage({super.key});

  @override
  State<CouponsPage> createState() => _CouponsPageState();
}

class _CouponsPageState extends State<CouponsPage> {
  bool isLoading = true;
  List<Map<String, dynamic>> coupons = [];
  late int userId;

  Future<void> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('userID')!;
  }

  Future<void> refreshCoupons() async {
    setState(() {
      isLoading = true;
    });
    await deleteExpiredCoupons(userId);
    try {
      coupons = await SQLHelperUser.getUserCoupon(userId);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  bool checkDahNgocok() {
    refreshCoupons();
    return coupons.any((element) {
      return element['code'].toString().contains("CPN");
    });
  }

  void showDialogUdahNgocok() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Tunggu Dulu...'),
            content: const Text(
                'Kau tuh dah ngocok, tunggu dulu lah. Ngocok lagi besok yaa.'),
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

  @override
  void initState() {
    super.initState();
    getUserId();
    Future.delayed(const Duration(milliseconds: 500), () {
      refreshCoupons();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        if (checkDahNgocok()) {
                          showDialogUdahNgocok();
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const ShakeNWin()));
                        }
                      },
                      child: const Text('Shake N Win')),
                  ElevatedButton(
                      onPressed: () {}, child: const Text('Redeem Code'))
                ],
              ),
            ),
            Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : coupons.isEmpty
                        ? const Text('Yah Belum ada kupon, ngocok dulu ga sii')
                        : showCouponsList())
          ],
        ),
      ),
    );
  }

  Widget showCouponsList() {
    return RefreshIndicator(
      onRefresh: () async {
        await refreshCoupons();
      },
      child: ListView.builder(
          itemCount: coupons.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Card(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Diskon ${coupons[index]['discount']}%',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            )),
                        const SizedBox(
                          height: 20,
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                              'Expires at ${formatDate(coupons[index]['expires_at'])}'),
                        )
                      ],
                    ),
                  )),
            );
          }),
    );
  }

  String formatDate(String dateTime) {
    return DateFormat('EEEE, dd-MMM-yyyy').format(DateTime.parse(dateTime));
  }

  Future<void> deleteExpiredCoupons(int id) async {
    await SQLHelperUser.deleteExpiredCoupons(id);
  }
}
