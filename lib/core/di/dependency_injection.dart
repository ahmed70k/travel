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

import '../../features/admin/flights/data/datasources/admin_flights_remote_data_source.dart';
import '../../features/admin/flights/data/repositories/admin_flights_repository_impl.dart';
import '../../features/admin/flights/domain/repositories/admin_flights_repository.dart';
import '../../features/admin/flights/domain/usecases/get_admin_flights_usecase.dart';
import '../../features/admin/flights/domain/usecases/create_flight_booking_usecase.dart';
import '../../features/admin/flights/presentation/cubit/admin_flights_cubit.dart';
import '../../features/admin/flights/presentation/cubit/create_flight_booking_cubit.dart';
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
import '../../features/admin/users/domain/usecases/create_user_usecase.dart';
import '../../features/admin/users/domain/usecases/update_user_usecase.dart';
import '../../features/admin/users/domain/usecases/delete_user_usecase.dart';
import '../../features/admin/users/presentation/cubit/admin_users_cubit.dart';
import '../../features/admin/users/presentation/cubit/create_user_cubit.dart';
import '../../features/admin/users/presentation/cubit/update_user_cubit.dart';
import '../../features/admin/b2b_dashboard/data/datasources/admin_b2b_remote_data_source.dart';
import '../../features/admin/b2b_dashboard/data/repositories/admin_b2b_repository_impl.dart';
import '../../features/admin/b2b_dashboard/domain/repositories/admin_b2b_repository.dart';
import '../../features/admin/b2b_dashboard/domain/usecases/get_admin_b2b_usecase.dart';
import '../../features/admin/b2b_dashboard/presentation/cubit/admin_b2b_cubit.dart';
import '../../features/admin/b2c_dashboard/data/datasources/admin_b2c_remote_data_source.dart';
import '../../features/admin/b2c_dashboard/data/repositories/admin_b2c_repository_impl.dart';
import '../../features/admin/b2c_dashboard/domain/repositories/admin_b2c_repository.dart';
import '../../features/admin/b2c_dashboard/presentation/cubit/admin_b2c_cubit.dart';
import '../../features/b2b_dashboard/data/datasources/b2b_overview_remote_data_source.dart';
import '../../features/b2b_dashboard/data/repositories/b2b_overview_repository_impl.dart';
import '../../features/b2b_dashboard/domain/repositories/b2b_overview_repository.dart';
import '../../features/b2b_dashboard/domain/usecases/get_b2b_overview_usecase.dart';
import '../../features/b2b_dashboard/presentation/cubit/b2b_overview_cubit.dart';
import '../../features/bookings/data/datasource/bookings_remote_datasource.dart';
import '../../features/bookings/data/repositories/bookings_repository_impl.dart';
import '../../features/bookings/domain/repositories/bookings_repository.dart';
import '../../features/bookings/domain/usecases/get_my_bookings_usecase.dart';
import '../../features/bookings/presentation/cubit/my_bookings_cubit.dart';
import '../../features/b2b_dashboard/presentation/cubit/b2b_flight_bookings_cubit.dart';
import '../../features/b2b_dashboard/presentation/cubit/b2b_hotel_bookings_cubit.dart';
import '../../features/b2b_dashboard/presentation/cubit/b2b_car_bookings_cubit.dart';
import '../../features/b2b_dashboard/data/datasources/flights_availability_remote_data_source.dart';
import '../../features/b2b_dashboard/data/repositories/flights_availability_repository_impl.dart';
import '../../features/b2b_dashboard/domain/repositories/flights_availability_repository.dart';
import '../../features/b2b_dashboard/domain/usecases/get_flights_availability_usecase.dart';
import '../../features/b2b_dashboard/presentation/cubit/flights_availability_cubit.dart';
import '../../features/b2b_dashboard/data/datasources/hotels_availability_remote_data_source.dart';
import '../../features/b2b_dashboard/data/repositories/hotels_availability_repository_impl.dart';
import '../../features/b2b_dashboard/domain/usecases/get_hotels_availability_usecase.dart';
import '../../features/b2b_dashboard/presentation/cubit/hotels_availability_cubit.dart';
import '../../features/b2b_dashboard/data/datasources/cars_availability_remote_data_source.dart';
import '../../features/b2b_dashboard/data/repositories/cars_availability_repository_impl.dart';
import '../../features/b2b_dashboard/domain/usecases/get_cars_availability_usecase.dart';
import '../../features/b2b_dashboard/presentation/cubit/cars_availability_cubit.dart';
import '../../features/admin/main_dashboard/data/datasources/admin_dashboard_remote_data_source.dart';
import '../../features/admin/main_dashboard/data/repositories/admin_dashboard_repository_impl.dart';
import '../../features/admin/main_dashboard/domain/repositories/admin_dashboard_repository.dart';
import '../../features/admin/main_dashboard/domain/usecases/get_admin_dashboard_usecase.dart';
import '../../features/admin/main_dashboard/presentation/cubit/admin_dashboard_cubit.dart';

