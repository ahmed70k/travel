import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:travle/core/error/failures.dart';
import '../../domain/entities/car_booking_entity.dart';
import '../../domain/repositories/car_booking_repository.dart';
import '../datasources/car_booking_remote_data_source.dart';
import '../models/car_booking_model.dart';

class CarBookingRepositoryImpl implements CarBookingRepository {
  final CarBookingRemoteDataSource remoteDataSource;

  CarBookingRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, CarBookingEntity>> createCarBooking(CarBookingEntity booking) async {
    try {
      final model = CarBookingModel.fromEntity(booking);
      final result = await remoteDataSource.createCarBooking(model);
      return Right(result.toEntity());
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        return const Left(ServerFailure('Booking already exists'));
      }
      if (e.response?.statusCode == 400) {
        final message = e.response?.data['message'] ?? 'Validation error';
        return Left(ServerFailure(message));
      }
      if (e.response?.statusCode == 401) {
        return const Left(ServerFailure('Unauthorized'));
      }
      return Left(ServerFailure(e.message ?? 'Server Error'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
