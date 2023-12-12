import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:project_belanjakan/component/dialog.dart';
import 'package:project_belanjakan/component/snackbar.dart';
import 'package:project_belanjakan/model/address.dart';
import 'package:project_belanjakan/model/cart.dart';
import 'package:project_belanjakan/model/transaction.dart';
import 'package:project_belanjakan/model/user.dart';
import 'package:project_belanjakan/services/api/api_client.dart';
import 'package:project_belanjakan/services/api/cart_client.dart';
import 'package:project_belanjakan/services/api/transaction_client.dart';
import 'package:project_belanjakan/services/api/user_client.dart';
import 'package:project_belanjakan/view/address/get_current_location.dart';
import 'package:project_belanjakan/view/checkout/checkout_details.dart';
import 'package:project_belanjakan/view/products/product_details.dart';
import 'package:project_belanjakan/view/receipt/pdf_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ShoppingCart extends ConsumerStatefulWidget {
  const ShoppingCart({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ShoppingCartState();
}

class _ShoppingCartState extends ConsumerState<ShoppingCart> {
  final listCartProvider =
      FutureProvider.family<List<Cart>, String>((ref, token) async {
    return await CartClient.getCart(token);
  });
  final tokenProvider = FutureProvider<String>((ref) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token')!;
    return token;
  });

  bool isLoading = false;

  onDelete(id, context, ref, token) async {
    CustomDialog.showLoadingDialog(context);
    try {
      await CartClient.deleteCart(id);
      ref.refresh(listCartProvider(token));
      CustomSnackBar.showSnackBar(context, "Delete Success", Colors.green);
    } catch (e) {
      CustomSnackBar.showSnackBar(context, e.toString(), Colors.red);
    } finally {
      Navigator.pop(context);
    }
  }

  onCheckout(List<Cart> carts, context, token) async {
    setState(() {
      isLoading = true;
    });
    Address currentAddress = await GetCurrentLocation().getAddressLocation();
    int idTransaksi = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => CheckoutDetails(
                  listCart: carts,
                  currentAddress: currentAddress,
                  token: token,
                )));

    Transaction transaction =
        await TransactionClient.findTransaction(idTransaksi);
    User user = await UserClient.getUserById(transaction.idBuyer);
    setState(() {
      isLoading = false;
    });
    createPdf(user, transaction, context);
    onRefresh(context, ref, token);
  }

  onRefresh(context, ref, token) async {
    ref.refresh(listCartProvider(token));
  }

  @override
  Widget build(BuildContext context) {
    var tokenListener = ref.watch(tokenProvider);
    return Scaffold(
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : tokenListener.when(
              data: (token) {
                var cartListener = ref.watch(listCartProvider(token));
                return cartListener.when(
                  data: (carts) => RefreshIndicator(
                    onRefresh: () => onRefresh(context, ref, token),
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: carts.length,
                            itemBuilder: (context, index) {
                              return itemInCard(
                                  carts[index], context, ref, token);
                            },
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 8.h,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 1.h, horizontal: 1.h),
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF0077B6),
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30)),
                                  ),
                                ),
                                onPressed: () =>
                                    onCheckout(carts, context, token),
                                child: const Text('Check out')),
                          ),
                        )
                      ],
                    ),
                  ),
                  error: (err, s) => Center(
                    child: Text(err.toString()),
                  ),
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (err, s) => Center(
                child: Text(err.toString()),
              ),
            ),
    );
  }

  Card itemInCard(Cart cart, context, ref, token) {
    return Card(
      child: GestureDetector(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => ProductDetailScreen(
                      id: cart.item!.id,
                      amount: cart.amount,
                    ))).then((value) => ref.refresh(listCartProvider(token))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 30.w,
              height: 15.h,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(8.0),
                    topLeft: Radius.circular(8)),
                child: Image.network(
                  ApiClient().domainName + cart.item!.image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 47.w,
                    child: Text(
                      cart.item!.name,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Text(NumberFormat.currency(locale: 'id_ID', symbol: 'Rp. ')
                      .format(cart.item!.price)),
                  Text(
                      'Tersisa ${NumberFormat.compact().format(cart.item!.stock)}'),
                  SizedBox(
                    height: 1.h,
                  ),
                  Text(
                    'Jumlah: ${cart.amount}',
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              child: IconButton(
                  onPressed: () => onDelete(cart.id, context, ref, token),
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  )),
            )
          ],
        ),
      ),
    );
  }
}
