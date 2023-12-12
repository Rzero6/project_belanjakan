import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:project_belanjakan/component/snackbar.dart';
import 'package:project_belanjakan/model/coupon.dart';
import 'package:project_belanjakan/services/api/coupon_client.dart';
import 'package:project_belanjakan/view/offers/coupons/shake_n_win.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CouponsPage extends ConsumerStatefulWidget {
  const CouponsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CouponsPageState();
}

class _CouponsPageState extends ConsumerState<CouponsPage> {
  CustomSnackBar customSnackBar = CustomSnackBar();
  late String token;
  bool isLoading = true;
  bool isAllowedToStroke = true;
  final listCouponProvider =
      FutureProvider.family<List<Coupon>, String>((ref, token) async {
    return await CouponClient.getCoupons(token);
  });

  void showDialogUdahNgocok() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Maaf yaa...'),
            content:
                const Text('Shake and Win hanya bisa dilakukan sehari sekali.'),
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

  loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token')!;
    setState(() {
      isLoading = false;
    });
  }

  deleteExpiredCoupons(List<Coupon> coupons) async {
    DateTime now = DateTime.now();
    if (coupons.isEmpty) return;
    for (Coupon coupon in coupons) {
      DateTime expirationDate = DateTime.parse(coupon.expiresAt);
      if (expirationDate.isBefore(now)) {
        await CouponClient.deleteCoupon(coupon.id!, token);
      }
    }
  }

  checkAllowedToStroke(List<Coupon> coupons) async {
    for (Coupon coupon in coupons) {
      if (coupon.code.startsWith("SNW")) {
        isAllowedToStroke = false;
        return;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    loadToken();
  }

  onRefresh(context, ref) async {
    ref.refresh(listCouponProvider(token));
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
          body: Center(
        child: CircularProgressIndicator(),
      ));
    }
    var couponListener = ref.watch(listCouponProvider(token));
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            isAllowedToStroke
                ? Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const ShakeNWin()))
                    .then((value) => ref.refresh(listCouponProvider(token)))
                : showDialogUdahNgocok();
          },
          child: const Icon(Icons.phonelink_ring_rounded)),
      body: couponListener.when(
        data: (coupons) {
          deleteExpiredCoupons(coupons);
          checkAllowedToStroke(coupons);
          return RefreshIndicator(
            onRefresh: () => onRefresh(context, ref),
            child: ListView.builder(
              itemCount: coupons.length,
              itemBuilder: (context, index) {
                return couponInCard(coupons[index], context, ref);
              },
            ),
          );
        },
        error: (err, s) => Center(
          child: Text(err.toString()),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget couponInCard(Coupon coupon, context, ref) {
    return Card(
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
                    coupon.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  )),
              const SizedBox(
                height: 20,
              ),
              Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Diskon ${coupon.discount}%',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  )),
              const SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Text('Expires at ${formatDate(coupon.expiresAt)}'),
              )
            ],
          ),
        ));
  }

  String formatDate(String dateTime) {
    return DateFormat('EEEE, dd-MMM-yyyy').format(DateTime.parse(dateTime));
  }
}
