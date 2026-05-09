import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/my_bookings_entity.dart';
import '../../domain/repositories/bookings_repository.dart';
import '../datasource/bookings_remote_datasource.dart';

class BookingsRepositoryImpl implements BookingsRepository {
  final BookingsRemoteDataSource remoteDataSource;

  BookingsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, MyBookingsEntity>> getMyBookings() async {
    try {
      final response = await remoteDataSource.getMyBookings();
      if (response.success) {
        return Right(response.data.toEntity());
      } else {
        return Left(ServerFailure(response.message));
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        return Left(ServerFailure('Connection timeout'));
      }
      if (e.response?.statusCode == 401) {
        return Left(ServerFailure('Unauthorized access'));
      }
      return Left(ServerFailure(e.message ?? 'Server error'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
