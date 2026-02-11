enum ApplicationStatus { PENDING, APPROVED, REJECTED, CANCELLED }

ApplicationStatus applicationStatusFromString(String value) {
  switch (value) {
    case 'APPROVED':
      return ApplicationStatus.APPROVED;
    case 'REJECTED':
      return ApplicationStatus.REJECTED;
    case 'CANCELLED':
      return ApplicationStatus.CANCELLED;
    case 'PENDING':
    default:
      return ApplicationStatus.PENDING;
  }
}

class EventApplication {
  final String id;
  final String eventId;
  final String eventTitle;
  final String orgName;
  final String? message;
  final ApplicationStatus status;

  EventApplication({
    required this.id,
    required this.eventId,
    required this.eventTitle,
    required this.orgName,
    required this.message,
    required this.status,
  });

  factory EventApplication.fromJson(Map<String, dynamic> json) {
    return EventApplication(
      id: json['id'].toString(),
      eventId: json['event_id']?.toString() ?? '',
      eventTitle: ((json['event_title'] ?? json['title']) as String?) ?? '',
      orgName: ((json['org_name'] ?? json['orgName']) as String?) ?? '',
      message: json['message'] as String?,
      status: applicationStatusFromString((json['status'] as String?) ?? 'PENDING'),
    );
  }
}
