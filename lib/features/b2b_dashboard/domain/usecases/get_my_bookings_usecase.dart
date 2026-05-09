import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/booking_entities.dart';
import '../repositories/bookings_repository.dart';

class GetMyBookingsUseCase {
  final BookingsRepository repository;

  GetMyBookingsUseCase({required this.repository});

  Future<Either<Failure, MyBookingsEntity>> call() async {
    return await repository.getMyBookings();
  }
}
