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
  final listCouponProvider =
      FutureProvider.family<List<Coupon>, String>((ref, token) async {
    return await CouponClient.getCoupons(token);
  });
  final tokenProvider = FutureProvider<String>((ref) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token')!;
    return token;
  });

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
  }

  @override
  Widget build(BuildContext context) {
    var tokenListener = ref.watch(tokenProvider);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const ShakeNWin()))
                .then((value) => ref.refresh(listCouponProvider(token)));
          },
          child: const Icon(Icons.phonelink_ring_rounded)),
      appBar: AppBar(
          elevation: 0.0, centerTitle: true, title: const Text('Coupons')),
      body: tokenListener.when(
        data: (token) {
          var couponListener = ref.watch(listCouponProvider(token));
          return couponListener.when(
            data: (coupons) => RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  ref.refresh(listCouponProvider(token));
                });
              },
              child: ListView.builder(
                itemCount: coupons.length,
                itemBuilder: (context, index) {
                  return couponInCard(coupons[index], context, ref);
                },
              ),
            ),
            error: (err, s) => Center(
              child: Text(err.toString()),
            ),
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (err, s) => Center(
          child: Text(err.toString()),
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
