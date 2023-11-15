class Item {
  int id;
  String name;
  String detail;
  String image;
  int price;
  int stock;

  Item({
    required this.id,
    required this.name,
    required this.detail,
    required this.image,
    required this.price,
    required this.stock,
  });

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
}
