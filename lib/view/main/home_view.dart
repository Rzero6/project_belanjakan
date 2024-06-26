import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:project_belanjakan/model/category.dart';
import 'package:project_belanjakan/model/item.dart';
import 'package:project_belanjakan/services/api/api_client.dart';
import 'package:project_belanjakan/services/api/category_client.dart';
import 'package:project_belanjakan/services/api/item_client.dart';
import 'package:project_belanjakan/view/main/cat_view.dart';
import 'package:project_belanjakan/view/products/product_details.dart';
import 'package:project_belanjakan/view/products/product_grid_by_cat.dart';
import 'package:project_belanjakan/view/products/product_grid_show.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  final TextEditingController searchController = TextEditingController();
  final CarouselController _controller = CarouselController();
  final ScrollController _scrollController = ScrollController();
  int _currentIndex = 0;
  final listItemProvider =
      FutureProvider.family<List<Item>, String>((ref, search) async {
    List<Item> items = await ItemClient.getItems(search, 0);
    return items;
  });
  final listCatProvider = FutureProvider<List<Category>>((ref) async {
    List<Category> items = await CategoryClient.getCategories();
    if (items.length > 4) {
      return items.take(4).toList();
    }
    return items;
  });
  @override
  Widget build(BuildContext context) {
    var itemListener = ref.watch(listItemProvider(''));
    var catListener = ref.watch(listCatProvider);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 2.h,
            ),
            searchBox(),
            SizedBox(
              height: 1.h,
            ),
            carouselImage(),
            SizedBox(
              height: 1.h,
            ),
            catHeader(),
            SizedBox(
                height: 45.w,
                child: catListener.when(
                    data: (category) => ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: category.length,
                          itemBuilder: (context, index) => GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      ProductsByCat(category[index].id),
                                ),
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.only(right: 3.w, left: 2.w),
                              width: 45.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                image: DecorationImage(
                                  image: CachedNetworkImageProvider(
                                    '${ApiClient().domainName}${category[index].image}',
                                    scale: 0.1,
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Align(
                                alignment: Alignment.bottomLeft,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    category[index].name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 30.0,
                                      fontWeight: FontWeight.bold,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black,
                                          offset: Offset(-1, -1),
                                        ),
                                        Shadow(
                                          color: Colors.black,
                                          offset: Offset(1, -1),
                                        ),
                                        Shadow(
                                          color: Colors.black,
                                          offset: Offset(1, 1),
                                        ),
                                        Shadow(
                                          color: Colors.black,
                                          offset: Offset(-1, 1),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                    error: (err, s) => Center(
                          child: Text(err.toString()),
                        ),
                    loading: () => const Center(
                          child: CircularProgressIndicator(),
                        ))),
            SizedBox(
              height: 2.h,
            ),
            Padding(
              padding: EdgeInsets.only(left: 2.w, right: 2.w),
              child: const Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recomended',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                  ],
                ),
              ]),
            ),
            SizedBox(
              height: 65.h,
              child: itemListener.when(
                data: (items) => GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
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
      ),
    );
  }

  onSearch() {
    Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => ProductsView(searchController.text, 0)))
        .then((value) => searchController.clear());
  }

  Card searchBox() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.w),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                textInputAction: TextInputAction.search,
                onSubmitted: (value) => onSearch(),
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
              onPressed: () => onSearch(),
            ),
          ],
        ),
      ),
    );
  }

  Column carouselImage() {
    return Column(
      children: [
        CarouselSlider(
          carouselController: _controller,
          options: CarouselOptions(
            enableInfiniteScroll: true,
            height: 20.h,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          items: [1, 2, 3, 4, 5].map((i) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: 100.w,
                  margin: const EdgeInsets.symmetric(horizontal: 10.0),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(
                        '${ApiClient().domainName}/images/offers/Sale$i.jpg',
                        scale: 0.1,
                      ),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                );
              },
            );
          }).toList(),
        ),
        SizedBox(
          height: 2.h,
        ),
        AnimatedSmoothIndicator(
          activeIndex: _currentIndex,
          count: 5,
          effect: const ExpandingDotsEffect(activeDotColor: Colors.blueAccent),
          onDotClicked: (index) {
            setState(() {
              _controller.animateToPage(index);
              _currentIndex = index;
            });
          },
        ),
      ],
    );
  }

  Padding catHeader() {
    return Padding(
      padding: EdgeInsets.only(left: 2.w, right: 2.w),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Categories',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CategoryView(),
                  ),
                );
              },
              child: const Text(
                'See All',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15.0,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ]),
    );
  }

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
                        overflow: TextOverflow.ellipsis,
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
                        height: 2.h,
                        child: makeStarRating(item.rating!, item.stock))
                  ],
                ),
              ),
            ),
          ],
        ),
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
}
