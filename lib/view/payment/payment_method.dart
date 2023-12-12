import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class PaymentScreen extends StatefulWidget {
  String selectedPaymentMethod;
  PaymentScreen({super.key, required this.selectedPaymentMethod});
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  void initState() {
    super.initState();
    selectPaymentMethod(widget.selectedPaymentMethod);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Method'),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Payment Method',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20.0),
            PaymentMethodTile(
              imagePath: 'assets/images/visa.png',
              name: 'VISA',
              onTap: () async {
                selectPaymentMethod('Visa');
              },
              isSelected: widget.selectedPaymentMethod == 'Visa',
            ),
            PaymentMethodTile(
              imagePath: 'assets/images/dana.png',
              name: 'DANA',
              onTap: () async {
                selectPaymentMethod('Dana');
              },
              isSelected: widget.selectedPaymentMethod == 'Dana',
            ),
            PaymentMethodTile(
              imagePath: 'assets/images/gopay.png',
              name: 'GoPay',
              onTap: () async {
                selectPaymentMethod('Gopay');
              },
              isSelected: widget.selectedPaymentMethod == 'Gopay',
            ),
            PaymentMethodTile(
              imagePath: 'assets/images/shopeepay.png',
              name: 'Shopee Pay',
              onTap: () async {
                selectPaymentMethod('ShopeePay');
              },
              isSelected: widget.selectedPaymentMethod == 'ShopeePay',
            ),
            PaymentMethodTile(
              imagePath: 'assets/images/ovo.png',
              name: 'OVO',
              onTap: () async {
                selectPaymentMethod('Ovo');
              },
              isSelected: widget.selectedPaymentMethod == 'Ovo',
            ),
            const Expanded(
              child: SizedBox.expand(),
            ),
            const SizedBox(height: 20.0),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: () {
                    if (widget.selectedPaymentMethod.isNotEmpty) {
                      Navigator.pop(context, widget.selectedPaymentMethod);
                    } else {
                      Fluttertoast.showToast(
                        msg: 'Please select a payment method',
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text('Select Payment Method'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void selectPaymentMethod(String paymentMethod) {
    setState(() {
      widget.selectedPaymentMethod = paymentMethod;
    });
  }

  Future<File?> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }
}

class PaymentMethodTile extends StatelessWidget {
  final String imagePath;
  final String name;
  final Function onTap;
  final bool isSelected;

  const PaymentMethodTile({
    super.key,
    required this.imagePath,
    required this.name,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.white,
            width: 2.0,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                imagePath,
                width: 50.0,
                height: 50.0,
              ),
              Text(name,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class NextPage extends StatelessWidget {
  final String selectedPaymentMethod;
  final double totalAmount;

  const NextPage({
    super.key,
    required this.selectedPaymentMethod,
    required this.totalAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Method'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Selected Payment Method: $selectedPaymentMethod'),
            Text('Total Amount: ${formatCurrency(totalAmount)}'),
          ],
        ),
      ),
    );
  }
}

String formatCurrency(double amount) {
  final currencyFormatter =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp');
  return currencyFormatter.format(amount);
}
