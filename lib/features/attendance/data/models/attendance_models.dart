enum AttendanceStatus { PRESENT, ABSENT, LATE, EXCUSED }

AttendanceStatus attendanceStatusFromString(String value) {
  switch (value) {
    case 'PRESENT':
      return AttendanceStatus.PRESENT;
    case 'ABSENT':
      return AttendanceStatus.ABSENT;
    case 'LATE':
      return AttendanceStatus.LATE;
    case 'EXCUSED':
      return AttendanceStatus.EXCUSED;
    default:
      return AttendanceStatus.ABSENT;
  }
}

class AttendanceRow {
  final String userId;
  final String userName;
  final AttendanceStatus status;
  final DateTime? checkInAt;
  final String? note;

  AttendanceRow({
    required this.userId,
    required this.userName,
    required this.status,
    required this.checkInAt,
    required this.note,
  });

  factory AttendanceRow.fromJson(Map<String, dynamic> json) {
    return AttendanceRow(
      userId: json['user_id']?.toString() ?? '',
      userName: ((json['user_name'] ?? json['userName']) as String?) ?? '',
      status: attendanceStatusFromString((json['status'] as String?) ?? 'ABSENT'),
      checkInAt: json['check_in_at'] != null
          ? DateTime.parse(json['check_in_at'] as String)
          : null,
      note: json['note'] as String?,
    );
  }
}
