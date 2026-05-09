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
      return ErrorHandler(const ServerFailure("حدث خطأ غير متوقع."));
    }
  }

  static Failure _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkFailure("انتهت مهلة الاتصال. يرجى المحاولة مرة أخرى.");
      case DioExceptionType.badResponse:
        return _handleBadResponse(error.response);
      case DioExceptionType.cancel:
        return const ServerFailure("تم إلغاء الطلب.");
      case DioExceptionType.connectionError:
        return const NetworkFailure("لا يوجد اتصال بالإنترنت.");
      default:
        return const ServerFailure("حدث خطأ ما. يرجى المحاولة مرة أخرى.");
    }
  }

  static Failure _handleBadResponse(Response? response) {
    if (response == null) return const ServerFailure("حدث خطأ غير معروف.");

    final statusCode = response.statusCode;
    final data = response.data;

    String message = "خطأ غير متوقع: $statusCode";

    if (statusCode == 400) {
      if (data is Map && data.containsKey('message')) {
        message = data['message'].toString();
      } else {
        message = "خطأ في البيانات. يرجى التحقق من المدخلات.";
      }
    } else if (statusCode == 401) {
      message = "بيانات الاعتماد غير صالحة. يرجى التحقق من البريد الإلكتروني وكلمة المرور.";
    } else if (statusCode == 403) {
      message = "ليس لديك صلاحية للوصول إلى هذا المورد.";
    } else if (statusCode == 404) {
      message = "المورد غير موجود.";
    } else if (statusCode == 500) {
      message = "خطأ داخلي في الخادم. يرجى المحاولة لاحقاً.";
    }

    return ServerFailure(message);
  }
}
