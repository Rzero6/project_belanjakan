import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_belanjakan/component/snackbar.dart';
import 'package:project_belanjakan/model/item.dart';
import 'package:project_belanjakan/services/api/item_client.dart';
import 'package:project_belanjakan/services/convert/string_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ItemInputPage extends StatefulWidget {
  const ItemInputPage({
    Key? key,
    this.id,
  }) : super(key: key);

  final int? id;
  @override
  State<ItemInputPage> createState() => _ItemInputPageState();
}

class _ItemInputPageState extends State<ItemInputPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerDetail = TextEditingController();
  TextEditingController controllerStock = TextEditingController();
  TextEditingController controllerPrice = TextEditingController();
  File? imageFile;
  bool isLoading = false;
  CustomSnackBar customSnackBar = CustomSnackBar();
  late String token;
  void loadDataItem() async {
    setState(() {
      isLoading = true;
    });
    try {
      Item res = await ItemClient.findItem(widget.id);
      imageFile = await ConvertImageString.strToImg(res.image);
      setState(() {
        controllerName.text = res.name;
        controllerDetail.text = res.detail;
        controllerPrice.text = res.price.toString();
        controllerStock.text = res.stock.toString();
        isLoading = false;
      });
    } catch (e) {
      customSnackBar.showSnackBar(context, e.toString(), Colors.red);
      Navigator.pop(context);
    }
  }

  void loadDataUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token')!;
  }

  @override
  void initState() {
    super.initState();
    loadDataUser();
    if (widget.id != null) {
      loadDataItem();
    }
  }

  @override
  Widget build(BuildContext context) {
    void onSubmit() async {
      setState(() {
        isLoading = true;
      });
      if (!formKey.currentState!.validate() && imageFile!.existsSync()) return;
      String image = await ConvertImageString.imgToStr(imageFile!);
      Item input = Item(
          id: widget.id ?? 0,
          name: controllerName.text,
          detail: controllerDetail.text,
          image: image,
          price: int.parse(controllerPrice.text),
          stock: int.parse(controllerStock.text));
      try {
        if (widget.id == null) {
          await ItemClient.addItem(input, token);
        } else {
          await ItemClient.updateItem(input, token);
        }
        customSnackBar.showSnackBar(context, 'Success', Colors.green);
        Navigator.pop(context);
      } catch (e) {
        customSnackBar.showSnackBar(context, e.toString(), Colors.red);
        Navigator.pop(context);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.id == null ? "Tambah Barang" : "Ubah Barang"),
      ),
      body: Container(
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Form(
                key: formKey,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: <Widget>[
                    GestureDetector(
                      onTap: () => showOptionToPick(),
                      child: SizedBox(
                        width: double.infinity,
                        height: 200,
                        child: imageFile != null && imageFile!.existsSync()
                            ? Image.file(
                                imageFile!,
                                fit: BoxFit.cover,
                              )
                            : const Center(
                                child:
                                    Text('Tolong Isi Gambarnya ! Pencet Akuu'),
                              ),
                      ),
                    ),
                    TextFormField(
                      controller: controllerName,
                      validator: (value) =>
                          value == '' ? 'Must not be empty' : null,
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
                      validator: (value) =>
                          value == '' ? 'Must not be empty' : null,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Detail',
                      ),
                    ),
                    TextFormField(
                      controller: controllerPrice,
                      validator: (value) =>
                          value == '' ? 'Must not be empty' : null,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Price',
                      ),
                    ),
                    TextFormField(
                      controller: controllerStock,
                      validator: (value) =>
                          value == '' ? 'Must not be empty' : null,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Stock',
                      ),
                    ),
                    const SizedBox(
                      height: 48,
                    ),
                    ElevatedButton(
                      onPressed: onSubmit,
                      child: const Text('Save'),
                    )
                  ],
                ),
              ),
      ),
    );
  }

  void showOptionToPick() {
    showCupertinoModalPopup(
      context: context,
      builder: ((context) => CupertinoActionSheet(
            title: const Text("Select Picture from"),
            actions: <CupertinoActionSheetAction>[
              CupertinoActionSheetAction(
                child: const Text('Camera'),
                onPressed: () async {
                  pickImageFromCamera();
                },
              ),
              CupertinoActionSheetAction(
                child: const Text('Gallery'),
                onPressed: () {
                  pickImageFromGallery();
                },
              )
            ],
          )),
    );
  }

  Future<void> pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final pickedImage =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 10);
    if (pickedImage == null) return;
    setState(() {
      imageFile = File(pickedImage.path);
      Navigator.pop(context);
    });
  }

  Future<void> pickImageFromCamera() async {
    final ImagePicker picker = ImagePicker();
    final pickedImage =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 10);
    if (pickedImage == null) return;
    setState(() {
      imageFile = File(pickedImage.path);
      Navigator.pop(context);
    });
  }
}