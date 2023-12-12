import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_belanjakan/component/dialog.dart';
import 'package:project_belanjakan/model/transaction.dart';
import 'package:project_belanjakan/services/api/item_client.dart';
import 'package:project_belanjakan/services/api/transaction_client.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:riverpod/riverpod.dart';

class OrderListView extends ConsumerStatefulWidget {
  final String status;
  const OrderListView(this.status, {super.key});

  @override
  ConsumerState<OrderListView> createState() => _OrderListViewState();
}

class _OrderListViewState extends ConsumerState<OrderListView> {
  final listTransactionProvider =
      FutureProvider.family<List<Transaction>?, String>((ref, search) async {
    List<Transaction>? items = await TransactionClient.getTransactionsPerUser();
    if (items.isEmpty) {
      List<Transaction> filteredItems =
          items.where((element) => element.status == search).toList();
      return filteredItems;
    } else {
      return null;
    }
  });

  @override
  Widget build(BuildContext context) {
    var itemListener = ref.watch(listTransactionProvider(widget.status));
    return Scaffold(
      body: SizedBox(
        child: itemListener.when(
          data: (data) => ListView.builder(
            itemBuilder: (context, index) => SizedBox(
              height: 8.h,
              child: Row(children: [
                Text(data![index].id.toString()),
                Text(data[index].paymentMethod)
              ]),
            ),
          ),
          error: (err, s) => Center(
            child: Text(err.toString()),
          ),
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
