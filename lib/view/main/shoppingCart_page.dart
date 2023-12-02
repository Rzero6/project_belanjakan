import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:project_belanjakan/component/dialog.dart';
import 'package:project_belanjakan/component/snackbar.dart';
import 'package:project_belanjakan/model/address.dart';
import 'package:project_belanjakan/model/cart.dart';
import 'package:project_belanjakan/services/api/api_client.dart';
import 'package:project_belanjakan/services/api/cart_client.dart';
import 'package:project_belanjakan/view/address/get_current_location.dart';
import 'package:project_belanjakan/view/checkout/checkout_details.dart';
import 'package:project_belanjakan/view/products/product_details.dart';
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
    CustomDialog().showLoadingDialog(context);
    CustomSnackBar customSnackBar = CustomSnackBar();
    try {
      await CartClient.deleteCart(id, token);
      ref.refresh(listCartProvider(token));
      customSnackBar.showSnackBar(context, "Delete Success", Colors.green);
    } catch (e) {
      customSnackBar.showSnackBar(context, e.toString(), Colors.red);
    } finally {
      Navigator.pop(context);
    }
  }

  onCheckout(List<Cart> carts, context) async {
    setState(() {
      isLoading = true;
    });
    Address currentAddress = await GetCurrentLocation().getAddressLocation();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => CheckoutDetails(
                listCart: carts,
                currentAddress: currentAddress))).then((value) {
      setState(() {
        isLoading = false;
      });
    });
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
                    onRefresh: () async {
                      setState(() {
                        ref.refresh(listCartProvider(token));
                      });
                    },
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
                                onPressed: () => onCheckout(carts, context),
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
                builder: (_) => ProductDetailScreen(id: cart.item!.id))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 30.w,
              height: 15.h,
              child: Image.network(
                ApiClient().domainName + cart.item!.image,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(cart.item!.name),
                  Text(NumberFormat.currency(locale: 'id_ID', symbol: 'Rp. ')
                      .format(cart.item!.price)),
                  Text(
                      'Tersisa ${NumberFormat.compact().format(cart.item!.stock)}'),
                  Text('Jumlah: ${cart.amount}'),
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
