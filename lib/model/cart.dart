import 'dart:convert';

import 'package:project_belanjakan/model/item.dart';

class Cart {
  int id;
  int idUser;
  int idItem;
  int amount;
  Item? item;
  Cart({
    required this.id,
    required this.idUser,
    required this.idItem,
    required this.amount,
    this.item,
  });
  factory Cart.fromRawJson(String str) => Cart.fromJson(json.decode(str));
  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['id'],
      idUser: json['id_user'],
      idItem: json['id_item'],
      amount: json['amount'],
    );
  }
  String toRawJson() => json.encode(toJson());
  Map<String, dynamic> toJson() => {
        "id": id,
        "id_user": idUser,
        "id_item": idItem,
        "amount": amount,
      };
}
