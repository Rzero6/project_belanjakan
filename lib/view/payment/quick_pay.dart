import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:intl/intl.dart';
=======
>>>>>>> 51c53a3e0cadf21180d4679fcefebd29bd8f25aa
import 'package:project_belanjakan/database/sql_helper_items.dart';
import 'package:project_belanjakan/model/item.dart';
import 'package:project_belanjakan/view/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuickPayView extends StatefulWidget {
  final int id;
  const QuickPayView({super.key, required this.id});

  @override
  State<QuickPayView> createState() => _QuickPayViewState();
}

class _QuickPayViewState extends State<QuickPayView> {
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
<<<<<<< HEAD
    final currencyFormat =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp.');
    //Data Dummy
    int ongkosKirim = 15000;
    int adminFee = 1000;
    int quantity = 1;

=======
>>>>>>> 51c53a3e0cadf21180d4679fcefebd29bd8f25aa
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: const Icon(Icons.shopify),
<<<<<<< HEAD
      ),
      body: SingleChildScrollView(
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 250,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                              'assets/images/${items!.picture!}.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          items!.name!,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 30),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'Detail produk: ',
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(items!.detail!),
=======
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) {
                  removeLoginData();
                  return const Loginview();
                }),
              );
            },
            icon: const Icon(Icons.logout),
            color: const Color(0xFF323232),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Card(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                clipBehavior: Clip.hardEdge,
                child: InkWell(
                  splashColor: Colors.blue.withAlpha(30),
                  onTap: () {},
                  child: SizedBox(
                    height: 150,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 100,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                  '${'assets/images/${items!.picture!}'}.jpg'),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                topLeft: Radius.circular(10)),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: SizedBox(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      items!.name!,
                                      style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Text(
                                      'Rp. ${items!.price!}',
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 25,
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      items!.detail!,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
>>>>>>> 51c53a3e0cadf21180d4679fcefebd29bd8f25aa
                        ),
                      ],
                    ),
                  ),
<<<<<<< HEAD
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Expanded(
                        child: Column(
                          children: [
                            ListTile(
                              leading: Text('Harga Barang x $quantity'),
                              trailing:
                                  Text(currencyFormat.format(items!.price!)),
                              dense: true,
                            ),
                            ListTile(
                              leading: const Text('Ongkos Kirim'),
                              trailing:
                                  Text(currencyFormat.format(ongkosKirim)),
                              dense: true,
                            ),
                            ListTile(
                              leading: const Text('Biaya Admin'),
                              trailing: Text(currencyFormat.format(adminFee)),
                              dense: true,
                            ),
                            ListTile(
                              leading: const Text(
                                'Total Biaya',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              dense: true,
                              trailing: Text(
                                  currencyFormat.format(
                                      items!.price! * quantity +
                                          ongkosKirim +
                                          adminFee),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      )),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 8.0),
                    child: SizedBox(
                      height: 45,
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () {
                            //PAGE BAYAARRR
                          },
                          child: const Text(
                            'Bayar',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          )),
                    ),
                  ),
                ],
              ),
=======
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Card(
                  // SINI
                  ),
            )
          ],
        ),
>>>>>>> 51c53a3e0cadf21180d4679fcefebd29bd8f25aa
      ),
    );
  }

  Future<void> removeLoginData() async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    sharedPrefs.clear();
  }
}
