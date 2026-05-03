import 'package:dartz/dartz.dart';
import 'package:travle/core/network/error_handler.dart';
import '../entities/admin_hotels_entity.dart';

abstract class AdminHotelsRepository {
  Future<Either<Failure, AdminHotelsEntity>> getHotels({
    DateTime? from,
    DateTime? to,
    String? guestsCount,
    String? category,
  });
}
