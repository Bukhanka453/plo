import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'auth_interceptor.dart';

final getIt = GetIt.instance;

void setupLocator() {
  getIt.registerLazySingleton<Dio>(() {
    final dio = Dio(BaseOptions(
      baseUrl: 'https://api.api-ninjas.com/',
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
    ));

    dio.interceptors.add(AuthInterceptor('K5MsZRmxtHdUNuy4marEcCjs17zYxzGQGOyfOjBv'));

    dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      error: true,
      compact: true,
    ));

    return dio;
  });
}