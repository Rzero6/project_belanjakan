import 'dart:convert';

class Category {
  int id;
  String name;
  String image;
  Category({
    required this.id,
    required this.name,
    required this.image,
  });
  factory Category.fromRawJson(String str) =>
      Category.fromJson(json.decode(str));
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      image: json['image'],
    );
  }
  String toRawJson() => json.encode(toJson());
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
      };

  @override
  String toString() {
    return name;
  }
}
