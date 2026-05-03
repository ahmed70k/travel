import 'package:dartz/dartz.dart';
import 'package:intl/intl.dart';
import 'package:travle/core/network/error_handler.dart';
import '../../domain/entities/admin_cars_entity.dart';
import '../../domain/repositories/admin_cars_repository.dart';
import '../datasources/admin_cars_remote_data_source.dart';

class AdminCarsRepositoryImpl implements AdminCarsRepository {
  final AdminCarsRemoteDataSource remoteDataSource;

  const AdminCarsRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, AdminCarsEntity>> getCars({
    DateTime? from,
    DateTime? to,
    String? carType,
    String? category,
  }) async {
    try {
      final response = await remoteDataSource.getCars(
        from: from != null ? DateFormat('yyyy-MM-dd').format(from) : null,
        to: to != null ? DateFormat('yyyy-MM-dd').format(to) : null,
        carType: carType,
        category: category,
      );
      return Right(response);
    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }
  }
}
