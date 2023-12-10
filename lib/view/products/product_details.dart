import 'package:flutter/material.dart';
import 'package:project_belanjakan/component/dialog.dart';
import 'package:project_belanjakan/component/snackbar.dart';
import 'package:project_belanjakan/model/cart.dart';
import 'package:project_belanjakan/model/item.dart';
import 'package:project_belanjakan/services/api/api_client.dart';
import 'package:project_belanjakan/services/api/cart_client.dart';
import 'package:project_belanjakan/services/api/item_client.dart';
import 'package:project_belanjakan/view/payment/quick_pay.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App Title',
      theme: ThemeData(
        primarySwatch: Colors.blue, // Warna primer untuk Navigator
      ),
      home: ProductDetailScreen(id: 1, amount: 1),
    );
  }
}

class ProductDetailScreen extends StatefulWidget {
  final int id;
  final int amount;

  const ProductDetailScreen({
    Key? key,
    required this.id,
    required this.amount,
  }) : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late Item item;
  bool isLoading = true;
  final TextEditingController amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late String token;
  CustomSnackBar customSnackBar = CustomSnackBar();

  void loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      item = await ItemClient.findItem(widget.id);
      token = prefs.getString('token')!;
      setState(() {
        isLoading = false;
      });
    } catch (err) {
      customSnackBar.showSnackBar(context, err.toString(), Colors.red);
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    super.initState();
    loadData();
    amountController.text = widget.amount.toString();
  }

  @override
Widget build(BuildContext context) {
  final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp. ');

  return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.transparent,
      iconTheme: IconThemeData(color: Colors.blue),
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Text(
        item.name,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
      ),
    ),
    body: isLoading
        ? const Center(child: CircularProgressIndicator())
        : Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 35.h,
                          height: 20.h,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            image: DecorationImage(
                              image: NetworkImage(
                                ApiClient().domainName + item.image,
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 4.h, horizontal: 15.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  item.name,
                                  style: const TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'tersisa ${NumberFormat.compact().format(item.stock)}',
                                  style: const TextStyle(
                                    fontSize: 18, color: Colors.black),
                                ),
                              ],
                            ),
                            // Added space between name and price
                            Text(
                              currencyFormat.format(item.price),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 0.1.h, left: 15.w, right: 14.w),
                        child: const Text(
                          'Deskripsi',
                          style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 15.w, vertical: 1.h),
                        child: Text(
                          item.detail,
                          style: const TextStyle(
                            fontSize: 16, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actionButton(),
            ],
          ),
  );
}

  void addToCart(context) async {
    try {
      CustomDialog().showLoadingDialog(context);
      Cart cart = Cart(
          id: 0,
          idUser: 0,
          idItem: item.id,
          amount: int.parse(amountController.text));
      await CartClient.addOrUpdateCart(cart, token);
      Navigator.pop(context);
      customSnackBar.showSnackBar(context, 'Added to Cart', Colors.green);
      Navigator.pop(context);
    } catch (e) {
      Navigator.pop(context);
      customSnackBar.showSnackBar(context, e.toString(), Colors.red);
    }
  }

  Container actionButton() {
  return Container(
    color: Colors.white60,
    height: 16.h,
    padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Spacer(),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF0077B6),
            foregroundColor: Colors.white,
            elevation: 0,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                bottomLeft: Radius.circular(30),
                topRight: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
          ),
          onPressed: () {
            addToCart(context);
          },
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 2.h),
            child: Center(
              child: Text(
                "Add to Cart".toUpperCase(),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 10.0), // Tambahkan SizedBox di sini
        Text(
          "Something do you like",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    ),
  );
}
}