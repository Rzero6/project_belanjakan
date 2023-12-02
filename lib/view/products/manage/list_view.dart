import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_belanjakan/services/api/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:project_belanjakan/component/snackbar.dart';
import 'package:project_belanjakan/model/item.dart';
import 'package:project_belanjakan/services/api/item_client.dart';
import 'package:project_belanjakan/view/products/manage/input_page.dart';

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
  late String token;
  File? cachedImage;

  final listItemProvider =
      FutureProvider.family<List<Item>, String>((ref, search) async {
    List<Item> items = await ItemClient.getItems(search);
    return items;
  });

  final tokenProvider = FutureProvider<String>((ref) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token')!;
    return token;
  });

  void loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token')!;
  }

  void onAdd(context, ref, token) {
    Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ItemInputPage()))
        .then((value) => ref.refresh(listItemProvider(token)));
  }

  void onDelete(id, context, ref, token) async {
    try {
      await ItemClient.deleteItem(id, token);
      ref.refresh(listItemProvider(token));
      customSnackBar.showSnackBar(context, "Delete Success", Colors.green);
    } catch (e) {
      customSnackBar.showSnackBar(context, e.toString(), Colors.red);
    }
  }

  ListTile itemInListTile(Item item, context, ref, token) {
    return ListTile(
      leading: SizedBox(
          width: 60,
          height: 60,
          child: Image.network(
            ApiClient().domainName + item.image,
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
                  ))).then((value) => ref.refresh(listItemProvider(token))),
      trailing: IconButton(
        onPressed: () => onDelete(item.id, context, ref, token),
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
    var tokenListener = ref.watch(tokenProvider);

    var itemListener = ref.watch(listItemProvider(searchController.text));
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
                    ref.refresh(listItemProvider(searchController.text));
                  });
                },
                icon: const Icon(Icons.search))
          ]),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            onAdd(context, ref, token);
          }),
      body: tokenListener.when(
        data: (token) {
          return itemListener.when(
            data: (items) => SingleChildScrollView(
              child: Column(
                children: items
                    .map((item) => itemInListTile(item, context, ref, token))
                    .toList(),
              ),
            ),
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            error: (err, s) => Center(
              child: Text(err.toString()),
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
}
