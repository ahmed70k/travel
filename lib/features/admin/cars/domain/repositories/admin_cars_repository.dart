import 'package:dartz/dartz.dart';
import 'package:travle/core/network/error_handler.dart';
import '../entities/admin_cars_entity.dart';

abstract class AdminCarsRepository {
  Future<Either<Failure, AdminCarsEntity>> getCars({
    DateTime? from,
    DateTime? to,
    String? carType,
    String? category,
  });
}
