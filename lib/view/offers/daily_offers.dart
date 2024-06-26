import 'package:flutter/material.dart';
import 'package:project_belanjakan/view/offers/coupons/coupons_page.dart';

class DailyOffers extends StatefulWidget {
  const DailyOffers({super.key});

  @override
  State<DailyOffers> createState() => _DailyOffersState();
}

class _DailyOffersState extends State<DailyOffers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const CouponsPage()));
                },
                child: const Text('Coupons')),
            const Text('Coming soon'),
          ],
        ),
      ),
    );
  }
}
