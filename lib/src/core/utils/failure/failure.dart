import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Something went wrong, please try again!']);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Failed to load cached data. Please try again!']);
}

class NetworkFailure extends Failure {
  const NetworkFailure([
    super.message = 'Check your internet connection and try again!',
  ]);
}
