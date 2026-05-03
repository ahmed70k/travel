import 'package:dartz/dartz.dart';
import 'package:travle/core/network/error_handler.dart';
import '../entities/admin_cars_entity.dart';
import '../repositories/admin_cars_repository.dart';

class GetAdminCarsUseCase {
  final AdminCarsRepository repository;

  const GetAdminCarsUseCase(this.repository);

  Future<Either<Failure, AdminCarsEntity>> call({
    DateTime? from,
    DateTime? to,
    String? carType,
    String? category,
  }) async {
    return await repository.getCars(
      from: from,
      to: to,
      carType: carType,
      category: category,
    );
  }
}
