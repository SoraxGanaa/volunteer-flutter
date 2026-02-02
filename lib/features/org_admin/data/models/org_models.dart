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
    // backend чинь {orgs:[...]} эсвэл {items:[...]} байж магадгүй.
    // ихэнхдээ {orgs:[...]} гэж үзээд:
    final map = data as Map<String, dynamic>;
    final list = (map['orgs'] as List).cast<Map<String, dynamic>>();
    return MyOrgsResponse(orgs: list.map(OrgSummary.fromJson).toList());
  }
}
