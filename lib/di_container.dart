import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:eventflow/data/repos/media_repo.dart';
import 'package:eventflow/data/repos/notification_repo.dart';
import 'package:eventflow/viewmodels/providers/auth_provider.dart';
import 'package:eventflow/viewmodels/providers/home_provider.dart';
import 'package:eventflow/viewmodels/providers/media_provider.dart';
import 'package:eventflow/viewmodels/providers/profile_provider.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/datasource/dio/dio_clint.dart';
import 'data/datasource/dio/logging_intercepter.dart';
import 'resources/helper/network_info.dart';
import 'viewmodels/providers/theme_provider.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core
  sl.registerLazySingleton(() => NetworkInfo(sl()));
  sl.registerLazySingleton(() => DioClient( sl(),
      loggingInterceptor: sl(), sharedPreferences: sl()));

  // Repository
  sl.registerLazySingleton(() => NotificationRepo(dioClient: sl()));
  sl.registerLazySingleton(() => MediaRepo(dioClient: sl()));

  // Provider
  sl.registerFactory(() => ThemeProvider(sharedPreferences: sl()));
  sl.registerFactory(() => AuthProvider());
  sl.registerFactory(
      () => HomeProvider(sharedPreferences: sl(), notificationRepo: sl()));
  sl.registerFactory(() => ProfileProvider(sharedPreferences: sl()));
  sl.registerFactory(() => MediaProvider(sharedPreferences: sl(), mediaRepo: sl()));

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => LoggingInterceptor());
  sl.registerLazySingleton(() => Connectivity());
}
