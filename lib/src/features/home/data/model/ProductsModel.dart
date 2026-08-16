import 'package:black_market/src/features/home/domain/entities/product_entity.dart';

class ProductModel {
  final int id;
  final String title;
  final String description;
  final String category;
  final double price;
  final double discountPercentage;
  final double rating;
  final int stock;
  final String brand;
  final String thumbnail;
  final List<String> images;
  final bool isFavorite;
  final String? warrantyInformation;
  final String? shippingInformation;

  ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    required this.brand,
    required this.thumbnail,
    required this.images,
    this.isFavorite = false,
    this.warrantyInformation,
    this.shippingInformation,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json["id"] ?? 0,
      title: json["title"] ?? "",
      description: json["description"] ?? "",
      category: json["category"] ?? "",
      price: (json["price"] ?? 0).toDouble(),
      discountPercentage: (json["discountPercentage"] ?? 0).toDouble(),
      rating: (json["rating"] ?? 0).toDouble(),
      stock: json["stock"] ?? 0,
      brand: json["brand"] ?? "",
      thumbnail: json["thumbnail"] ?? "",
      images: List<String>.from(json["images"] ?? []),
      isFavorite: json["isFavorite"] ?? false,
      warrantyInformation: json["warrantyInformation"],
      shippingInformation: json["shippingInformation"],
    );
  }

  factory ProductModel.fromEntity(ProductEntity entity) {
    return ProductModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      category: entity.category,
      price: entity.price,
      discountPercentage: entity.discountPercentage,
      rating: entity.rating,
      stock: entity.stock,
      brand: entity.brand,
      thumbnail: entity.thumbnail,
      images: entity.images,
      isFavorite: entity.isFavorite,
      warrantyInformation: entity.warrantyInformation,
      shippingInformation: entity.shippingInformation,
    );
  }

  ProductEntity toEntity() {
    return ProductEntity(
      id: id,
      title: title,
      description: description,
      category: category,
      price: price,
      discountPercentage: discountPercentage,
      rating: rating,
      stock: stock,
      brand: brand,
      thumbnail: thumbnail,
      images: images,
      isFavorite: isFavorite,
      warrantyInformation: warrantyInformation,
      shippingInformation: shippingInformation,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "category": category,
      "price": price,
      "discountPercentage": discountPercentage,
      "rating": rating,
      "stock": stock,
      "brand": brand,
      "thumbnail": thumbnail,
      "images": images,
      "isFavorite": isFavorite,
      "warrantyInformation": warrantyInformation,
      "shippingInformation": shippingInformation,
    };
  }

  ProductModel copyWith({
    int? id,
    String? title,
    String? description,
    String? category,
    double? price,
    double? discountPercentage,
    double? rating,
    int? stock,
    String? brand,
    String? thumbnail,
    List<String>? images,
    bool? isFavorite,
    String? warrantyInformation,
    String? shippingInformation,
  }) {
    return ProductModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      price: price ?? this.price,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      rating: rating ?? this.rating,
      stock: stock ?? this.stock,
      brand: brand ?? this.brand,
      thumbnail: thumbnail ?? this.thumbnail,
      images: images ?? this.images,
      isFavorite: isFavorite ?? this.isFavorite,
      warrantyInformation: warrantyInformation ?? this.warrantyInformation,
      shippingInformation: shippingInformation ?? this.shippingInformation,
    );
  }
}
