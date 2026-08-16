import 'package:equatable/equatable.dart';
import 'package:black_market/src/core/utils/either/either.dart';
import 'package:black_market/src/core/utils/failure/failure.dart';

abstract class UseCase<Output, Params> {
  Future<Either<Failure, Output>> call(Params params);
}

abstract class StreamUseCase<Output, Params> {
  Stream<Output> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}
