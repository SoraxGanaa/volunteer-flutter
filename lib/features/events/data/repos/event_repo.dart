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
    return EventsResponse.fromJson(res.data as Map<String, dynamic>).events;
  }

  Future<EventDetail> eventDetail(String id) async {
    final res = await _dio.get('/events/$id');
    return EventDetail.fromJson(res.data as Map<String, dynamic>);
  }

  Future<void> applyToEvent(String eventId, {String? message}) async {
    await _dio.post('/events/$eventId/apply', data: ApplyRequest(message: message).toJson());
  }

  Future<void> cancelMyApply(String eventId) async {
    await _dio.delete('/events/$eventId/apply');
  }

  Future<void> createEvent(String orgId, EventDetail req) async {
    await _dio.post('/orgs/$orgId/events', data: {
      'title': req.title,
      'description': req.description,
      'category': req.category,
      'city': req.city,
      'address': req.address,
      'startAt': req.startAt.toIso8601String(),
      'endAt': req.endAt.toIso8601String(),
      'capacity': req.capacity,
      if (req.bannerUrl != null && req.bannerUrl!.isNotEmpty) 'bannerUrl': req.bannerUrl,
    });
  }

  Future<void> publishEvent(String id) async => _dio.post('/events/$id/publish');
  Future<void> cancelEvent(String id) async => _dio.post('/events/$id/cancel');
  Future<void> completeEvent(String id) async => _dio.post('/events/$id/complete');
}