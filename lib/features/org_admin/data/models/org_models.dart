class OrgSummary {
  final String id;
  final String name;
  final String status;

  OrgSummary({required this.id, required this.name, required this.status});

  factory OrgSummary.fromJson(Map<String, dynamic> json) {
    return OrgSummary(
      id: json['id'].toString(),
      name: (json['name'] as String?) ?? '',
      status: (json['status'] as String?) ?? '',
    );
  }
}

class MyOrgsResponse {
  final List<OrgSummary> orgs;
  MyOrgsResponse({required this.orgs});

  factory MyOrgsResponse.fromJson(dynamic data) {
    final map = data as Map<String, dynamic>;
    final raw = (map['orgs'] ?? map['items'] ?? []) as List;
    final list = raw.cast<Map<String, dynamic>>();
    return MyOrgsResponse(orgs: list.map(OrgSummary.fromJson).toList());
  }
}

class CreateOrgRequest {
  final String name;
  final String? description;

  CreateOrgRequest({required this.name, this.description});

  Map<String, dynamic> toJson() => {
        'name': name,
        if (description != null && description!.isNotEmpty) 'description': description,
      };
}
