import 'package:dio/dio.dart';
import '../error/failures.dart';
export '../error/failures.dart';

class ErrorHandler {
  final Failure failure;

  ErrorHandler(this.failure);

  factory ErrorHandler.handle(dynamic error) {
    if (error is DioException) {
      return ErrorHandler(_handleDioError(error));
    } else {
      return ErrorHandler(const ServerFailure("An unexpected error occurred."));
    }
  }

  static Failure _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkFailure("Connection timeout. Please try again.");
      case DioExceptionType.badResponse:
        return _handleBadResponse(error.response);
      case DioExceptionType.cancel:
        return const ServerFailure("Request was cancelled.");
      case DioExceptionType.connectionError:
        return const NetworkFailure("No internet connection.");
      default:
        return const ServerFailure("Something went wrong. Please try again.");
    }
  }

  static Failure _handleBadResponse(Response? response) {
    if (response == null) return const ServerFailure("Unknown error occurred.");

    final statusCode = response.statusCode;
    final data = response.data;

    String message = "Unexpected error: $statusCode";

    if (statusCode == 400) {
      if (data is Map && data.containsKey('message')) {
        message = data['message'].toString();
      } else {
        message = "Validation error. Please check your inputs.";
      }
    } else if (statusCode == 401) {
      message = "Invalid credentials. Please check your email and password.";
    } else if (statusCode == 403) {
      message = "You do not have permission to access this.";
    } else if (statusCode == 404) {
      message = "Resource not found.";
    } else if (statusCode == 500) {
      message = "Internal server error. Please try again later.";
    }

    return ServerFailure(message);
  }
}
