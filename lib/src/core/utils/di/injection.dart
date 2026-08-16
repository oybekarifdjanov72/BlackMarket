import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:black_market/src/features/home/data/repository/home_repository_impl.dart';
import 'package:black_market/src/features/home/data/source/home_data_source.dart';
import 'package:black_market/src/features/home/domain/repository/home_repository.dart';
import 'package:black_market/src/features/home/domain/usecase/get_products_usecase.dart';
import 'package:black_market/src/features/home/presentation/cubit/HomeCubit.dart';

final GetIt sl = GetIt.instance;

/// Registers app-wide dependencies. Call once before [runApp].
Future<void> initDependencies() async {
  // External
  sl.registerLazySingleton<Dio>(
    () => Dio(
      BaseOptions(
        baseUrl: "https://dummyjson.com",
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        sendTimeout: const Duration(seconds: 10),
      ),
    ),
  );

  // Data sources
  sl.registerLazySingleton<HomeDataSource>(
    () => HomeRemoteDataSource(dio: sl()),
  );

  // Repositories
  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(dataSource: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetProductsUseCase(sl()));

  // Cubits / Blocs
  sl.registerFactory(() => HomeCubit(getProductsUseCase: sl()));
}
