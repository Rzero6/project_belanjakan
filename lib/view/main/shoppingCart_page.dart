import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:project_belanjakan/component/dialog.dart';
import 'package:project_belanjakan/component/snackbar.dart';
import 'package:project_belanjakan/model/cart.dart';
import 'package:project_belanjakan/services/api/cart_client.dart';
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

  @override
  Widget build(BuildContext context) {
    var tokenListener = ref.watch(tokenProvider);
    return Scaffold(
      body: tokenListener.when(
        data: (token) {
          var cartListener = ref.watch(listCartProvider(token));
          return cartListener.when(
            data: (carts) => RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  ref.refresh(listCartProvider(token));
                });
              },
              child: ListView.builder(
                itemCount: carts.length,
                itemBuilder: (context, index) {
                  return itemInCard(carts[index], context, ref, token);
                },
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: 30.w,
            height: 15.h,
            child: Image.file(
              cart.item!.imageFile!,
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
    );
  }
}
