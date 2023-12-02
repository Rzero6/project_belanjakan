import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_belanjakan/services/api/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:project_belanjakan/component/snackbar.dart';
import 'package:project_belanjakan/model/item.dart';
import 'package:project_belanjakan/services/api/item_client.dart';
import 'package:project_belanjakan/view/products/manage/input_page.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ItemsListView extends ConsumerStatefulWidget {
  const ItemsListView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ItemsListViewState();
}

class SearchToken {
  String search, token;
  SearchToken({required this.token, required this.search});
}

class _ItemsListViewState extends ConsumerState<ItemsListView> {
  final TextEditingController searchController = TextEditingController();
  CustomSnackBar customSnackBar = CustomSnackBar();
  File? cachedImage;
  late SearchToken searchToken;
  final listItemProvider =
      FutureProvider.family<List<Item>, SearchToken>((ref, searchToken) async {
    List<Item> items = await ItemClient.getItemsOnlyOwner(
        searchToken.search, searchToken.token);
    return items;
  });

  void loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token')!;
    setState(() {
      searchToken = SearchToken(token: token, search: searchController.text);
    });
  }

  void onAdd(context, ref, SearchToken searchToken) {
    Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ItemInputPage()))
        .then((value) => ref.refresh(listItemProvider(searchToken)));
  }

  void onDelete(id, context, ref, SearchToken searchToken) async {
    try {
      await ItemClient.deleteItem(id, searchToken.token);
      ref.refresh(listItemProvider(searchToken));
      customSnackBar.showSnackBar(context, "Delete Success", Colors.green);
    } catch (e) {
      customSnackBar.showSnackBar(context, e.toString(), Colors.red);
    }
  }

  ListTile itemInListTile(Item item, context, ref, SearchToken searchToken) {
    return ListTile(
      leading: SizedBox(
          width: 20.w,
          height: 20.w,
          child: Image.network(
            ApiClient().domainName + item.image,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.shopping_bag);
            },
          )),
      title: Text(item.name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Rp. ${item.price.toString()}'),
          Text('Tersisa ${item.stock}'),
        ],
      ),
      onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ItemInputPage(
                        id: item.id,
                      )))
          .then((value) => ref.refresh(listItemProvider(searchToken))),
      trailing: IconButton(
        onPressed: () => onDelete(item.id, context, ref, searchToken),
        icon: const Icon(Icons.delete),
      ),
    );
  }

  @override
  void initState() {
    loadToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (searchToken.token.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    var itemListener = ref.watch(listItemProvider(searchToken));
    return Scaffold(
      appBar: AppBar(
          title: TextField(
            controller: searchController,
            cursorColor: Colors.white,
            decoration: const InputDecoration(
              hintText: 'Search...',
              border: InputBorder.none,
            ),
            style: const TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    searchToken.search = searchController.text;
                    print(searchToken.search);
                    if (searchToken.search == '') {
                      print(true);
                    }
                    ref.refresh(listItemProvider(searchToken));
                  });
                },
                icon: const Icon(Icons.search))
          ]),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            onAdd(context, ref, searchToken);
          }),
      body: itemListener.when(
        data: (items) => SingleChildScrollView(
          child: Column(
            children: items
                .map((item) => itemInListTile(item, context, ref, searchToken))
                .toList(),
          ),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (err, s) => Center(
          child: Text(err.toString()),
        ),
      ),
    );
  }
}
