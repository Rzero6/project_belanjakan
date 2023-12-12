import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:navigation_view/item_navigation_view.dart';
import 'package:navigation_view/navigation_view.dart';
import 'package:project_belanjakan/view/profile/order_list.dart';

class MyProduct extends StatefulWidget {
  const MyProduct({super.key});

  @override
  State<MyProduct> createState() => _MyProductState();
}

class _MyProductState extends State<MyProduct> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Omae no product'),
      ),
      body: Column(
        children: [
          NavigationView(
            onChangePage: (c) {},
            curve: Curves.easeIn,
            durationAnimation: const Duration(milliseconds: 400),
            items: [
              ItemNavigationView(
                  childAfter: const Text('Delivered',
                      style: TextStyle(color: Colors.blue)),
                  childBefore: Text('Delivered',
                      style: TextStyle(color: Colors.grey.withAlpha(60)))),
              ItemNavigationView(
                  childAfter: const Text('On Delivery',
                      style: TextStyle(color: Colors.blue)),
                  childBefore: Text('On Delivery',
                      style: TextStyle(color: Colors.grey.withAlpha(60)))),
              ItemNavigationView(
                  childAfter: const Text('Ordered',
                      style: TextStyle(color: Colors.blue)),
                  childBefore: Text('Ordered',
                      style: TextStyle(color: Colors.grey.withAlpha(60)))),
            ],
          ),
          PageView(
            controller: _pageController,
            scrollDirection: Axis.horizontal,
            children: const [
              OrderListView('ordered'),
              OrderListView('ordered'),
              OrderListView('ordered'),
            ],
          )
        ],
      ),
    );
  }
}
