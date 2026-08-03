import 'package:equatable/equatable.dart';
import '../../../core/model/ProductsModel.dart';

enum BasketStatus { initial, loading, success, error }

class BasketState extends Equatable {
  final List<BasketItem> items;
  final BasketStatus status;
  final String? errorMessage;

  const BasketState({
    this.items = const [],
    this.status = BasketStatus.initial,
    this.errorMessage,
  });

  double get totalPrice => items.fold(0.0, (sum, item) => sum + (item.product.price * item.quantity));
  
  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  BasketState copyWith({
    List<BasketItem>? items,
    BasketStatus? status,
    String? errorMessage,
  }) {
    return BasketState(
      items: items ?? this.items,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [items, status, errorMessage];
}

class BasketItem extends Equatable {
  final ProductModel product;
  final int quantity;

  const BasketItem({required this.product, required this.quantity});

  BasketItem copyWith({int? quantity}) {
    return BasketItem(
      product: product,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toJson() => {
    'product': product.toJson(),
    'quantity': quantity,
  };

  factory BasketItem.fromJson(Map<String, dynamic> json) => BasketItem(
    product: ProductModel.fromJson(json['product']),
    quantity: json['quantity'] ?? 1,
  );

  @override
  List<Object?> get props => [product, quantity];
}
