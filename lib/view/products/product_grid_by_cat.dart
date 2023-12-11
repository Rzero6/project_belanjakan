import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_belanjakan/services/api/api_client.dart';
import 'package:project_belanjakan/services/api/item_client.dart';
import 'package:project_belanjakan/view/products/product_details.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:project_belanjakan/model/item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductsByCat extends ConsumerStatefulWidget {
  final int id;
  const ProductsByCat(this.id, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProductsByCatState();
}

class _ProductsByCatState extends ConsumerState<ProductsByCat> {
  final TextEditingController searchController = TextEditingController();
  final listItemProvider =
      FutureProvider.family<List<Item>, int>((ref, search) async {
    List<Item> items = await ItemClient.getItemsByCat(search);
    return items;
  });

  Card itemInCard(Item item, context, ref) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(2.w))),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProductDetailScreen(
                id: item.id,
                amount: 1,
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
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(2.w),
                  topLeft: Radius.circular(2.w),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(2.w),
                  topLeft: Radius.circular(2.w),
                ),
                child: Image.network(
                  '${ApiClient().domainName}${item.image}',
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.shopping_bag);
                  },
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(2.w),
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

  onRefresh(context, ref) async {
    ref.refresh(listItemProvider(widget.id));
  }

  @override
  Widget build(BuildContext context) {
    var listener = ref.watch(listItemProvider(widget.id));

    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 2.h,
          ),
          Expanded(
            child: listener.when(
              data: (items) => RefreshIndicator(
                onRefresh: () => onRefresh(context, ref),
                child: GridView.builder(
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
        padding: EdgeInsets.symmetric(horizontal: 2.w),
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
            SizedBox(width: 2.w),
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
