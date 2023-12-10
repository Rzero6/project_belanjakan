import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_belanjakan/model/address.dart';
import 'package:project_belanjakan/model/coupon.dart';
import 'package:project_belanjakan/services/api/api_client.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:project_belanjakan/model/cart.dart';
import 'package:project_belanjakan/view/address/input_address.dart';

class CheckoutDetails extends StatefulWidget {
  final List<Cart> listCart;
  final Address currentAddress;
  const CheckoutDetails({
    Key? key,
    required this.listCart,
    required this.currentAddress,
  }) : super(key: key);

  @override
  _CheckoutDetailsState createState() => _CheckoutDetailsState();
}

class _CheckoutDetailsState extends State<CheckoutDetails> {
  OverlayEntry? overlayEntry;

  @override
  Widget build(BuildContext context) {
    Address deliveryAddress = widget.currentAddress;
    Coupon coupon = Coupon(
        name: "Test",
        idUser: 1,
        discount: 20,
        code: "TESTCODE",
        expiresAt: "expiresAt"
    );
    double ongkir = 16000;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: Center(
        child: Column(
          children: [
            addressPicker(context, deliveryAddress),
            const Divider(
              height: 0,
            ),
            ElevatedButton(
              onPressed: () {
                _showOrderDetails(ongkir, coupon, widget.listCart);
              },
              child: const Text('Show Order Details'),
            ),
          ],
        ),
      ),
    );
  }

  Widget addressPicker(context, deliveryAddress) {
    return InkWell(
      splashColor: Colors.blue,
      onTap: () async {
        final address = await Navigator.push(
            context, MaterialPageRoute(builder: (_) => const InputAddress()));
        if (address != null) {
          deliveryAddress = address;
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 2.h),
        child: SizedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                  width: 5.w,
                  child: const Icon(Icons.location_on, color: Colors.blue)),
              SizedBox(
                width: 60.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(deliveryAddress.jalan!),
                    Text(
                        '${deliveryAddress.kelurahan!}, ${deliveryAddress.kecamatan!}'),
                    Text(
                        '${deliveryAddress.kabupaten!}, ${deliveryAddress.kodePos!}'),
                    Text(deliveryAddress.provinsi!),
                  ],
                ),
              ),
              SizedBox(
                width: 10.w,
                child: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.black54,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderDetails(double ongkir, Coupon coupon, List<Cart> carts) {
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp. ');
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  _removeOverlay();
                },
              ),
            ],
          ),
          ListTile(
            title: const Text('Pengiriman'),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('J&T'),
                Text(currencyFormat.format(ongkir))
              ],
            ),
          ),
          ListTile(
            title: const Text('Diskon'),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${coupon.name} ${coupon.discount}%'),
                Text(
                  '- ${currencyFormat.format(calculateDiskon(coupon.discount.toDouble(), calculateAllItem(carts)))}',
                )
              ],
            ),
          ),
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${coupon.name} ${coupon.discount}%'),
                Text(currencyFormat.format(calculateAll(ongkir, coupon.discount.toDouble(), calculateAllItem(carts))))
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showOrderDetails(double ongkir, Coupon coupon, List<Cart> carts) {
    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Material(
          color: Colors.transparent,
          child: WillPopScope(
            onWillPop: () async {
              _removeOverlay();
              return true;
            },
            child: Container(
              child: _buildOrderDetails(ongkir, coupon, carts),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context)?.insert(overlayEntry!);
  }

  void _removeOverlay() {
    overlayEntry?.remove();
  }

  double calculatePricePerItem(double amount, double price) {
    return amount * price;
  }

  double calculateAllItem(List<Cart> cart) {
    double totalPrice = 0.0;
    for (Cart item in cart) {
      totalPrice += calculatePricePerItem(
          item.amount.toDouble(), item.item!.price.toDouble());
    }
    return totalPrice;
  }

  double calculateAll(double ongkosKirim, double diskon, double allItem) {
    return (ongkosKirim + allItem) - calculateDiskon(diskon, allItem);
  }

  double calculateDiskon(double diskon, double allItem) {
    return allItem * diskon / 100;
  }
}
