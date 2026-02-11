import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../models/application_models.dart';

class ApplicationsRepo {
  final Dio _dio;
  ApplicationsRepo(ApiClient api) : _dio = api.dio;

  Future<List<EventApplication>> myApplications() async {
    final res = await _dio.get('/me/applications');
    final data = res.data;
    final list = data is List
        ? data
        : ((data as Map<String, dynamic>)['items'] ??
            (data as Map<String, dynamic>)['applications'] ??
            []);
    return list.cast<Map<String, dynamic>>().map(EventApplication.fromJson).toList();
  }

  Future<List<EventApplication>> eventApplications(String eventId, {String? status}) async {
    final res = await _dio.get(
      '/events/$eventId/applications',
      queryParameters: {
        if (status != null && status.isNotEmpty) 'status': status,
      },
    );
    final data = res.data;
    final list = data is List
        ? data
        : ((data as Map<String, dynamic>)['items'] ??
            (data as Map<String, dynamic>)['applications'] ??
            []);
    return list.cast<Map<String, dynamic>>().map(EventApplication.fromJson).toList();
  }
}
