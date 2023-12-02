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

class ProductDetailScreen extends StatefulWidget {
  final int id;
  final int amount;
  const ProductDetailScreen(
      {super.key, required this.id, required this.amount});

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
    final currencyFormat =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp. ');

    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                          width: double.infinity,
                          height: 40.h,
                          child: Image.network(
                            ApiClient().domainName + item.image,
                            fit: BoxFit.cover,
                          )),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 1.h, horizontal: 2.w),
                        child: Text(
                          item.name,
                          style: const TextStyle(
                              fontSize: 26, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 1.h, horizontal: 2.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              currencyFormat.format(item.price),
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue),
                            ),
                            Text(
                                'tersisa ${NumberFormat.compact().format(item.stock)}')
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(top: 3.h, left: 2.w, right: 2.w),
                        child: const Text(
                          'Deskripsi',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 3.w, vertical: 1.h),
                        child: Text(
                          item.detail,
                          style:
                              const TextStyle(fontSize: 16, color: Colors.blue),
                        ),
                      ),
                    ],
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
      padding: EdgeInsets.only(left: 5.w, right: 5.w),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Jumlah',
                  style: TextStyle(fontSize: 18),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                        onPressed: () {
                          if (amountController.text.isEmpty) {
                            setState(() {
                              amountController.text = 1.toString();
                            });
                          }
                          if (int.parse(amountController.text) > 1) {
                            setState(() {
                              amountController.text =
                                  (int.parse(amountController.text) - 1)
                                      .toString();
                            });
                          }
                        },
                        icon: const Icon(Icons.remove)),
                    SizedBox(
                      width: 5.w,
                      child: TextField(
                        controller: amountController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: '1',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          if (amountController.text.isEmpty) {
                            setState(() {
                              amountController.text = 1.toString();
                            });
                          }
                          if (int.parse(amountController.text) < item.stock) {
                            setState(() {
                              amountController.text =
                                  (int.parse(amountController.text) + 1)
                                      .toString();
                            });
                          }
                        },
                        icon: const Icon(Icons.add))
                  ],
                )
              ],
            ),
            Row(
              children: [
                const Icon(
                  Icons.favorite_border,
                  color: Color(0xFF5e5e5e),
                ),
                const Spacer(),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade100,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10)),
                    ),
                  ),
                  onPressed: () {
                    addToCart(context);
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 1.w, vertical: 2.h),
                    child: Text("Add to cart".toUpperCase(),
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.blue.shade600)),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(10)),
                        side: BorderSide(color: Colors.blue)),
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {},
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => QuickPayView(
                                id: widget.id,
                                quantity: int.parse(amountController.text)),
                          ));
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 1.w, vertical: 2.h),
                      child: Text(
                        "Buy now".toUpperCase(),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFFFFFFFF),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
