import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_belanjakan/database/sql_helper_items.dart';
import 'package:project_belanjakan/model/item.dart';

class ItemInputPage extends StatefulWidget {
  const ItemInputPage({
    Key? key,
    this.title,
    this.name,
    this.detail,
    this.picture,
    this.price,
    this.id,
  }) : super(key: key);

  final String? title;
  final String? name;
  final String? detail;
  final String? picture;
  final int? price;
  final int? id;
  @override
  State<ItemInputPage> createState() => _ItemInputPageState();
}

class _ItemInputPageState extends State<ItemInputPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerDetail = TextEditingController();
  TextEditingController controllerPicture = TextEditingController();
  TextEditingController controllerPrice = TextEditingController();
  @override
  Widget build(BuildContext context) {
    if (widget.id != null) {
      controllerName.text = widget.name!;
      controllerDetail.text = widget.detail!;
      controllerPicture.text = widget.picture!;
      controllerPrice.text = widget.price!.toString();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? ""),
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            TextFormField(
              controller: controllerName,
              validator: (value) => value == '' ? 'Must not be empty' : null,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Name',
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            TextFormField(
              controller: controllerDetail,
              validator: (value) => value == '' ? 'Must not be empty' : null,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Detail',
              ),
            ),
            TextFormField(
              controller: controllerPrice,
              validator: (value) => value == '' ? 'Must not be empty' : null,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Price',
              ),
            ),
            TextFormField(
              controller: controllerPicture,
              validator: (value) => value == '' ? 'Must not be empty' : null,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Picture',
              ),
            ),
            const SizedBox(
              height: 48,
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  if (widget.id == null) {
                    await addItem();
                  } else {
                    await editItem(widget.id!);
                  }
                  Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            )
          ],
        ),
      ),
    );
  }

  Future<void> addItem() async {
    await SQLHelperItem.addItem(Item(
        name: controllerName.text,
        detail: controllerDetail.text,
        price: int.tryParse(controllerPrice.text),
        picture: controllerPicture.text));
  }

  Future<void> editItem(int id) async {
    await SQLHelperItem.editItem(
        id,
        Item(
            name: controllerName.text,
            detail: controllerDetail.text,
            price: int.tryParse(controllerPrice.text),
            picture: controllerPicture.text));
  }
}
