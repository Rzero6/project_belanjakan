import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_belanjakan/model/delivery_method.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

// ignore: must_be_immutable
class DeliverySelection extends StatefulWidget {
  DeliveryMethod deliveryMethod;
  DeliverySelection({super.key, required this.deliveryMethod});
  @override
  // ignore: library_private_types_in_public_api
  _DeliverySelectionState createState() => _DeliverySelectionState();
}

class _DeliverySelectionState extends State<DeliverySelection> {
  final List<DeliveryMethod> deliveryMethods = [
    DeliveryMethod(name: 'Normal', cost: 15000),
    DeliveryMethod(name: 'Express', cost: 25000),
    DeliveryMethod(name: 'One Day', cost: 50000)
  ];
  late DeliveryMethod selectedDelivery;
  @override
  void initState() {
    super.initState();
    selectedDelivery = widget.deliveryMethod;
  }

  onSelect() {
    Navigator.pop(context, selectedDelivery);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        onSelect();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Delivery Method'),
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 4.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select Delivery Method',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              SizedBox(
                height: 30.h,
                child: ListView.builder(
                  itemCount: deliveryMethods.length,
                  itemBuilder: (context, index) {
                    return itemCard(deliveryMethods[index]);
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.w),
                child: SizedBox(
                    width: double.infinity,
                    height: 6.h,
                    child: ElevatedButton(
                        onPressed: () => onSelect(),
                        child: const Text('Select'))),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget itemCard(DeliveryMethod delivery) {
    return SizedBox(
      height: 8.h,
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedDelivery = delivery;
          });
        },
        child: Card(
          elevation: selectedDelivery.name == delivery.name ? 8 : 4,
          shape: RoundedRectangleBorder(
              side: BorderSide(
                  color: selectedDelivery.name == delivery.name
                      ? Colors.blue
                      : Colors.transparent,
                  width: 2.0),
              borderRadius: const BorderRadius.all(Radius.circular(10))),
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(delivery.name),
                  Text(formatCurrency(delivery.cost))
                ],
              )),
        ),
      ),
    );
  }

  String formatCurrency(int amount) {
    final currencyFormatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp. ');
    return currencyFormatter.format(amount);
  }
}
