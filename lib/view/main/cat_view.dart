import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_belanjakan/model/category.dart';
import 'package:project_belanjakan/services/api/api_client.dart';
import 'package:project_belanjakan/services/api/category_client.dart';
import 'package:project_belanjakan/view/products/product_grid_by_cat.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CategoryView extends ConsumerStatefulWidget {
  const CategoryView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CategoryViewState();
}

class _CategoryViewState extends ConsumerState<CategoryView> {
  final listCatProvider =
      FutureProvider.family<List<Category>, String>((ref, nothing) async {
    List<Category> items = await CategoryClient.getCategories();
    return items;
  });
  @override
  Widget build(BuildContext context) {
    var catListener = ref.watch(listCatProvider('nothing'));
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Categories',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(children: [
        SizedBox(
          height: 2.w,
        ),
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
                              builder: (_) => ProductsByCat(category[index].id),
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
                    )))
      ]),
    );
  }
}
