import 'package:flutter/material.dart';
import 'package:project_belanjakan/component/dialog.dart';
import 'package:project_belanjakan/component/snackbar.dart';
import 'package:project_belanjakan/model/cart.dart';
import 'package:project_belanjakan/model/item.dart';
import 'package:project_belanjakan/model/review.dart';
import 'package:project_belanjakan/model/user.dart';
import 'package:project_belanjakan/services/api/api_client.dart';
import 'package:project_belanjakan/services/api/cart_client.dart';
import 'package:project_belanjakan/services/api/item_client.dart';
import 'package:intl/intl.dart';
import 'package:project_belanjakan/services/api/review_client.dart';
import 'package:project_belanjakan/services/api/user_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

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
  late Reviews reviews;
  bool isLoading = true;
  final TextEditingController amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late String token;

  void loadData(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      item = await ItemClient.findItem(widget.id);
      reviews = await ReviewClient.getReviewsPerItem(item.id);
      token = prefs.getString('token')!;
    } catch (err) {
      CustomSnackBar.showSnackBar(context, err.toString(), Colors.red);
      Navigator.pop(context);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    loadData(context);
    amountController.text = widget.amount.toString();
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp. ');
    return isLoading
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              iconTheme: const IconThemeData(color: Color(0xFF0077B6)),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: Text(
                item.name,
                style: const TextStyle(
                    overflow: TextOverflow.ellipsis,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0077B6)),
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 2.h,
                        ),
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
                              vertical: 1.h, horizontal: 10.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name,
                                style: const TextStyle(
                                    fontSize: 35, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 1.h,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    currencyFormat.format(item.price),
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                  Column(
                                    children: [
                                      makeStarRating(reviews.rating),
                                      Text(
                                        'tersisa ${NumberFormat.compact().format(item.stock)}',
                                        style: const TextStyle(
                                            fontSize: 14, color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 1.h, left: 10.w, right: 14.w),
                          child: const Text(
                            'Deskripsi',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 1.h),
                          child: Text(
                            item.detail,
                            style: const TextStyle(
                                fontSize: 16, color: Colors.black),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 1.h),
                          child: const Text(
                            'Reviews',
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        reviewInListTile(),
                      ],
                    ),
                  ),
                ),
                actionButton(),
              ],
            ),
          );
  }

  Future<User> findUser(id) async {
    try {
      return await UserClient.getUserById(id);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Widget reviewInListTile() {
    return SizedBox(
      height: 50.h,
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: reviews.listReviews.length,
        separatorBuilder: (context, index) {
          return const Divider();
        },
        itemBuilder: (context, index) {
          return FutureBuilder<User>(
            future: findUser(reviews.listReviews[index].idUser),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return ListTile(
                  leading: snapshot.data!.profilePicture != null
                      ? Image.network(
                          '${ApiClient().domainName}${snapshot.data!.profilePicture!}')
                      : Image.network(
                          '${ApiClient().domainName}/images/profile.jpg',
                        ),
                  title: Text(snapshot.data!.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(reviews.listReviews[index].detail),
                      makeStarRating(
                          reviews.listReviews[index].rating.toDouble()),
                    ],
                  ),
                  trailing:
                      Text(formatDate(reviews.listReviews[index].createdAt)),
                );
              }
            },
          );
        },
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
          amount: amountController.text.isEmpty
              ? 1
              : int.parse(amountController.text));
      await CartClient.addOrUpdateCart(cart, token);
      Navigator.pop(context);
      CustomSnackBar.showSnackBar(context, 'Added to Cart', Colors.green);
      Navigator.pop(context);
    } catch (e) {
      Navigator.pop(context);
      CustomSnackBar.showSnackBar(context, e.toString(), Colors.red);
    }
  }

  Container actionButton() {
    return Container(
      color: Colors.white60,
      height: 16.h,
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
                      child: TextFormField(
                        onChanged: (value) {
                          if (int.parse(value) > item.stock) {
                            setState(() {
                              amountController.text = item.stock.toString();
                            });
                          }
                          if (int.parse(value) < 1) {
                            setState(() {
                              amountController.text = 1.toString();
                            });
                          }
                        },
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
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0077B6),
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
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row makeStarRating(double rating) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            for (int i = 0; i < 5; i++)
              Icon(
                rating >= i + 1
                    ? Icons.star_rate_rounded
                    : rating >= i + 0.5
                        ? Icons.star_half_rounded
                        : Icons.star_border_rounded,
                color: Colors.orangeAccent,
                size: 15,
              ),
          ],
        )
      ],
    );
  }

  String formatDate(String dateTime) {
    return DateFormat('dd/MM/yyyy').format(DateTime.parse(dateTime));
  }
}
