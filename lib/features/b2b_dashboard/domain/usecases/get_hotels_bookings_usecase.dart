import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/booking_entities.dart';
import '../repositories/bookings_repository.dart';

class GetB2BHotelsBookingsUseCase {
  final BookingsRepository repository;

  GetB2BHotelsBookingsUseCase({required this.repository});

  Future<Either<Failure, List<HotelBookingEntity>>> call() async {
    return await repository.getHotelsBookings();
  }
}
