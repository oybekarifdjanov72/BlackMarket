import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/model/ProductsModel.dart';
import '../../history/widget/PurchaseHistoryManager.dart';
import 'BasketState.dart';

class BasketCubit extends Cubit<BasketState> {
  static const String _storageKey = 'basket_items';

  BasketCubit() : super(const BasketState()) {
    loadBasket();
  }

  Future<void> loadBasket() async {
    emit(state.copyWith(status: BasketStatus.loading));
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getString(_storageKey);
      if (data != null) {
        final List<dynamic> decoded = jsonDecode(data);
        final items = decoded.map((e) => BasketItem.fromJson(e)).toList();
        emit(state.copyWith(items: items, status: BasketStatus.success));
      } else {
        emit(state.copyWith(status: BasketStatus.success));
      }
    } catch (e) {
      emit(state.copyWith(status: BasketStatus.error, errorMessage: e.toString()));
    }
  }

  Future<void> addToBasket(ProductModel product, {int quantity = 1}) async {
    final List<BasketItem> currentItems = List.from(state.items);
    final index = currentItems.indexWhere((item) => item.product.id == product.id);

    if (index != -1) {
      currentItems[index] = currentItems[index].copyWith(
        quantity: currentItems[index].quantity + quantity,
      );
    } else {
      currentItems.add(BasketItem(product: product, quantity: quantity));
    }

    emit(state.copyWith(items: currentItems));
    _saveToStorage();
  }

  Future<void> removeFromBasket(int productId) async {
    final List<BasketItem> currentItems = List.from(state.items);
    currentItems.removeWhere((item) => item.product.id == productId);
    emit(state.copyWith(items: currentItems));
    _saveToStorage();
  }

  Future<void> updateQuantity(int productId, int delta) async {
    final List<BasketItem> currentItems = List.from(state.items);
    final index = currentItems.indexWhere((item) => item.product.id == productId);

    if (index != -1) {
      final newQuantity = currentItems[index].quantity + delta;
      if (newQuantity > 0) {
        currentItems[index] = currentItems[index].copyWith(quantity: newQuantity);
        emit(state.copyWith(items: currentItems));
        _saveToStorage();
      } else {
        removeFromBasket(productId);
      }
    }
  }

  Future<void> checkout() async {
    try {
      for (var item in state.items) {
        for (int i = 0; i < item.quantity; i++) {
          await PurchaseHistoryManager.addPurchase(item.product);
        }
      }
      clearBasket();
    } catch (e) {
      emit(state.copyWith(status: BasketStatus.error, errorMessage: "Checkout failed: $e"));
    }
  }

  Future<void> clearBasket() async {
    emit(state.copyWith(items: const []));
    _saveToStorage();
  }

  Future<void> _saveToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final data = jsonEncode(state.items.map((e) => e.toJson()).toList());
    await prefs.setString(_storageKey, data);
  }
}
