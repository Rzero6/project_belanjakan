import 'package:flutter/material.dart';
// import 'package:project_belanjakan/database/sql_helper_items.dart';
import 'package:intl/intl.dart';
import 'package:project_belanjakan/services/api/remote_service.dart';
import 'package:project_belanjakan/view/products/item_details.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:project_belanjakan/model/item_api.dart';

class ItemsGridView extends StatefulWidget {
  const ItemsGridView({super.key});

  @override
  State<ItemsGridView> createState() => _ItemsGridViewState();
}

class _ItemsGridViewState extends State<ItemsGridView> {
  TextEditingController searchController = TextEditingController();
  List<Item>? items;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getItems();
  }

  getItems() async {
    items = await RemoteService().getItems('');
    if (items != null) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : items!.isEmpty
                ? const Text('Maaf masih belum ada produk')
                : Column(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: Color.fromARGB(255, 225, 225, 225),
                                    width: 0.5))),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: TextFormField(
                                onChanged: (value) {
                                  //Search
                                },
                                controller: searchController,
                                decoration: InputDecoration(
                                    labelText: 'Search',
                                    border: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            searchController.clear();
                                            //Search clear
                                          });
                                        },
                                        icon: const Icon(Icons.close))),
                              )),
                        ),
                      ),
                      Expanded(
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.85,
                            mainAxisSpacing: 5,
                            crossAxisSpacing: 5,
                          ),
                          itemCount: items?.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ProductDetailScreen(
                                      id: items![index].id,
                                    ),
                                  ),
                                );
                              },
                              child: Card(
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      height: 16.h,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                              '${'assets/images/${items![index].image}'}.jpg'),
                                          fit: BoxFit.cover,
                                        ),
                                        borderRadius: const BorderRadius.only(
                                            topRight: Radius.circular(10),
                                            topLeft: Radius.circular(10)),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 2.h,
                                              child: Text(
                                                items![index].name,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 2.h,
                                              child: Text(
                                                NumberFormat.currency(
                                                        locale: 'id_ID',
                                                        symbol: 'Rp. ')
                                                    .format(
                                                        items![index].price),
                                                style: const TextStyle(
                                                    color: Colors.blue,
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            SizedBox(
                                                height: 2.h,
                                                child: makeStarRating(
                                                    4.8, items![index].stock))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      )
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
