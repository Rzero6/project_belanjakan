import 'package:flutter/material.dart';
import 'package:project_belanjakan/database/sql_helper_items.dart';
import 'package:project_belanjakan/model/item.dart';
import 'package:project_belanjakan/view/payment/payment_verification.dart';
import 'package:project_belanjakan/view/qr_scan/scan_qr_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

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
    final currencyFormat =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp.');
    //Data Dummy
    int ongkosKirim = 15000;
    int adminFee = 1000;
    int quantity = 1;

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: const Icon(Icons.shopify),
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
                        ),
                      ],
                    ),
                  ),
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
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        const BarcodeScannerPageView()));
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
      ),
    );
  }

  Future<void> removeLoginData() async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    sharedPrefs.clear();
  }
}
