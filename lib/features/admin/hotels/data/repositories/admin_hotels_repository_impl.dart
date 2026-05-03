import 'package:dartz/dartz.dart';
import 'package:intl/intl.dart';
import 'package:travle/core/network/error_handler.dart';
import '../../domain/entities/admin_hotels_entity.dart';
import '../../domain/repositories/admin_hotels_repository.dart';
import '../datasources/admin_hotels_remote_data_source.dart';

class AdminHotelsRepositoryImpl implements AdminHotelsRepository {
  final AdminHotelsRemoteDataSource remoteDataSource;

  const AdminHotelsRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, AdminHotelsEntity>> getHotels({
    DateTime? from,
    DateTime? to,
    String? guestsCount,
    String? category,
  }) async {
    try {
      final response = await remoteDataSource.getHotels(
        from: from != null ? DateFormat('yyyy-MM-dd').format(from) : null,
        to: to != null ? DateFormat('yyyy-MM-dd').format(to) : null,
        guestsCount: guestsCount,
        category: category,
      );
      return Right(response);
    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }
  }
}
