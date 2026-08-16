import 'package:equatable/equatable.dart';
import 'package:black_market/src/core/utils/either/either.dart';
import 'package:black_market/src/core/utils/failure/failure.dart';
import 'package:black_market/src/core/utils/usecase/usecase.dart';
import 'package:black_market/src/features/home/domain/entities/product_entity.dart';
import 'package:black_market/src/features/home/domain/repository/home_repository.dart';

class GetProductsParams extends Equatable {
  final int skip;
  final int limit;

  const GetProductsParams({
    required this.skip,
    this.limit = 20,
  });

  @override
  List<Object?> get props => [skip, limit];
}

class GetProductsUseCase
    implements UseCase<List<ProductEntity>, GetProductsParams> {
  final HomeRepository repository;

  const GetProductsUseCase(this.repository);

  @override
  Future<Either<Failure, List<ProductEntity>>> call(GetProductsParams params) {
    return repository.getProducts(skip: params.skip, limit: params.limit);
  }
}
