import 'package:black_market/src/core/utils/either/either.dart';
import 'package:black_market/src/core/utils/failure/failure.dart';
import 'package:black_market/src/features/home/domain/entities/product_entity.dart';

abstract class HomeRepository {
  Future<Either<Failure, List<ProductEntity>>> getProducts({
    required int skip,
    int limit = 20,
  });
}
