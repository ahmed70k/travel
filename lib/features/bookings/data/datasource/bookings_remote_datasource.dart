import 'package:dio/dio.dart';
import '../../../../core/network/api_constants.dart';
import '../models/my_bookings_model.dart';

abstract class BookingsRemoteDataSource {
  Future<MyBookingsResponseModel> getMyBookings();
}

class BookingsRemoteDataSourceImpl implements BookingsRemoteDataSource {
  final Dio dio;

  BookingsRemoteDataSourceImpl({required this.dio});

  @override
  Future<MyBookingsResponseModel> getMyBookings() async {
    try {
      final response = await dio.get(ApiConstants.myBookings);
      return MyBookingsResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      rethrow;
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
