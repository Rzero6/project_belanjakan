import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:project_belanjakan/component/dialog.dart';
import 'package:project_belanjakan/component/snackbar.dart';
import 'package:project_belanjakan/model/item.dart';
import 'package:project_belanjakan/model/review.dart';
import 'package:project_belanjakan/services/api/api_client.dart';
import 'package:project_belanjakan/services/api/item_client.dart';
import 'package:project_belanjakan/services/api/review_client.dart';
import 'package:project_belanjakan/services/api/transaction_client.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class InputReview extends StatefulWidget {
  final int idItem;
  final int idDetail;
  const InputReview({super.key, required this.idItem, required this.idDetail});
  @override
  State<InputReview> createState() => _InputReviewState();
}

class _InputReviewState extends State<InputReview> {
  final TextEditingController descriptionController = TextEditingController();
  bool isLoading = true;
  late Item item;
  double ratingValue = 0;

  loadItem(context) async {
    try {
      item = await ItemClient.findItem(widget.idItem);
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      CustomSnackBar.showSnackBar(context, e.toString(), Colors.red);
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    super.initState();
    loadItem(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rating & Review'),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
                    child: imageContainer(ApiClient().domainName + item.image),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 1.h),
                    child: descriptionContainer(item),
                  ),
                  ratingForm(),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: SizedBox(
                      width: double.infinity,
                      height: 6.h,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0077B6),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          ),
                        ),
                        onPressed: () =>
                            onSubmit(item.id, widget.idDetail, context),
                        child: const Text(
                          'Kirim',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  onSubmit(idItem, idDetail, context) async {
    CustomDialog.showLoadingDialog(context);
    try {
      Review review = Review(
          id: 0,
          idItem: idItem,
          idUser: 0,
          rating: ratingValue.toInt(),
          detail: descriptionController.text,
          createdAt: '');
      await ReviewClient.addReview(review);
      await TransactionClient.updateRatedDetailsTransaction(idDetail);
      CustomSnackBar.showSnackBar(
          context, 'Berhasil memberikan review', Colors.blue);
      Navigator.pop(context);
    } catch (e) {
      CustomSnackBar.showSnackBar(
          context, 'Maaf tidak dapat melakukan review sekarang', Colors.red);
    }
  }

  Widget imageContainer(String url) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        height: 20.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          image: DecorationImage(
            image: NetworkImage(url),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget descriptionContainer(Item item) {
    final currencyFormat =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp. ');
    return SizedBox(
      height: 10.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.name,
            style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 1.h,
          ),
          Text(currencyFormat.format(item.price),
              style: const TextStyle(fontSize: 16))
        ],
      ),
    );
  }

  Widget ratingForm() {
    return SizedBox(
      height: 40.h,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: const Align(
                alignment: Alignment.centerLeft,
                child: Text('Beri Penilain Produk')),
          ),
          SizedBox(
            height: 2.h,
          ),
          RatingBar(
            minRating: 1,
            maxRating: 5,
            ratingWidget: RatingWidget(
                full: const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                half: const Icon(
                  Icons.star_half,
                  color: Colors.amber,
                ),
                empty: const Icon(
                  Icons.star_outline,
                  color: Colors.amber,
                )),
            onRatingUpdate: (value) => ratingValue = value,
            updateOnDrag: true,
            glowColor: Colors.amber,
            itemSize: 7.h,
            itemPadding: EdgeInsets.symmetric(horizontal: 1.w),
          ),
          SizedBox(
            height: 2.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: TextFormField(
              controller: descriptionController,
              maxLines: 8,
              validator: (value) {
                if (value!.length > 255) {
                  return 'Maximum length exceeded (255 characters)';
                }
                return null;
              },
              style: const TextStyle(fontSize: 14),
              decoration: InputDecoration(
                  hintText:
                      'Ayo review produknya, deskripsikan dengan penuh kejujuran.(opsional)',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
            ),
          )
        ],
      ),
    );
  }
}