import '../../features/admin/hotels/data/datasources/hotel_booking_remote_data_source.dart';
import '../../features/admin/hotels/data/repositories/hotel_bookings_repository_impl.dart';
import '../../features/admin/hotels/domain/repositories/hotel_bookings_repository.dart';
import '../../features/admin/hotels/domain/usecases/create_hotel_booking_usecase.dart';
import '../../features/admin/hotels/presentation/cubit/create_hotel_booking_cubit.dart';
import '../../features/admin/cars/data/datasources/car_bookings_remote_data_source.dart';
import '../../features/admin/cars/data/repositories/car_bookings_repository_impl.dart';
import '../../features/admin/cars/domain/repositories/car_bookings_repository.dart';
import '../../features/admin/cars/domain/usecases/get_car_bookings_usecase.dart';
import '../../features/admin/cars/presentation/cubit/car_bookings_cubit.dart';
import '../../features/admin/cars/data/datasources/car_booking_remote_data_source.dart';
import '../../features/admin/cars/data/repositories/car_booking_repository_impl.dart';
import '../../features/admin/cars/domain/repositories/car_booking_repository.dart';
import '../../features/admin/cars/domain/usecases/create_car_booking_usecase.dart';
import '../../features/admin/cars/presentation/cubit/create_car_booking_cubit.dart';
import '../../features/admin/profile/presentation/cubit/admin_profile_cubit.dart';
import '../../features/b2c_bookings/data/datasources/b2c_bookings_remote_data_source.dart';
import '../../features/b2c_bookings/data/repositories/b2c_bookings_repository_impl.dart';
import '../../features/b2c_bookings/domain/repositories/b2c_bookings_repository.dart';
import '../../features/b2c_bookings/domain/usecases/get_b2c_flight_bookings_usecase.dart';
import '../../features/b2c_bookings/domain/usecases/create_b2c_flight_booking_usecase.dart';
import '../../features/b2c_bookings/domain/usecases/get_b2c_hotel_bookings_usecase.dart';
import '../../features/b2c_bookings/domain/usecases/create_b2c_hotel_booking_usecase.dart';
import '../../features/b2c_bookings/domain/usecases/get_b2c_car_bookings_usecase.dart';
import '../../features/b2c_bookings/domain/usecases/create_b2c_car_booking_usecase.dart';
import '../../features/b2c_bookings/presentation/cubit/b2c_flight_bookings_cubit.dart';
import '../../features/b2c_bookings/presentation/cubit/b2c_hotel_bookings_cubit.dart';
import '../../features/b2c_bookings/presentation/cubit/b2c_car_bookings_cubit.dart';
import '../../features/client_dashboard/data/datasource/dashboard_remote_datasource.dart';
import '../../features/client_dashboard/data/repositories/dashboard_repository_impl.dart';
import '../../features/client_dashboard/domain/repositories/dashboard_repository.dart';
import '../../features/client_dashboard/domain/usecases/get_current_dashboard_usecase.dart';
import '../../features/client_dashboard/presentation/cubit/b2c_overview_cubit.dart';
import '../../features/b2b_dashboard/data/datasources/bookings_remote_data_source.dart' as b2b_ds;
import '../../features/b2b_dashboard/data/repositories/bookings_repository_impl.dart' as b2b_repo;
import '../../features/b2b_dashboard/domain/repositories/bookings_repository.dart' as b2b_domain_repo;
import '../../features/b2b_dashboard/domain/usecases/get_my_bookings_usecase.dart' as b2b_uc;
import '../../features/b2b_dashboard/domain/usecases/get_flights_bookings_usecase.dart';
import '../../features/b2b_dashboard/domain/usecases/create_flight_booking_usecase.dart';
import '../../features/b2b_dashboard/domain/usecases/get_hotels_bookings_usecase.dart';
import '../../features/b2b_dashboard/domain/usecases/create_hotel_booking_usecase.dart';
import '../../features/b2b_dashboard/domain/usecases/get_cars_bookings_usecase.dart';
import '../../features/b2b_dashboard/domain/usecases/create_car_booking_usecase.dart';
import '../../features/b2b_dashboard/presentation/cubit/my_bookings_cubit.dart' as b2b_cubit;


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
  sl.registerLazySingleton<AdminB2CRemoteDataSource>(
    () => AdminB2CRemoteDataSourceImpl(dio: sl<DioClient>().dio),
  );
  sl.registerLazySingleton<B2BOverviewRemoteDataSource>(
    () => B2BOverviewRemoteDataSourceImpl(sl<DioClient>().dio),
  );
  sl.registerLazySingleton<BookingsRemoteDataSource>(
    () => BookingsRemoteDataSourceImpl(dio: sl<DioClient>().dio),
  );
  sl.registerLazySingleton<b2b_ds.BookingsRemoteDataSource>(
    () => b2b_ds.BookingsRemoteDataSourceImpl(dio: sl<DioClient>().dio),
  );

  sl.registerLazySingleton<FlightsAvailabilityRemoteDataSource>(
    () => FlightsAvailabilityRemoteDataSourceImpl(dio: sl<DioClient>().dio),
  );
  sl.registerLazySingleton<HotelsAvailabilityRemoteDataSource>(
    () => HotelsAvailabilityRemoteDataSourceImpl(dio: sl<DioClient>().dio),
  );
  sl.registerLazySingleton<CarsAvailabilityRemoteDataSource>(
    () => CarsAvailabilityRemoteDataSourceImpl(dio: sl<DioClient>().dio),
  );
  sl.registerLazySingleton<AdminDashboardRemoteDataSource>(
    () => AdminDashboardRemoteDataSourceImpl(sl<DioClient>().dio),
  );

  sl.registerLazySingleton<HotelBookingRemoteDataSource>(
    () => HotelBookingRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<CarBookingsRemoteDataSource>(
    () => CarBookingsRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<CarBookingRemoteDataSource>(
    () => CarBookingRemoteDataSourceImpl(sl<DioClient>().dio),
  );
  sl.registerLazySingleton<B2CBookingsRemoteDataSource>(
    () => B2CBookingsRemoteDataSourceImpl(dio: sl<DioClient>().dio),
  );
  sl.registerLazySingleton<DashboardRemoteDataSource>(
    () => DashboardRemoteDataSourceImpl(dio: sl<DioClient>().dio),
  );

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
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
  sl.registerLazySingleton<AdminB2CRepository>(
    () => AdminB2CRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<B2BOverviewRepository>(
    () => B2BOverviewRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<BookingsRepository>(
    () => BookingsRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<b2b_domain_repo.BookingsRepository>(
    () => b2b_repo.BookingsRepositoryImpl(remoteDataSource: sl<b2b_ds.BookingsRemoteDataSource>()),
  );

  sl.registerLazySingleton<FlightsAvailabilityRepository>(
    () => FlightsAvailabilityRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<HotelsAvailabilityRepository>(
    () => HotelsAvailabilityRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<CarsAvailabilityRepository>(
    () => CarsAvailabilityRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<AdminDashboardRepository>(
    () => AdminDashboardRepositoryImpl(sl()),
  );

  sl.registerLazySingleton<HotelBookingsRepository>(
    () => HotelBookingsRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<CarBookingsRepository>(
    () => CarBookingsRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<CarBookingRepository>(
    () => CarBookingRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<B2CBookingsRepository>(
    () => B2CBookingsRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryImpl(remoteDataSource: sl()),
  );

  // Use Cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RefreshTokenUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => GetAdminFlightsUseCase(sl()));
  sl.registerLazySingleton(() => GetAdminHotelsUseCase(sl()));
  sl.registerLazySingleton(() => GetAdminCarsUseCase(sl()));
  sl.registerLazySingleton(() => GetAdminUsersUseCase(sl()));
  sl.registerLazySingleton(() => CreateUserUseCase(sl()));
  sl.registerLazySingleton(() => UpdateUserUseCase(sl()));
  sl.registerLazySingleton(() => DeleteUserUseCase(sl()));
  sl.registerLazySingleton(() => GetAdminB2BUseCase(sl()));
  sl.registerLazySingleton(() => GetB2BOverviewUseCase(sl()));
  sl.registerLazySingleton(() => GetMyBookingsUseCase(sl()));
  sl.registerLazySingleton(() => b2b_uc.GetMyBookingsUseCase(repository: sl<b2b_domain_repo.BookingsRepository>()));
  sl.registerLazySingleton(() => GetCurrentDashboardUseCase(sl()));
  sl.registerLazySingleton(() => GetFlightsAvailabilityUseCase(sl()));
  sl.registerLazySingleton(() => GetHotelsAvailabilityUseCase(sl()));
  sl.registerLazySingleton(() => GetCarsAvailabilityUseCase(sl()));
  sl.registerLazySingleton(() => GetAdminDashboardUseCase(sl()));

  sl.registerLazySingleton(() => CreateHotelBookingUseCase(sl()));
  sl.registerLazySingleton(() => GetCarBookingsUseCase(sl()));
  sl.registerLazySingleton(() => CreateCarBookingUseCase(sl()));
  sl.registerLazySingleton(() => GetB2CFlightBookingsUseCase(sl()));
  sl.registerLazySingleton(() => CreateB2CFlightBookingUseCase(sl()));
  sl.registerLazySingleton(() => GetB2CHotelBookingsUseCase(sl()));
  sl.registerLazySingleton(() => CreateB2CHotelBookingUseCase(sl()));
  sl.registerLazySingleton(() => GetB2CCarBookingsUseCase(sl()));
  sl.registerLazySingleton(() => CreateB2CCarBookingUseCase(sl()));
  sl.registerLazySingleton(() => CreateFlightBookingUseCase(sl()));

  sl.registerLazySingleton(() => GetB2BFlightsBookingsUseCase(repository: sl()));
  sl.registerLazySingleton(() => CreateB2BFlightBookingUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetB2BHotelsBookingsUseCase(repository: sl()));
  sl.registerLazySingleton(() => CreateB2BHotelBookingUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetB2BCarsBookingsUseCase(repository: sl()));
  sl.registerLazySingleton(() => CreateB2BCarBookingUseCase(repository: sl()));

  // Cubits
  sl.registerFactory(() => LoginCubit(sl()));
  sl.registerFactory(() => AuthCubit(sl(), sl()));
  sl.registerFactory(() => LogoutCubit(sl()));

  sl.registerFactory(() => AdminFlightsCubit(sl()));
  sl.registerFactory(() => AdminHotelsCubit(sl()));
  sl.registerFactory(() => AdminCarsCubit(sl()));
  sl.registerFactory(() => AdminUsersCubit(sl(), sl()));
  sl.registerFactory(() => CreateUserCubit(sl()));
  sl.registerFactory(() => UpdateUserCubit(sl()));
  sl.registerFactory(() => AdminB2BCubit(getAdminB2BUseCase: sl()));
  sl.registerFactory(() => AdminB2CCubit(repository: sl()));
  sl.registerFactory(() => B2BOverviewCubit(sl()));
  sl.registerFactory(() => MyBookingsCubit(sl()));
  sl.registerFactory(() => b2b_cubit.B2BMyBookingsCubit(getMyBookingsUseCase: sl<b2b_uc.GetMyBookingsUseCase>()));
  sl.registerFactory(() => B2BFlightBookingsCubit(
    getFlightsUseCase: sl(),
    createFlightUseCase: sl(),
  ));
  sl.registerFactory(() => B2BHotelBookingsCubit(
    getHotelsUseCase: sl(),
    createHotelUseCase: sl(),
  ));
  sl.registerFactory(() => B2BCarBookingsCubit(
    getCarsUseCase: sl(),
    createCarUseCase: sl(),
  ));
  sl.registerFactory(() => FlightsAvailabilityCubit(getFlightsAvailabilityUseCase: sl()));
  sl.registerFactory(() => HotelsAvailabilityCubit(getHotelsAvailabilityUseCase: sl()));
  sl.registerFactory(() => CarsAvailabilityCubit(getCarsAvailabilityUseCase: sl()));
  sl.registerFactory(() => AdminDashboardCubit(sl()));

  sl.registerFactory(() => CreateHotelBookingCubit(sl()));
  sl.registerFactory(() => CarBookingsCubit(sl()));
  sl.registerFactory(() => CreateCarBookingCubit(sl()));
  sl.registerFactory(() => CreateFlightBookingCubit(sl()));
  sl.registerFactory(() => AdminProfileCubit(sl()));

  sl.registerFactory(() => B2CFlightBookingsCubit(
    getFlightsUseCase: sl(),
    createFlightUseCase: sl(),
  ));
  sl.registerFactory(() => B2CHotelBookingsCubit(
    getHotelsUseCase: sl(),
    createHotelUseCase: sl(),
  ));
  sl.registerFactory(() => B2CCarBookingsCubit(
    getCarsUseCase: sl(),
    createCarUseCase: sl(),
  ));
  sl.registerFactory(() => B2cOverviewCubit(getCurrentDashboardUseCase: sl()));
}
