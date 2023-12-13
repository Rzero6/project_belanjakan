import 'dart:convert';

class Item {
  int id;
  int idCategory;
  String name;
  String detail;
  String image;
  int price;
  int stock;
  double? rating;
  Item({
    required this.id,
    required this.idCategory,
    required this.name,
    required this.detail,
    required this.image,
    required this.price,
    required this.stock,
    this.rating,
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
      idCategory: json['id_category'],
    );
  }
  String toRawJson() => json.encode(toJson());
  Map<String, dynamic> toJson() => {
        "id": id,
        "id_category": idCategory,
        "name": name,
        "detail": detail,
        "image": image,
        "price": price,
        "stock": stock,
      };
}
