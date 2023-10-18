import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_belanjakan/database/sql_helper_items.dart';
import 'package:project_belanjakan/view/item_input_page.dart';

class ItemsListView extends StatefulWidget {
  const ItemsListView({super.key});

  @override
  State<ItemsListView> createState() => _ItemsListViewState();
}

class _ItemsListViewState extends State<ItemsListView> {
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> items = [];
  void refresh(String search) async {
    final data = await SQLHelperItem.getItems(search);
    setState(() {
      items = data;
    });
  }

  @override
  void initState() {
    refresh('');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ItemInputPage(
                  title: 'Add Item',
                  id: null,
                  name: null,
                  detail: null,
                  price: null,
                  picture: null),
            ),
          ).then((value) => refresh(''));
        },
        child: const Icon(Icons.add),
      ),
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
              child: items.isEmpty
                  ? const Center(
                      child: Text('Maaf, data tidak ada :('),
                    )
                  : ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Card(
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            clipBehavior: Clip.hardEdge,
                            child: InkWell(
                              splashColor: Colors.blue.withAlpha(30),
                              onTap: () {
                                //Do something on tap
                              },
                              child: SizedBox(
                                height: 150,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      width: 100,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                              '${'assets/images/' + items[index]['picture']}.jpg'),
                                          fit: BoxFit.cover,
                                        ),
                                        borderRadius: const BorderRadius.only(
                                            bottomLeft: Radius.circular(10),
                                            topLeft: Radius.circular(10)),
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
                                                alignment: Alignment.topLeft,
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
                                                alignment: Alignment.bottomLeft,
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
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  items[index]['detail'],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Align(
                                        alignment: Alignment.topRight,
                                        child: IconButton(
                                            onPressed: () {
                                              showCupertinoModalPopup(
                                                context: context,
                                                builder: ((context) =>
                                                    CupertinoActionSheet(
                                                      actions: <CupertinoActionSheetAction>[
                                                        CupertinoActionSheetAction(
                                                          child: const Text(
                                                              'Edit Data'),
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        ItemInputPage(
                                                                  title:
                                                                      'Edit Item',
                                                                  id: items[
                                                                          index]
                                                                      ['id'],
                                                                  name: items[
                                                                          index]
                                                                      ['name'],
                                                                  detail: items[
                                                                          index]
                                                                      [
                                                                      'detail'],
                                                                  picture: items[
                                                                          index]
                                                                      [
                                                                      'picture'],
                                                                  price: items[
                                                                          index]
                                                                      ['price'],
                                                                ),
                                                              ),
                                                            ).then((value) =>
                                                                refresh(''));
                                                          },
                                                        ),
                                                        CupertinoActionSheetAction(
                                                          child: const Text(
                                                            'Delete Data',
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.red),
                                                          ),
                                                          onPressed: () async {
                                                            await deleteItem(
                                                                items[index]
                                                                    ['id']);
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                        )
                                                      ],
                                                    )),
                                              );
                                            },
                                            icon: const Icon(Icons.more_vert))),
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

  Future<void> deleteItem(int id) async {
    await SQLHelperItem.deleteItem(id);
    refresh('');
  }
}
