import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../models/history_models.dart';

class HistoryRepo {
  final Dio _dio;
  HistoryRepo(ApiClient api) : _dio = api.dio;

  Future<List<HistoryItem>> myHistory() async {
    final res = await _dio.get('/me/history');
    final data = res.data;
    final list = data is List
        ? data
        : ((data as Map<String, dynamic>)['items'] ??
            (data as Map<String, dynamic>)['history'] ??
            []);
    return list.cast<Map<String, dynamic>>().map(HistoryItem.fromJson).toList();
  }
}
