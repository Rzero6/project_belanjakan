import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_belanjakan/model/address.dart';
import 'package:project_belanjakan/model/coupon.dart';
import 'package:project_belanjakan/services/api/api_client.dart';
import 'package:project_belanjakan/view/checkout/coupon_selection.dart';
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

int idCoupon = 0;

void gotoSelectionCoupon(context) {
  Navigator.push(context,
          MaterialPageRoute(builder: (_) => const CouponsSelectionPage()))
      .then((value) => value = idCoupon);
}

class _CheckoutDetailsState extends State<CheckoutDetails> {
  @override
  Widget build(BuildContext context) {
    Address deliveryAddress = widget.currentAddress;
    Coupon coupon = Coupon(
        name: "Test",
        idUser: 1,
        discount: 20,
        code: "TESTCODE",
        expiresAt: "expiresAt");
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
            itemDetailsPrice(widget.listCart, ongkir, coupon, context)
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

  Widget itemDetailsPrice(
      List<Cart> carts, double ongkir, Coupon coupon, context) {
    final currencyFormat =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp. ');
    return Expanded(
      child: ListView.builder(
          itemCount: (carts.length + 3) * 2,
          itemBuilder: (context, index) {
            if (index.isOdd) {
              return const Divider(
                height: 0,
              );
            }
            if (index == (carts.length) * 2) {
              return ListTile(
                title: const Text('Pengiriman'),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('J&T'),
                    Text(currencyFormat.format(ongkir))
                  ],
                ),
                trailing: const Icon(Icons.arrow_forward_ios_rounded),
              );
            }
            if (index == (carts.length + 1) * 2) {
              return ListTile(
                onTap: () => gotoSelectionCoupon(context),
                title: const Text('Diskon'),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(idCoupon == 0
                        ? 'Tekan untuk pilih kupon'
                        : '${coupon.name} ${coupon.discount}%'),
                    Text(idCoupon == 0
                        ? '0%'
                        : '- ${currencyFormat.format(calculateDiskon(coupon.discount.toDouble(), calculateAllItem(carts)))}')
                  ],
                ),
                trailing: const Icon(Icons.arrow_forward_ios_rounded),
              );
            }
            if (index == (carts.length + 2) * 2) {
              return ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Harga'),
                    Text(currencyFormat.format(calculateAll(ongkir,
                        coupon.discount.toDouble(), calculateAllItem(carts))))
                  ],
                ),
              );
            }

            final cartIndex = index ~/ 2;
            return ListTile(
              leading: SizedBox(
                width: 15.w,
                child: Image.network(
                    ApiClient().domainName + carts[cartIndex].item!.image,
                    fit: BoxFit.cover),
              ),
              title: Text(carts[cartIndex].item!.name),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(currencyFormat.format(carts[cartIndex].item!.price)),
                  Text('x${carts[cartIndex].amount}'),
                  Text(currencyFormat.format(calculatePricePerItem(
                      carts[cartIndex].amount.toDouble(),
                      carts[cartIndex].item!.price.toDouble())))
                ],
              ),
            );
          }),
    );
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
