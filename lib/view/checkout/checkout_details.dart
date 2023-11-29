import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_belanjakan/model/address.dart';
import 'package:project_belanjakan/model/coupon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:project_belanjakan/model/cart.dart';
import 'package:project_belanjakan/view/address/input_address.dart';

class CheckoutDetails extends StatelessWidget {
  final List<Cart> listCart;
  final Address currentAddress;
  const CheckoutDetails({
    Key? key,
    required this.listCart,
    required this.currentAddress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Address deliveryAddress = currentAddress;
    Coupon coupon = Coupon(
        name: "Test",
        idUser: 1,
        discount: 20,
        code: "TESTCODE",
        expiresAt: "expiresAt");
    int ongkir = 16000;

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
            itemDetailsPrice(listCart, ongkir.toDouble(), coupon),
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
                    Text(currentAddress.jalan!),
                    Text(
                        '${currentAddress.kelurahan!}, ${currentAddress.kecamatan!}'),
                    Text(
                        '${currentAddress.kabupaten!}, ${currentAddress.kodePos!}'),
                    Text(currentAddress.provinsi!),
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

  Widget itemDetailsPrice(List<Cart> carts, double ongkir, Coupon coupon) {
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
                title: const Text('Diskon'),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${coupon.name} ${coupon.discount}%'),
                    Text(
                        '- ${currencyFormat.format(calculateDiskon(coupon.discount.toDouble(), calculateAllItem(carts)))}')
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
                child: Image.file(carts[cartIndex].item!.imageFile!,
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
