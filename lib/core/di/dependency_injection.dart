import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../network/auth_interceptor.dart';
import '../network/dio_client.dart';

import '../../features/auth/data/datasources/auth_local_data_source.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/usecases/refresh_token_usecase.dart';
import '../../features/auth/domain/usecases/get_current_user_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/presentation/cubit/login_cubit.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/auth/presentation/cubit/logout_cubit.dart';
import '../../features/admin/dashboard/data/datasources/admin_remote_data_source.dart';
import '../../features/admin/dashboard/data/repositories/admin_repository_impl.dart';
import '../../features/admin/dashboard/domain/repositories/admin_repository.dart';
import '../../features/admin/dashboard/domain/usecases/get_admin_overview_usecase.dart';
import '../../features/admin/dashboard/presentation/cubit/admin_overview_cubit.dart';
import '../../features/admin/flights/data/datasources/admin_flights_remote_data_source.dart';
import '../../features/admin/flights/data/repositories/admin_flights_repository_impl.dart';
import '../../features/admin/flights/domain/repositories/admin_flights_repository.dart';
import '../../features/admin/flights/domain/usecases/get_admin_flights_usecase.dart';
import '../../features/admin/flights/presentation/cubit/admin_flights_cubit.dart';
import '../../features/admin/hotels/data/datasources/admin_hotels_remote_data_source.dart';
import '../../features/admin/hotels/data/repositories/admin_hotels_repository_impl.dart';
import '../../features/admin/hotels/domain/repositories/admin_hotels_repository.dart';
import '../../features/admin/hotels/domain/usecases/get_admin_hotels_usecase.dart';
import '../../features/admin/hotels/presentation/cubit/admin_hotels_cubit.dart';
import '../../features/admin/cars/data/datasources/admin_cars_remote_data_source.dart';
import '../../features/admin/cars/data/repositories/admin_cars_repository_impl.dart';
import '../../features/admin/cars/domain/repositories/admin_cars_repository.dart';
import '../../features/admin/cars/domain/usecases/get_admin_cars_usecase.dart';
import '../../features/admin/cars/presentation/cubit/admin_cars_cubit.dart';
import '../../features/admin/users/data/datasources/admin_users_remote_data_source.dart';
import '../../features/admin/users/data/repositories/admin_users_repository_impl.dart';
import '../../features/admin/users/domain/repositories/admin_users_repository.dart';
import '../../features/admin/users/domain/usecases/get_admin_users_usecase.dart';
import '../../features/admin/users/presentation/cubit/admin_users_cubit.dart';
import '../../features/admin/b2b_dashboard/data/datasources/admin_b2b_remote_data_source.dart';
import '../../features/admin/b2b_dashboard/data/repositories/admin_b2b_repository_impl.dart';
import '../../features/admin/b2b_dashboard/domain/repositories/admin_b2b_repository.dart';
import '../../features/admin/b2b_dashboard/domain/usecases/get_admin_b2b_usecase.dart';
import '../../features/admin/b2b_dashboard/presentation/cubit/admin_b2b_cubit.dart';
import '../../features/client_dashboard/data/datasources/b2c_remote_data_source.dart';
import '../../features/client_dashboard/data/repositories/b2c_overview_repository_impl.dart';
import '../../features/client_dashboard/domain/repositories/b2c_overview_repository.dart';
import '../../features/client_dashboard/domain/usecases/get_b2c_overview_usecase.dart';
import '../../features/client_dashboard/presentation/state/b2c_overview_cubit.dart';
import '../../features/client_dashboard/data/datasources/me_dashboard_remote_data_source.dart';
import '../../features/client_dashboard/data/repositories/me_dashboard_repository_impl.dart';
import '../../features/client_dashboard/domain/repositories/me_dashboard_repository.dart';
import '../../features/client_dashboard/domain/usecases/get_me_dashboard_usecase.dart';
import '../../features/client_dashboard/presentation/state/me_dashboard_cubit.dart';

final sl = GetIt.instance;
final GlobalKey<NavigatorState> globalNavigatorKey =
    GlobalKey<NavigatorState>();

Future<void> initDI() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => const FlutterSecureStorage());

  // Core
  sl.registerLazySingleton(
    () => AuthInterceptor(
      secureStorage: sl(),
      authRepo: () => sl<AuthRepository>(),
      dioClient: () => sl<DioClient>(),
    ),
  );
  sl.registerLazySingleton(
    () => DioClient(authInterceptor: sl<AuthInterceptor>()),
  );

  // Data Sources
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(secureStorage: sl(), sharedPreferences: sl()),
  );
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dio: sl<DioClient>().dio),
  );
  sl.registerLazySingleton<AdminRemoteDataSource>(
    () => AdminRemoteDataSourceImpl(dio: sl<DioClient>().dio),
  );
  sl.registerLazySingleton<AdminFlightsRemoteDataSource>(
    () => AdminFlightsRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<AdminHotelsRemoteDataSource>(
    () => AdminHotelsRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<AdminCarsRemoteDataSource>(
    () => AdminCarsRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<AdminUsersRemoteDataSource>(
    () => AdminUsersRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<AdminB2BRemoteDataSource>(
    () => AdminB2BRemoteDataSourceImpl(dio: sl<DioClient>().dio),
  );
  sl.registerLazySingleton<B2CRemoteDataSource>(
    () => B2CRemoteDataSourceImpl(dio: sl<DioClient>().dio),
  );
  sl.registerLazySingleton<MeDashboardRemoteDataSource>(
    () => MeDashboardRemoteDataSourceImpl(dio: sl<DioClient>().dio),
  );

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );
  sl.registerLazySingleton<AdminRepository>(
    () => AdminRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<AdminFlightsRepository>(
    () => AdminFlightsRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<AdminHotelsRepository>(
    () => AdminHotelsRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<AdminCarsRepository>(
    () => AdminCarsRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<AdminUsersRepository>(
    () => AdminUsersRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<AdminB2BRepository>(
    () => AdminB2BRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<B2COverviewRepository>(
    () => B2COverviewRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<MeDashboardRepository>(
    () => MeDashboardRepositoryImpl(remoteDataSource: sl()),
  );

  // Use Cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RefreshTokenUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => GetAdminOverviewUseCase(sl()));
  sl.registerLazySingleton(() => GetAdminFlightsUseCase(sl()));
  sl.registerLazySingleton(() => GetAdminHotelsUseCase(sl()));
  sl.registerLazySingleton(() => GetAdminCarsUseCase(sl()));
  sl.registerLazySingleton(() => GetAdminUsersUseCase(sl()));
  sl.registerLazySingleton(() => GetAdminB2BUseCase(sl()));
  sl.registerLazySingleton(() => GetB2COverviewUseCase(sl()));
  sl.registerLazySingleton(() => GetMeDashboardUseCase(sl()));

  // Cubits
  sl.registerFactory(() => LoginCubit(sl()));
  sl.registerFactory(() => AuthCubit(sl(), sl()));
  sl.registerFactory(() => LogoutCubit(sl()));
  sl.registerFactory(() => AdminOverviewCubit(sl()));
  sl.registerFactory(() => AdminFlightsCubit(sl()));
  sl.registerFactory(() => AdminHotelsCubit(sl()));
  sl.registerFactory(() => AdminCarsCubit(sl()));
  sl.registerFactory(() => AdminUsersCubit(sl()));
  sl.registerFactory(() => AdminB2BCubit(getAdminB2BUseCase: sl()));
  sl.registerFactory(() => B2COverviewCubit(sl()));
  sl.registerFactory(() => MeDashboardCubit(sl()));
}
