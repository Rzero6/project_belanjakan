import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_belanjakan/services/api/item_client.dart';
import 'package:project_belanjakan/view/products/product_details.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:project_belanjakan/model/item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductsView extends ConsumerStatefulWidget {
  const ProductsView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProductsViewState();
}

class _ProductsViewState extends ConsumerState<ProductsView> {
  final TextEditingController searchController = TextEditingController();
  final listItemProvider =
      FutureProvider.family<List<Item>, String>((ref, search) async {
    List<Item> items = await ItemClient.getItems(search);
    for (Item item in items) {
      await item.setImageFile();
    }
    return items;
  });

  Card itemInCard(Item item, context, ref) {
    return Card(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProductDetailScreen(
                id: item.id,
              ),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 16.h,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10),
                  topLeft: Radius.circular(10),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(10),
                  topLeft: Radius.circular(10),
                ),
                child: Image.file(
                  item.imageFile!,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 2.h,
                      child: Text(
                        item.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 2.h,
                      child: Text(
                        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp. ')
                            .format(item.price),
                        style: const TextStyle(
                            color: Colors.blue,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                        height: 2.h, child: makeStarRating(4.5, item.stock))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var listener = ref.watch(listItemProvider(searchController.text));

    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 2.h,
          ),
          searchBox(ref),
          Expanded(
            child: listener.when(
              data: (items) => GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.85,
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 5,
                ),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return itemInCard(items[index], context, ref);
                },
              ),
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

  Row makeStarRating(double rating, int stock) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            for (int i = 0; i < 5; i++)
              Icon(
                rating >= i + 1
                    ? Icons.star_rate_rounded
                    : rating >= i + 0.5
                        ? Icons.star_half_rounded
                        : Icons.star_border_rounded,
                color: Colors.orangeAccent,
                size: 15,
              ),
          ],
        ),
        SizedBox(
          width: 3.w,
        ),
        Text(
          'tersisa ${NumberFormat.compact().format(stock)}',
          style: const TextStyle(fontSize: 11),
        ),
      ],
    );
  }

  Card searchBox(ref) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: searchController,
                decoration: const InputDecoration(
                  hintText: 'Search...',
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(width: 8),
            if (searchController.text.isNotEmpty)
              IconButton(
                onPressed: () {
                  setState(() {
                    searchController.clear();
                  });
                },
                icon: const Icon(Icons.highlight_remove),
              ),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () async {
                setState(
                  () {},
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
