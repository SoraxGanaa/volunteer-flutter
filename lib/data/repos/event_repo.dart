import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../../features/events/data/models/event_models.dart';

class EventRepo {
  final Dio _dio;
  EventRepo(ApiClient api) : _dio = api.dio;

  Future<List<EventSummary>> getAllEvents() async {
    final res = await _dio.get('/events');
    final parsed = EventsResponse.fromJson(res.data as Map<String, dynamic>);
    return parsed.events;
  }

  // дараа нь ORG_ADMIN-ын “my events” endpoint гарвал энд нэмнэ
  // Future<List<EventSummary>> getMyEvents() ...
}
