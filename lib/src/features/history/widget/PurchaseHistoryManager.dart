import 'package:black_market/src/core/model/ProductsModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';
class PurchaseHistoryManager {
  static const _key = 'purchase_history';

  static Future<void> addPurchase(ProductModel item) async {
    final prefs = await SharedPreferences.getInstance();
    final history = await getHistory();

    history.add(PurchaseHistoryItem(
      item: item,
      purchaseDate: DateTime.now(),
    ));

    final encoded = history.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList(_key, encoded);
  }

  static Future<List<PurchaseHistoryItem>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = prefs.getStringList(_key) ?? [];

    return encoded
        .map((e) => PurchaseHistoryItem.fromJson(jsonDecode(e)))
        .toList();

  }
}
class PurchaseHistoryItem {
  final ProductModel item;
  final DateTime purchaseDate;

  PurchaseHistoryItem({required this.item, required this.purchaseDate});

  Map<String, dynamic> toJson() => {
    'item': item.toJson(),
    'purchaseDate': purchaseDate.toIso8601String(),
  };

  factory PurchaseHistoryItem.fromJson(Map<String, dynamic> json) =>
      PurchaseHistoryItem(
        item: ProductModel.fromJson(json['item']),
        purchaseDate: DateTime.parse(json['purchaseDate']),
      );
}
