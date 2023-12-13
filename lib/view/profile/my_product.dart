import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:navigation_view/item_navigation_view.dart';
import 'package:navigation_view/navigation_view.dart';
import 'package:project_belanjakan/model/transaction.dart';
import 'package:project_belanjakan/services/api/transaction_client.dart';
import 'package:project_belanjakan/view/profile/order_list.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class MyProduct extends ConsumerStatefulWidget {
  const MyProduct({super.key});

  @override
  ConsumerState<MyProduct> createState() => _MyProductState();
}

class _MyProductState extends ConsumerState<MyProduct> {
  final TextEditingController _controller = TextEditingController();
  final listTransactionProvider =
      FutureProvider.family<List<Transaction>?, String>((ref, search) async {
    List<Transaction>? items = await TransactionClient.getTransactionsPerUser();
    if (items.isNotEmpty) {
      List<Transaction> filteredItems =
          items.where((element) => element.status == search).toList();

      return filteredItems;
    } else {
      return null;
    }
  });

  @override
  void initState() {
    _controller.text = 'delivered';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var itemListener = ref.watch(listTransactionProvider(_controller.text));
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Products'),
      ),
      body: Column(
        children: [
          NavigationView(
            onChangePage: (c) {
              switch (c) {
                case 2:
                  setState(() {
                    _controller.text = 'ordered';
                  });
                case 1:
                  setState(() {
                    _controller.text = 'ondelivery';
                  });
                case 0:
                  setState(() {
                    _controller.text = 'delivered';
                  });
              }
            },
            curve: Curves.easeIn,
            durationAnimation: const Duration(milliseconds: 400),
            items: [
              ItemNavigationView(
                childAfter: const Text('Delivered',
                    style: TextStyle(color: Colors.blue)),
                childBefore: Text('Delivered',
                    style: TextStyle(color: Colors.grey.withAlpha(60))),
              ),
              ItemNavigationView(
                childAfter: const Text('On Delivery',
                    style: TextStyle(color: Colors.blue)),
                childBefore: Text('On Delivery',
                    style: TextStyle(color: Colors.grey.withAlpha(60))),
              ),
              ItemNavigationView(
                childAfter:
                    const Text('Ordered', style: TextStyle(color: Colors.blue)),
                childBefore: Text('Ordered',
                    style: TextStyle(color: Colors.grey.withAlpha(60))),
              ),
            ],
          ),
          SizedBox(
            height: 1.h,
          ),
          Expanded(
            child: itemListener.when(
              data: (data) {
                if (data != null && data.isNotEmpty) {
                  return ListView.builder(
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  OrderListView(false, data[index].id),
                            ));
                      },
                      child: SizedBox(
                        height: 8.h,
                        child: Container(
                          decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: Colors.grey, width: 1.0))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(data[index].id.toString()),
                              Text(data[index].paymentMethod),
                            ],
                          ),
                        ),
                      ),
                    ),
                    itemCount: data.length,
                  );
                } else {
                  return const Center(child: Text('No data available.'));
                }
              },
              error: (err, s) => Center(
                child: Text(err.toString()),
              ),
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
