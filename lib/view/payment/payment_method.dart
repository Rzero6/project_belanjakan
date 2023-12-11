import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Payment Method UI',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PaymentScreen(),
    );
  }
}

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String selectedPaymentMethod = '';
  double totalAmount = 7590000;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Method'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          }
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Payment Method',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.0),
            PaymentMethodTile(
              imagePath: 'assets/images/QRIS.png',
              totalAmount: totalAmount,
              onTap: () async {
                selectPaymentMethod('Qris');
              },
              isSelected: selectedPaymentMethod == 'Qris',
            ),
            PaymentMethodTile(
              imagePath: 'assets/images/visa.png',
              totalAmount: totalAmount,
              onTap: () async {
                selectPaymentMethod('Visa');
              },
              isSelected: selectedPaymentMethod == 'Visa',
            ),
            PaymentMethodTile(
              imagePath: 'assets/images/dana.png',
              totalAmount: totalAmount,
              onTap: () async {
                selectPaymentMethod('Dana');
              },
              isSelected: selectedPaymentMethod == 'Dana',
            ),
            PaymentMethodTile(
              imagePath: 'assets/images/gopay.png',
              totalAmount: totalAmount,
              onTap: () async {
                selectPaymentMethod('Gopay');
              },
              isSelected: selectedPaymentMethod == 'Gopay',
            ),
            PaymentMethodTile(
              imagePath: 'assets/images/shopeepay.png',
              totalAmount: totalAmount,
              onTap: () async {
                selectPaymentMethod('ShopeePay');
              },
              isSelected: selectedPaymentMethod == 'ShopeePay',
            ),
            PaymentMethodTile(
              imagePath: 'assets/images/ovo.png',
              totalAmount: totalAmount,
              onTap: () async {
                selectPaymentMethod('Ovo');
              },
              isSelected: selectedPaymentMethod == 'Ovo',
            ),
            Expanded(
              child: SizedBox.expand(),
            ),
            SizedBox(
              height: 20.0
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: () {
                    if (selectedPaymentMethod.isNotEmpty) {
                      Navigator.push(
                        context, 
                        MaterialPageRoute(
                          builder: (context) => NextPage(
                            selectedPaymentMethod: selectedPaymentMethod,
                            totalAmount: totalAmount,
                          ),
                        ),
                      );
                    } else {
                      print('Please select a payment method');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    onPrimary: Colors.white,
                  ),
                  child: Text('Select Payment Method'),
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
        selectedPaymentMethod = paymentMethod;
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
  final double totalAmount;
  final Function onTap;
  final bool isSelected;

  const PaymentMethodTile({               
    required this.imagePath,                                                
    required this.totalAmount,
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
        child : Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                imagePath,
                width: 50.0,
                height: 50.0,
              ),
              Text(
                formatCurrency(totalAmount),
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                )
              ),
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

  NextPage({
    required this.selectedPaymentMethod,
    required this.totalAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Method'),
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
  final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp');
  return currencyFormatter.format(amount);
}

