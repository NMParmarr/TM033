import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:eventflow/viewmodels/providers/auth_provider.dart';
import 'package:eventflow/viewmodels/providers/home_provider.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/datasource/dio/dio_clint.dart';
import 'data/datasource/dio/logging_intercepter.dart';
import 'resources/helper/network_info.dart';
import 'utils/constants/api_constants.dart';
import 'viewmodels/providers/theme_provider.dart';


final sl = GetIt.instance;

Future<void> init() async {

  // Core
  sl.registerLazySingleton(() => NetworkInfo(sl()));
  sl.registerLazySingleton(() => DioClient(Apis.baseUrl, sl(),
      loggingInterceptor: sl(), sharedPreferences: sl()));

  // Repository
  // sl.registerLazySingleton(() => SplashRepo(dioClient: sl(), sharedPreferences: sl()));
  // sl.registerLazySingleton(() => HomeRepo(dioClient: sl(), sharedPreferences: sl()));
  // sl.registerLazySingleton(() => LoginRepo(dioClient: sl(), sharedPreferences: sl()));





  // Provider
  // sl.registerFactory(() => SplashProvider(sharedPreferences: sl(),splashRepo: sl()));
  // sl.registerFactory(() => LoginProvider(sharedPreferences: sl(),loginRepo: sl()));
  // sl.registerFactory(() => SplashProvider(sharedPreferences: sl()));
  sl.registerFactory(() => ThemeProvider(sharedPreferences: sl()));
  sl.registerFactory(() => AuthProvider(sharedPreferences: sl()));
  sl.registerFactory(() => HomeProvider(sharedPreferences: sl()));


  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => LoggingInterceptor());
  sl.registerLazySingleton(() => Connectivity());
}