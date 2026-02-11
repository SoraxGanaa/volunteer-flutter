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
      startAt: DateTime.parse((json['start_at'] ?? json['startAt']) as String),
      endAt: DateTime.parse((json['end_at'] ?? json['endAt']) as String),
      capacity: (json['capacity'] as num).toInt(),
      status: eventStatusFromString((json['status'] as String?) ?? 'PUBLISHED'),
      orgName: ((json['org_name'] ?? json['orgName']) as String?) ?? '',
    );
  }
}

class EventsResponse {
  final List<EventSummary> events;
  EventsResponse({required this.events});

  factory EventsResponse.fromJson(Map<String, dynamic> json) {
    final raw = (json['events'] ?? json['items'] ?? []) as List;
    final list = raw.cast<Map<String, dynamic>>();
    return EventsResponse(events: list.map(EventSummary.fromJson).toList());
  }
}

class EventDetail {
  final String id;
  final String title;
  final String description;
  final String category;
  final String city;
  final String address;
  final DateTime startAt;
  final DateTime endAt;
  final int capacity;
  final String? bannerUrl;
  final EventStatus status;
  final String orgId;
  final String orgName;

  EventDetail({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.city,
    required this.address,
    required this.startAt,
    required this.endAt,
    required this.capacity,
    required this.bannerUrl,
    required this.status,
    required this.orgId,
    required this.orgName,
  });

  factory EventDetail.fromJson(Map<String, dynamic> json) {
    return EventDetail(
      id: json['id'].toString(),
      title: (json['title'] as String?) ?? '',
      description: (json['description'] as String?) ?? '',
      category: (json['category'] as String?) ?? '',
      city: (json['city'] as String?) ?? '',
      address: (json['address'] as String?) ?? '',
      startAt: DateTime.parse((json['start_at'] ?? json['startAt']) as String),
      endAt: DateTime.parse((json['end_at'] ?? json['endAt']) as String),
      capacity: (json['capacity'] as num).toInt(),
      bannerUrl: (json['banner_url'] ?? json['bannerUrl']) as String?,
      status: eventStatusFromString((json['status'] as String?) ?? 'PUBLISHED'),
      orgId: json['org_id']?.toString() ?? '',
      orgName: ((json['org_name'] ?? json['orgName']) as String?) ?? '',
    );
  }
}

class ApplyRequest {
  final String? message;
  ApplyRequest({this.message});

  Map<String, dynamic> toJson() => {
        if (message != null && message!.isNotEmpty) 'message': message,
      };
}
