import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/my_bookings_entity.dart';

abstract class BookingsRepository {
  Future<Either<Failure, MyBookingsEntity>> getMyBookings();
}
