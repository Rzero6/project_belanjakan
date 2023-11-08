import 'package:project_belanjakan/model/item.dart';

class PurchasedItem {
  List<Item> items;
  double deliveryCost;
  double adminFee;
  PurchasedItem(
      {required this.items,
      required this.deliveryCost,
      required this.adminFee});

  double getAdditionalFee() {
    return deliveryCost + adminFee;
  }
}
