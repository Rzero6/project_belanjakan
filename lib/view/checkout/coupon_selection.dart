import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:project_belanjakan/component/snackbar.dart';
import 'package:project_belanjakan/model/coupon.dart';
import 'package:project_belanjakan/services/api/coupon_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CouponsSelectionPage extends ConsumerStatefulWidget {
  const CouponsSelectionPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CouponsSelectionPageState();
}

class _CouponsSelectionPageState extends ConsumerState<CouponsSelectionPage> {
  CustomSnackBar customSnackBar = CustomSnackBar();
  late String token;
  bool isLoading = true;
  int selectedCouponId = 0;
  final listCouponProvider =
      FutureProvider.family<List<Coupon>, String>((ref, token) async {
    return await CouponClient.getCoupons(token);
  });

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
      body: couponListener.when(
        data: (coupons) {
          deleteExpiredCoupons(coupons);
          return RefreshIndicator(
            onRefresh: () => onRefresh(context, ref),
            child: ListView.builder(
              itemCount: coupons.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                  child: GestureDetector(
                      onTap: () {
                        setState(() {
                          if (selectedCouponId == coupons[index].id!) {
                            selectedCouponId = 0;
                          } else {
                            selectedCouponId = coupons[index].id!;
                          }
                        });
                      },
                      child: couponInCard(
                          coupons[index], context, ref, selectedCouponId)),
                );
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

  Widget couponInCard(Coupon coupon, context, ref, selectedCouponId) {
    return Card(
        elevation: selectedCouponId == coupon.id ? 8 : 4,
        shape: RoundedRectangleBorder(
            side: BorderSide(
                color: selectedCouponId == coupon.id
                    ? Colors.blue
                    : Colors.transparent,
                width: 2.0),
            borderRadius: const BorderRadius.all(Radius.circular(10))),
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
