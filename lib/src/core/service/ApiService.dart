import 'dart:io';
import 'package:dio/dio.dart';
import '../model/ProductsModel.dart';

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
  }) async {
    try {
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
        final List products = response.data["products"];

        return products
            .map((e) => ProductModel.fromJson(e))
            .toList();
      } else {
        throw Exception(
          "Request failed with status code ${response.statusCode}",
        );
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError) {
        throw const SocketException("No Internet Connection");
      }
      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception("Connection Timeout");
      }
      if (e.type == DioExceptionType.receiveTimeout) {
        throw Exception("Receive Timeout");
      }
      if (e.type == DioExceptionType.sendTimeout) {
        throw Exception("Send Timeout");
      }
      throw Exception(
        e.response?.data["message"] ??
            e.message ??
            "Something went wrong",
      );
    } on SocketException {
      throw Exception("No Internet Connection");
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
