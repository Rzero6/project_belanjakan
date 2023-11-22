import 'dart:convert';
import 'dart:io';

import 'package:project_belanjakan/services/convert/string_image.dart';

class Item {
  int id;
  String name;
  String detail;
  String image;
  int price;
  int stock;
  File? imageFile;

  Item({
    required this.id,
    required this.name,
    required this.detail,
    required this.image,
    required this.price,
    required this.stock,
    this.imageFile,
  });
  factory Item.fromRawJson(String str) => Item.fromJson(json.decode(str));
  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      name: json['name'],
      detail: json['detail'],
      image: json['image'],
      price: json['price'],
      stock: json['stock'],
    );
  }
  String toRawJson() => json.encode(toJson());
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "detail": detail,
        "image": image,
        "price": price,
        "stock": stock,
      };

  Future setImageFile() async {
    imageFile ??= await ConvertImageString.strToImg(image);
  }
}
