import 'package:dio/dio.dart';
import 'package:black_market/src/features/home/data/model/ProductsModel.dart';

abstract class HomeDataSource {
  Future<List<ProductModel>> getProducts({
    required int skip,
    int limit = 20,
  });
}

class HomeRemoteDataSource implements HomeDataSource {
  final Dio dio;

  HomeRemoteDataSource({required this.dio});

  @override
  Future<List<ProductModel>> getProducts({
    required int skip,
    int limit = 20,
  }) async {
    final response = await dio.get(
      "/products",
      queryParameters: {
        "limit": limit,
        "skip": skip,
      },
    );

    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      final List products = response.data["products"] ?? [];
      return products.map((e) => ProductModel.fromJson(e)).toList();
    }

    throw DioException(
      requestOptions: response.requestOptions,
      response: response,
      type: DioExceptionType.badResponse,
      message: "Request failed with status code ${response.statusCode}",
    );
  }
}

/// Kept for backward compatibility with older call sites.
@Deprecated('Use HomeRemoteDataSource via DI instead')
class ApiService {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: "https://dummyjson.com",
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(seconds: 10),
    ),
  );

  static Future<List<ProductModel>> getProducts({
    required int skip,
    int limit = 20,
  }) {
    return HomeRemoteDataSource(dio: dio).getProducts(skip: skip, limit: limit);
  }
}
