import 'dart:convert';

class Review {
  int id;
  int idItem;
  int idUser;
  int rating;
  String detail;
  String createdAt;

  Review({
    required this.id,
    required this.idItem,
    required this.idUser,
    required this.rating,
    required this.detail,
    required this.createdAt,
  });
  factory Review.fromRawJson(String str) => Review.fromJson(json.decode(str));
  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      idItem: json['id_item'],
      idUser: json['id_user'],
      rating: json['rating'],
      detail: json['detail'],
      createdAt: json['created_at'],
    );
  }
  String toRawJson() => json.encode(toJson());
  Map<String, dynamic> toJson() => {
        "id": id,
        "id_item": idItem,
        "id_user": idUser,
        "rating": rating,
        "detail": detail,
        "created_at": createdAt,
      };
}

class Reviews {
  double rating;
  List<Review> listReviews;
  Reviews({
    required this.rating,
    required this.listReviews,
  });
}
