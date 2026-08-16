import 'dart:io';

import 'package:dio/dio.dart';
import 'package:black_market/src/core/utils/failure/failure.dart';

/// Maps low-level exceptions to user-friendly [Failure]s.
class ExceptionMapper {
  const ExceptionMapper._();

  static Failure map(Object error) {
    if (error is Failure) return error;

    if (error is SocketException) {
      return const NetworkFailure(
        'Check your internet connection and try again!',
      );
    }

    if (error is DioException) {
      return _mapDioException(error);
    }

    final text = error.toString().toLowerCase();
    if (text.contains('socketexception') ||
        text.contains('no internet') ||
        text.contains('network')) {
      return const NetworkFailure(
        'Check your internet connection and try again!',
      );
    }

    if (text.contains('timeout')) {
      return const ServerFailure(
        'The request timed out. Please try again!',
      );
    }

    return const ServerFailure('Something went wrong, please try again!');
  }

  static String toUserMessage(Object error) => map(error).message;

  static Failure _mapDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionError:
      case DioExceptionType.connectionTimeout:
        return const NetworkFailure(
          'Check your internet connection and try again!',
        );
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const ServerFailure(
          'The request timed out. Please try again!',
        );
      case DioExceptionType.badResponse:
        return const ServerFailure(
          'Something went wrong, please try again!',
        );
      case DioExceptionType.cancel:
        return const ServerFailure('Request was cancelled. Please try again!');
      case DioExceptionType.badCertificate:
        return const ServerFailure(
          'Secure connection failed. Please try again!',
        );
      case DioExceptionType.unknown:
        if (e.error is SocketException) {
          return const NetworkFailure(
            'Check your internet connection and try again!',
          );
        }
        return const ServerFailure('Something went wrong, please try again!');
      default:
        return const ServerFailure('Something went wrong, please try again!');
    }
  }
}
