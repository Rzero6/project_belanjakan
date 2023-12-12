import 'dart:convert';

class Transaction {
  int id;
  int idBuyer;
  String address;
  int discount;
  String paymentMethod;
  int deliveryCost;
  String createdAt;
  List<DetailTransaction>? listDetails;
  Transaction({
    required this.id,
    required this.idBuyer,
    required this.address,
    required this.discount,
    required this.paymentMethod,
    required this.deliveryCost,
    required this.createdAt,
    this.listDetails,
  });

  factory Transaction.fromRawJson(String str) =>
      Transaction.fromJson(json.decode(str));
  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      idBuyer: json['id_buyer'],
      address: json['address'],
      discount: json['discount'],
      paymentMethod: json['payment_method'],
      deliveryCost: json['delivery_cost'],
      createdAt: json['created_at'],
    );
  }
  String toRawJson() => json.encode(toJson());
  Map<String, dynamic> toJson() => {
        "id": id,
        "id_buyer": idBuyer,
        "address": address,
        "discount": discount,
        "payment_method": paymentMethod,
        "delivery_cost": deliveryCost,
        "created_at": createdAt,
      };
}

class DetailTransaction {
  int id;
  int idTransaction;
  String name;
  int price;
  int amount;
  DetailTransaction({
    required this.id,
    required this.idTransaction,
    required this.name,
    required this.price,
    required this.amount,
  });
  factory DetailTransaction.fromRawJson(String str) =>
      DetailTransaction.fromJson(json.decode(str));
  factory DetailTransaction.fromJson(Map<String, dynamic> json) {
    return DetailTransaction(
      id: json['id'],
      idTransaction: json['id_transaction'],
      name: json['name'],
      price: json['price'],
      amount: json['amount'],
    );
  }
  String toRawJson() => json.encode(toJson());
  Map<String, dynamic> toJson() => {
        "id": id,
        "id_transaction": idTransaction,
        "name": name,
        "price": price,
        "amount": amount,
      };
}