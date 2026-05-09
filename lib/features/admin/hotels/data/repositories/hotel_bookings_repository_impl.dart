import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../../core/error/failures.dart';
import '../datasources/hotel_booking_remote_data_source.dart';
import '../models/create_hotel_booking_request.dart';
import '../../domain/repositories/hotel_bookings_repository.dart';

class HotelBookingsRepositoryImpl implements HotelBookingsRepository {
  final HotelBookingRemoteDataSource remoteDataSource;

  const HotelBookingsRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, Map<String, dynamic>>> createBooking(CreateHotelBookingRequest request) async {
    try {
      final result = await remoteDataSource.createBooking(request);
      return Right(result);
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        return const Left(ServerFailure('Booking ID already exists'));
      }
      if (e.response?.statusCode == 400) {
        final data = e.response?.data;
        String errorMessage = 'Validation error';
        if (data is Map && data.containsKey('message')) {
          errorMessage = data['message'].toString();
        }
        return Left(ServerFailure(errorMessage));
      }
      return Left(ServerFailure(e.message ?? 'Server error'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
