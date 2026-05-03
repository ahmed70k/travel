import 'package:dartz/dartz.dart';
import 'package:travle/core/network/error_handler.dart';
import '../entities/admin_hotels_entity.dart';
import '../repositories/admin_hotels_repository.dart';

class GetAdminHotelsUseCase {
  final AdminHotelsRepository repository;

  const GetAdminHotelsUseCase(this.repository);

  Future<Either<Failure, AdminHotelsEntity>> call({
    DateTime? from,
    DateTime? to,
    String? guestsCount,
    String? category,
  }) async {
    return await repository.getHotels(
      from: from,
      to: to,
      guestsCount: guestsCount,
      category: category,
    );
  }
}
