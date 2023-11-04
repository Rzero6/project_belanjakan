class Coupon {
  final int? id;
  final int? userId;
  final int? discount;
  final String? code;
  final String? createdAt;
  final String? expiresAt;
  Coupon({this.id, this.userId, this.discount, this.code, this.createdAt, this.expiresAt});

  int getDiscountedPrice(int price, int discount){
    return price * (100-discount) * 100;
  }
}
