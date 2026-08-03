import 'package:black_market/src/core/model/ProductsModel.dart';


class CartEntry {
  final ProductModel item;
  int quantity;

  CartEntry({required this.item, required this.quantity});

  Map<String, dynamic> toJson() => {
    'item': item.toJson(),
    'quantity': quantity,
  };

  factory CartEntry.fromJson(Map<String, dynamic> json) {
    return CartEntry(
      item: ProductModel.fromJson(json['item']),
      quantity: json['quantity'],
    );
  }
}
