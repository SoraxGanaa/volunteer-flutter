import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../../features/events/data/models/event_models.dart';

class EventRepo {
  final Dio _dio;
  EventRepo(ApiClient api) : _dio = api.dio;

  Future<List<EventSummary>> orgEvents(String orgId) async {
  final res = await _dio.get('/orgs/$orgId/events');
  final data = res.data as Map<String, dynamic>;
  final list = (data['events'] as List).cast<Map<String, dynamic>>();
  return list.map(EventSummary.fromJson).toList();
}


  // дараа нь ORG_ADMIN-ын “my events” endpoint гарвал энд нэмнэ
  // Future<List<EventSummary>> getMyEvents() ...
}
