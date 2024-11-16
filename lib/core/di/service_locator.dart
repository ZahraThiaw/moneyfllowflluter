import 'package:get_it/get_it.dart';
import 'package:moneyflow/core/http/dio_client_impl.dart';
import 'package:moneyflow/core/http/http_client_interface.dart';
import 'package:moneyflow/services/auth_service.dart';
import 'package:moneyflow/services/storage_service.dart';
import 'package:moneyflow/services/transaction_service.dart';

final GetIt sl = GetIt.instance;

void setupServiceLocator() {
  sl.registerLazySingleton<StorageService>(() => StorageService());

  // HTTP Client
  sl.registerLazySingleton<IHttpClient>(() => DioClientImpl());

  // Services
  sl.registerLazySingleton<AuthService>(
    () => AuthService(
      httpClient: sl<IHttpClient>(),
      storageService: sl<StorageService>(),
    ),
  );

  sl.registerLazySingleton<TransactionService>(
    () => TransactionService(
      httpClient: sl<IHttpClient>(),
    ),
  );
}
