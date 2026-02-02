import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../models/event_models.dart';

class EventRepo {
  final Dio _dio;
  EventRepo(ApiClient api) : _dio = api.dio;

  Future<List<EventSummary>> publicEvents({
    String? city,
    String? q,
    String? orgId,
  }) async {
    final res = await _dio.get(
      '/events',
      queryParameters: {
        if (city != null && city.isNotEmpty) 'city': city,
        if (q != null && q.isNotEmpty) 'q': q,
        if (orgId != null && orgId.isNotEmpty) 'orgId': orgId,
      },
    );
    return EventsResponse.fromJson(res.data as Map<String, dynamic>).events;
  }

  Future<List<EventSummary>> orgEvents(String orgId) async {
    final res = await _dio.get('/orgs/$orgId/events');
    // ихэвчлэн {events:[...]} гэж үзсэн
    return EventsResponse.fromJson(res.data as Map<String, dynamic>).events;
  }
}
