import 'package:dartz/dartz.dart';
import '../../../../core/network/error_handler.dart';
import '../../domain/entities/booking_entities.dart';
import '../../domain/repositories/bookings_repository.dart';
import '../datasources/bookings_remote_data_source.dart';
import '../models/booking_models.dart';

class BookingsRepositoryImpl implements BookingsRepository {
  final BookingsRemoteDataSource remoteDataSource;

  BookingsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, MyBookingsEntity>> getMyBookings() async {
    try {
      final remoteBookings = await remoteDataSource.getMyBookings();
      return Right(remoteBookings);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, List<FlightBookingEntity>>> getFlightsBookings() async {
    try {
      final remoteBookings = await remoteDataSource.getFlightsBookings();
      return Right(remoteBookings);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, List<HotelBookingEntity>>> getHotelsBookings() async {
    try {
      final remoteBookings = await remoteDataSource.getHotelsBookings();
      return Right(remoteBookings);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, List<CarBookingEntity>>> getCarsBookings() async {
    try {
      final remoteBookings = await remoteDataSource.getCarsBookings();
      return Right(remoteBookings);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, FlightBookingEntity>> createFlightBooking(FlightBookingEntity booking) async {
    try {
      final model = FlightBookingModel.fromEntity(booking);
      final remoteBooking = await remoteDataSource.createFlightBooking(model);
      return Right(remoteBooking);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, HotelBookingEntity>> createHotelBooking(HotelBookingEntity booking) async {
    try {
      final model = HotelBookingModel.fromEntity(booking);
      final remoteBooking = await remoteDataSource.createHotelBooking(model);
      return Right(remoteBooking);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, CarBookingEntity>> createCarBooking(CarBookingEntity booking) async {
    try {
      final model = CarBookingModel.fromEntity(booking);
      final remoteBooking = await remoteDataSource.createCarBooking(model);
      return Right(remoteBooking);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }
}
