class Item {
  final int? id;
  final String? name;
  final String? detail;
  final int? price;
  final String? picture;
  final int? amount;
  Item(
      {this.id, this.name, this.detail, this.price, this.picture, this.amount});

  @override
  String toString() {
    return 'Item {name: $name}';
  }

  String getSubTotal(List<Item> products) {
    return products
        .fold(
            0.0,
            (double previousValue, element) =>
                previousValue + (element.price! * element.amount!))
        .toStringAsFixed(2);
  }

  String getPPNTotal(List<Item> products, int ppn) {
    return products
        .fold(
            0.0,
            (double previousValue, element) =>
                previousValue + (element.price! / 100 * ppn * element.amount!))
        .toStringAsFixed(2);
  }
}
