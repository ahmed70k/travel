import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/my_bookings_entity.dart';
import '../repositories/bookings_repository.dart';

class GetMyBookingsUseCase {
  final BookingsRepository repository;

  GetMyBookingsUseCase(this.repository);

  Future<Either<Failure, MyBookingsEntity>> call() async {
    return await repository.getMyBookings();
  }
}
