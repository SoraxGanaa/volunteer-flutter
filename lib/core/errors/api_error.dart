import 'package:dio/dio.dart';

class ApiError {
  final int? statusCode;
  final String message;

  ApiError({required this.statusCode, required this.message});

  static ApiError from(Object error) {
    if (error is DioException) {
      final status = error.response?.statusCode;
      final data = error.response?.data;
      String msg = error.message ?? 'Request failed';
      if (data is Map<String, dynamic> && data['message'] is String) {
        msg = data['message'] as String;
      }
      return ApiError(statusCode: status, message: msg);
    }
    return ApiError(statusCode: null, message: error.toString());
  }
}
