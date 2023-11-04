import 'package:flutter/material.dart';
import 'package:project_belanjakan/database/sql_helper_items.dart';
import 'package:project_belanjakan/model/item.dart';
import 'package:project_belanjakan/view/address/get_current_location.dart';
import 'package:project_belanjakan/view/address/input_address.dart';
import 'package:project_belanjakan/view/qr_scan/scan_qr_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project_belanjakan/model/address.dart';
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
  Address? currentAddress;

  void refresh(int num) async {
    setState(() {
      isLoading = true;
    });
    try {
      final data = await SQLHelperItem.getItemById(num);
      final addressData = await GetCurrentLocation().getAddressLocation();
      setState(() {
        items = data;
        currentAddress = addressData;
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
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    splashColor: Colors.blue,
                    onTap: () async {
                      final address = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const InputAddress()));
                      if (address != null) {
                        setState(() {
                          currentAddress = address;
                        });
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Icon(Icons.location_on, color: Colors.blue),
                            const SizedBox(
                              width: 8,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(currentAddress!.jalan!),
                                Text(
                                    '${currentAddress?.kelurahan!}, ${currentAddress?.kecamatan!}'),
                                Text(
                                    '${currentAddress?.kabupaten!}, ${currentAddress?.provinsi!}'),
                                Text('${currentAddress?.kodePos!}'),
                              ],
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            const Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Colors.black54,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
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
                        vertical: 10, horizontal: 10),
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
                      child: Column(
                        children: [
                          const Divider(
                            color: Colors.black45,
                          ),
                          rincianHarga('Harga Barang x $quantity',
                              currencyFormat.format(items!.price!)),
                          rincianHarga('Ongkos Kirim',
                              currencyFormat.format(ongkosKirim)),
                          rincianHarga(
                              'Biaya Admin', currencyFormat.format(adminFee)),
                          const SizedBox(
                            height: 25,
                          ),
                          const Divider(
                            color: Colors.black45,
                          ),
                          ListTile(
                            leading: const Text(
                              'Total Biaya',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            dense: true,
                            trailing: Text(
                                currencyFormat.format(items!.price! * quantity +
                                    ongkosKirim +
                                    adminFee),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18)),
                          ),
                        ],
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

  SizedBox rincianHarga(String detail, String harga) {
    return SizedBox(
      height: 20,
      child: Center(
        child: ListTile(
          leading: Text(
            detail,
            style: const TextStyle(
              fontSize: 12,
            ),
          ),
          trailing: Text(
            harga,
            style: const TextStyle(
              fontSize: 12,
            ),
          ),
          dense: true,
        ),
      ),
    );
  }

  Future<void> removeLoginData() async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    sharedPrefs.clear();
  }
}
