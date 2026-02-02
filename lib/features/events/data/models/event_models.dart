enum EventStatus { DRAFT, PUBLISHED, CANCELLED, COMPLETED }

EventStatus eventStatusFromString(String value) {
  switch (value) {
    case 'DRAFT':
      return EventStatus.DRAFT;
    case 'PUBLISHED':
      return EventStatus.PUBLISHED;
    case 'CANCELLED':
      return EventStatus.CANCELLED;
    case 'COMPLETED':
      return EventStatus.COMPLETED;
    default:
      return EventStatus.PUBLISHED;
  }
}

class EventSummary {
  final String id;
  final String title;
  final String city;
  final DateTime startAt;
  final DateTime endAt;
  final int capacity;
  final EventStatus status;
  final String orgName;

  EventSummary({
    required this.id,
    required this.title,
    required this.city,
    required this.startAt,
    required this.endAt,
    required this.capacity,
    required this.status,
    required this.orgName,
  });

  factory EventSummary.fromJson(Map<String, dynamic> json) {
    return EventSummary(
      id: json['id'].toString(),
      title: (json['title'] as String?) ?? '',
      city: (json['city'] as String?) ?? '',
      startAt: DateTime.parse(json['start_at'] as String),
      endAt: DateTime.parse(json['end_at'] as String),
      capacity: (json['capacity'] as num).toInt(),
      status: eventStatusFromString(json['status'] as String),
      orgName: (json['org_name'] as String?) ?? '',
    );
  }
}

class EventsResponse {
  final List<EventSummary> events;
  EventsResponse({required this.events});

  factory EventsResponse.fromJson(Map<String, dynamic> json) {
    final list = (json['events'] as List).cast<Map<String, dynamic>>();
    return EventsResponse(events: list.map(EventSummary.fromJson).toList());
  }
}
