import 'dart:io';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_belanjakan/component/snackbar.dart';
import 'package:project_belanjakan/model/category.dart';
import 'package:project_belanjakan/model/item.dart';
import 'package:project_belanjakan/services/api/api_client.dart';
import 'package:project_belanjakan/services/api/category_client.dart';
import 'package:project_belanjakan/services/api/item_client.dart';
import 'package:project_belanjakan/services/convert/string_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

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
  late List<Category> categories;
  Category? selectedCategory;
  final TextEditingController controllerName = TextEditingController();
  final TextEditingController controllerDetail = TextEditingController();
  final TextEditingController controllerStock = TextEditingController();
  final TextEditingController controllerPrice = TextEditingController();
  final TextEditingController controllerCategory = TextEditingController();
  File? imageFile;
  String? imageSource;
  bool isLoading = false;
  CustomSnackBar customSnackBar = CustomSnackBar();
  late String token;
  void loadDataItem() async {
    setState(() {
      isLoading = true;
    });
    try {
      Item res = await ItemClient.findItem(widget.id);
      selectedCategory = categories.firstWhere(
          (element) => element.id == res.idCategory,
          orElse: () => Category(id: -1, name: 'name', image: 'image'));
      setState(() {
        imageSource = res.image;
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
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    categories = await CategoryClient.getCategories();
    token = prefs.getString('token')!;
    if (widget.id != null) {
      loadDataItem();
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadDataUser();
  }

  @override
  Widget build(BuildContext context) {
    void onSubmit() async {
      setState(() {
        isLoading = true;
      });
      if (!formKey.currentState!.validate()) return;
      if (imageFile == null && imageSource == null) return;
      if (selectedCategory == null) return;
      String image = '';
      if (imageFile != null) {
        image = await ConvertImageString.imgToStr(imageFile!);
      } else {
        image = imageSource!;
      }
      Item input = Item(
          id: widget.id ?? 0,
          name: controllerName.text,
          detail: controllerDetail.text,
          image: image,
          price: int.parse(controllerPrice.text),
          stock: int.parse(controllerStock.text),
          idCategory: selectedCategory!.id);
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
                    imageField(),
                    SizedBox(
                      height: 2.h,
                    ),
                    categoryTextFormField(),
                    SizedBox(
                      height: 2.h,
                    ),
                    TextFormField(
                      key: const Key("input-name"),
                      controller: controllerName,
                      validator: (value) =>
                          value == '' ? 'Must not be empty' : null,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                        labelText: 'Name',
                      ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    TextFormField(
                      key: const Key("input-detail"),
                      controller: controllerDetail,
                      validator: (value) =>
                          value == '' ? 'Must not be empty' : null,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                        labelText: 'Detail',
                      ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    TextFormField(
                      key: const Key("input-price"),
                      controller: controllerPrice,
                      validator: (value) =>
                          value == '' ? 'Must not be empty' : null,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                        labelText: 'Price',
                      ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    TextFormField(
                      key: const Key("input-stock"),
                      controller: controllerStock,
                      validator: (value) =>
                          value == '' ? 'Must not be empty' : null,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                        labelText: 'Stock',
                      ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    ElevatedButton(
                      onPressed: onSubmit,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          fixedSize: Size(double.infinity, 6.h)),
                      child: const Text(
                        'Save',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            fixedSize: Size(double.infinity, 6.h)),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel'))
                  ],
                ),
              ),
      ),
    );
  }

  DropdownButtonHideUnderline categoryTextFormField() {
    return DropdownButtonHideUnderline(
      child: DropdownButtonFormField2<Category>(
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        isExpanded: true,
        hint: const Text('Pilih Kategori'),
        style: TextStyle(
          fontSize: 14,
          color: Theme.of(context).hintColor,
        ),
        items: categories.map<DropdownMenuItem<Category>>((Category item) {
          return DropdownMenuItem<Category>(
            value: item,
            child: Text(
              item.name,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          );
        }).toList(),
        value: selectedCategory,
        validator: (value) {
          if (value == null) {
            return 'Pilih kategori';
          }
          return null;
        },
        onChanged: (value) {
          setState(() {
            selectedCategory = value;
          });
        },
        buttonStyleData: ButtonStyleData(
          padding: EdgeInsets.symmetric(horizontal: 2.w),
          height: 2.h,
          width: double.infinity,
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 25.h,
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 40,
        ),
        dropdownSearchData: DropdownSearchData(
          searchController: controllerCategory,
          searchInnerWidgetHeight: 2.h,
          searchInnerWidget: Container(
            height: 50,
            padding: const EdgeInsets.only(
              top: 8,
              bottom: 4,
              right: 8,
              left: 8,
            ),
            child: TextFormField(
              expands: true,
              maxLines: null,
              controller: controllerCategory,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                hintText: 'cari kategori...',
                hintStyle: const TextStyle(fontSize: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          searchMatchFn: (item, searchValue) {
            return item.value
                .toString()
                .toLowerCase()
                .contains(searchValue.toLowerCase());
          },
        ),
        onMenuStateChange: (isOpen) {
          if (!isOpen) {
            controllerCategory.clear();
          }
        },
      ),
    );
  }

  GestureDetector imageField() {
    return GestureDetector(
      key: const Key('input-image-selector'),
      onTap: () => showOptionToPick(),
      child: Container(
        width: 75.w,
        height: 75.w,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black38,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(7.5),
          child: imageFile != null && imageFile!.existsSync()
              ? Image.file(
                  imageFile!,
                  fit: BoxFit.cover,
                )
              : Image.network(
                  '${ApiClient().domainName}$imageSource',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Text('Tolong Isi Gambarnya ! Pencet Akuu'),
                    );
                  },
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
    final pickedImage = await picker.pickImage(
        source: ImageSource.gallery,
        maxHeight: 720,
        maxWidth: 720,
        imageQuality: 50);
    if (pickedImage == null) return;
    setState(() {
      imageFile = File(pickedImage.path);
      Navigator.pop(context);
    });
  }

  Future<void> pickImageFromCamera() async {
    final ImagePicker picker = ImagePicker();
    final pickedImage = await picker.pickImage(
        source: ImageSource.camera,
        maxHeight: 720,
        maxWidth: 720,
        imageQuality: 50);
    if (pickedImage == null) return;
    setState(() {
      imageFile = File(pickedImage.path);
      Navigator.pop(context);
    });
  }
}
