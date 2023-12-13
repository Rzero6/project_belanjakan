import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_belanjakan/component/dialog.dart';
import 'package:project_belanjakan/component/snackbar.dart';
import 'package:project_belanjakan/model/item.dart';
import 'package:project_belanjakan/model/transaction.dart';
import 'package:project_belanjakan/services/api/item_client.dart';
import 'package:project_belanjakan/services/api/transaction_client.dart';
import 'package:project_belanjakan/view/input_review.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:riverpod/riverpod.dart';

class OrderListView extends ConsumerStatefulWidget {
  final bool canReview;
  final int id;
  const OrderListView(this.canReview, this.id, {super.key});

  @override
  ConsumerState<OrderListView> createState() => _OrderListViewState();
}

class _OrderListViewState extends ConsumerState<OrderListView> {
  final listDetailTransactionProvider =
      FutureProvider.family<List<DetailTransaction>?, int>((ref, search) async {
    Transaction? items = await TransactionClient.findTransaction(search);
    List<DetailTransaction>? detailItems = items.listDetails;
    return detailItems;
  });

  @override
  Widget build(BuildContext context) {
    bool isLoading = false;
    var itemListener = ref.watch(listDetailTransactionProvider(widget.id));
    return Scaffold(
      body: isLoading == true
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              padding: EdgeInsets.only(top: 2.h, bottom: 2.h),
              child: SizedBox(
                child: itemListener.when(
                  data: (data) => ListView.builder(
                    itemCount: data!.length,
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () async {
                        if (!widget.canReview) return;
                        if (data[index].rated == 1) return;
                        setState(() {
                          isLoading = true;
                        });
                        List<Item> litem =
                            await ItemClient.getItems(data[index].name, 0);

                        if (litem.isEmpty) {
                          CustomSnackBar.showSnackBar(
                              context,
                              'Data tidak ditemukan, mungkin telah dihapus seller / admin',
                              Colors.red);
                          await TransactionClient.updateRatedDetailsTransaction(
                              data[index].id);
                          Navigator.pop(context);
                        }

                        setState(() {
                          isLoading = false;
                        });

                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => InputReview(
                                idItem: litem.first.id,
                                idDetail: data[index].id,
                              ),
                            ));
                      },
                      child: SizedBox(
                        height: 8.h,
                        child: Padding(
                          padding: EdgeInsets.only(left: 4.w),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(data[index].name),
                                Text('Jumlah : ${data[index].amount}')
                              ]),
                        ),
                      ),
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
            ),
    );
  }
}
