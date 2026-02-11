import '../../../attendance/data/models/attendance_models.dart';

class HistoryItem {
  final String eventTitle;
  final String orgName;
  final DateTime startAt;
  final AttendanceStatus attendanceStatus;

  HistoryItem({
    required this.eventTitle,
    required this.orgName,
    required this.startAt,
    required this.attendanceStatus,
  });

  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    return HistoryItem(
      eventTitle: ((json['event_title'] ?? json['title']) as String?) ?? '',
      orgName: ((json['org_name'] ?? json['orgName']) as String?) ?? '',
      startAt: DateTime.parse((json['start_at'] ?? json['startAt']) as String),
      attendanceStatus:
          attendanceStatusFromString((json['attendance_status'] as String?) ?? 'ABSENT'),
    );
  }
}
