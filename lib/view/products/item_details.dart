import 'package:flutter/material.dart';
import 'package:project_belanjakan/database/sql_helper_items.dart';
import 'package:project_belanjakan/model/item.dart';
import 'package:project_belanjakan/view/payment/quick_pay.dart';

class ProductDetailScreen extends StatefulWidget {
  final int id;

  const ProductDetailScreen({super.key, required this.id});

  @override
  // ignore: library_private_types_in_public_api
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  Item? items;
  bool isLoading = false;

  void refresh(int num) async {
    setState(() {
      isLoading = true;
    });
    try {
      final data = await SQLHelperItem.getItemById(num);
      setState(() {
        items = data;
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    refresh(widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFfafafa),
      body: FutureBuilder(
        future: SQLHelperItem.getItemById(widget.id),
        builder: (context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return createDetailView(context, snapshot, items!);
              }
          }
        },
      ),
      bottomNavigationBar: BottomNavBar(id: widget.id),
    );
  }
}

class BottomNavBar extends StatelessWidget {
  final int id;
  const BottomNavBar({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 10, bottom: 20),
      child: Row(
        children: <Widget>[
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
                side: BorderSide(
                  color: Color(0xFFfef2f2),
                ),
              ),
            ),
            onPressed: () {
              //ADD TO CART
            },
            child: Container(
              padding:
                  const EdgeInsets.only(left: 5, right: 5, top: 15, bottom: 15),
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
                      builder: (_) => QuickPayView(id: id),
                    ));
              },
              child: Container(
                padding: const EdgeInsets.only(
                    left: 5, right: 5, top: 15, bottom: 15),
                child: Text("Buy now".toUpperCase(),
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFFFFFFFF))),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget createDetailView(
    BuildContext context, AsyncSnapshot snapshot, Item items) {
  return DetailScreen(
    key: null,
    productDetails: items,
  );
}

// ignore: must_be_immutable
class DetailScreen extends StatelessWidget {
  Item productDetails;

  DetailScreen({Key? key, required this.productDetails}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Image.asset(
            '${'assets/images/${productDetails.picture}'}.jpg',
            fit: BoxFit.fill,
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            padding:
                const EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 20),
            child: Text("${productDetails.name}".toUpperCase(),
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            padding:
                const EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 20),
            color: const Color(0xFFFFFFFF),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Price".toUpperCase(),
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF565656))),
                Text(
                    "Rp. ${(productDetails.price != null) ? productDetails.price : "Unavailable"}"
                        .toUpperCase(),
                    style: const TextStyle(
                        color: Colors.blue,
                        fontFamily: 'Roboto-Light.ttf',
                        fontSize: 20,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            alignment: Alignment.topLeft,
            width: double.infinity,
            padding:
                const EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 20),
            color: const Color(0xFFFFFFFF),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text("Description",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF565656))),
                const SizedBox(
                  height: 15,
                ),
                Text("${productDetails.detail}",
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF4c4c4c))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
