import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../models/attendance_models.dart';

class AttendanceRepo {
  final Dio _dio;
  AttendanceRepo(ApiClient api) : _dio = api.dio;

  Future<List<AttendanceRow>> listAttendance(String eventId) async {
    final res = await _dio.get('/events/$eventId/attendance');
    final data = res.data;
    final list = data is List
        ? data
        : ((data as Map<String, dynamic>)['items'] ??
            (data as Map<String, dynamic>)['attendance'] ??
            []);
    return list.cast<Map<String, dynamic>>().map(AttendanceRow.fromJson).toList();
  }

  Future<void> markAttendance(
    String eventId,
    String userId, {
    required AttendanceStatus status,
    DateTime? checkInAt,
    String? note,
  }) async {
    await _dio.put(
      '/events/$eventId/attendance/$userId',
      data: {
        'status': status.name,
        if (checkInAt != null) 'checkInAt': checkInAt.toIso8601String(),
        if (note != null && note.isNotEmpty) 'note': note,
      },
    );
  }
}
