import 'dart:convert';

class Coupon {
  final int? id;
  final String name;
  final int idUser;
  final int discount;
  final String code;
  final String? createdAt;
  final String expiresAt;
  Coupon(
      {this.id,
      required this.name,
      required this.idUser,
      required this.discount,
      required this.code,
      this.createdAt,
      required this.expiresAt});
  factory Coupon.fromRawJson(String str) => Coupon.fromJson(json.decode(str));
  factory Coupon.fromJson(Map<String, dynamic> json) {
    return Coupon(
      name: json['name'],
      id: json['id'],
      idUser: json['id_user'],
      discount: json['discount'],
      code: json['code'],
      createdAt: json['created_at'],
      expiresAt: json['expires_at'],
    );
  }
  String toRawJson() => json.encode(toJson());
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "id_user": idUser,
        "discount": discount,
        "code": code,
        "created_at": createdAt,
        "expires_at": expiresAt,
      };

  int getDiscountedPrice(int price, int discount) {
    return price * (100 - discount) * 100;
  }
}
