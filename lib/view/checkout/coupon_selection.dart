import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:project_belanjakan/model/coupon.dart';
import 'package:project_belanjakan/services/api/coupon_client.dart';

class CouponsSelectionPage extends ConsumerStatefulWidget {
  final int couponId;
  const CouponsSelectionPage({
    super.key,
    required this.couponId,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CouponsSelectionPageState();
}

class _CouponsSelectionPageState extends ConsumerState<CouponsSelectionPage> {
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
    selectedCouponId = widget.couponId;
  }

  onRefresh(context, ref) async {
    ref.refresh(listCouponProvider(token));
  }

  onSelect() {
    Navigator.pop(context, selectedCouponId);
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
    return WillPopScope(
      onWillPop: () async {
        onSelect();
        return false;
      },
      child: Scaffold(
        body: couponListener.when(
          data: (coupons) {
            deleteExpiredCoupons(coupons);
            return Column(
              children: [
                Expanded(
                  child: RefreshIndicator(
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
                              child: couponInCard(coupons[index], context, ref,
                                  selectedCouponId)),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 8.h,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 1.h, horizontal: 1.h),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0077B6),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          ),
                        ),
                        onPressed: () => onSelect(),
                        child: const Text('Select')),
                  ),
                )
              ],
            );
          },
          error: (err, s) => Center(
            child: Text(err.toString()),
          ),
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
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
