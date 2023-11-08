// ignore_for_file: use_build_context_synchronously, prefer_interpolation_to_compose_strings
import 'package:flutter/material.dart';
import 'package:project_belanjakan/database/sql_helper_items.dart';
import 'package:project_belanjakan/view/products/item_details.dart';

class ShowItemView extends StatefulWidget {
  const ShowItemView({super.key});

  @override
  State<ShowItemView> createState() => _ShowItemViewState();
}

class _ShowItemViewState extends State<ShowItemView> {
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> items = [];
  bool isLoading = false;
  void refresh(String search) async {
    setState(() {
      isLoading = true;
    });
    try {
      final data = await SQLHelperItem.getItems(search);
      setState(() {
        items = data;
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    refresh('');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: Color.fromARGB(255, 225, 225, 225),
                          width: 0.5))),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: TextFormField(
                      onChanged: (value) {
                        refresh(value);
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
                                  refresh('');
                                });
                              },
                              icon: const Icon(Icons.close))),
                    )),
              ),
            ),
            Expanded(
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: Colors.blue),
                    )
                  : items.isEmpty
                      ? const Center(
                          child: Text('Maaf, data tidak ada :('),
                        )
                      : ListView.builder(
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Card(
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                clipBehavior: Clip.hardEdge,
                                child: InkWell(
                                  splashColor: Colors.blue.withAlpha(30),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => ProductDetailScreen(
                                            id: items[index]['id'],
                                          ),
                                        ));
                                  },
                                  child: SizedBox(
                                    height: 150,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          width: 100,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage(
                                                  '${'assets/images/' + items[index]['picture']}.jpg'),
                                              fit: BoxFit.cover,
                                            ),
                                            borderRadius:
                                                const BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(10),
                                                    topLeft:
                                                        Radius.circular(10)),
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: SizedBox(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Align(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Text(
                                                      items[index]['name'],
                                                      style: const TextStyle(
                                                          fontSize: 24,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 8,
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.bottomLeft,
                                                    child: Text(
                                                      'Rp. ${items[index]['price']}',
                                                      style: const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 25,
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      items[index]['detail'],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
            ),
          ],
        ),
      ),
    );
  }
}
