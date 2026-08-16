import 'package:black_market/src/core/utils/either/either.dart';
import 'package:black_market/src/core/utils/exception/exception_mapper.dart';
import 'package:black_market/src/core/utils/failure/failure.dart';
import 'package:black_market/src/features/home/data/source/home_data_source.dart';
import 'package:black_market/src/features/home/domain/entities/product_entity.dart';
import 'package:black_market/src/features/home/domain/repository/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeDataSource dataSource;

  const HomeRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, List<ProductEntity>>> getProducts({
    required int skip,
    int limit = 20,
  }) async {
    try {
      final products = await dataSource.getProducts(skip: skip, limit: limit);
      return Right(products.map((product) => product.toEntity()).toList());
    } catch (error) {
      return Left(ExceptionMapper.map(error));
    }
  }
}
