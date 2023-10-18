class Item {
  final int? id;
  final String? name;
  final String? detail;
  final int? price;
  final String? picture;
  Item({this.id, this.name, this.detail, this.price,this.picture, });

  @override
  String toString() {
    return 'Item {name: $name}';
  }
}
