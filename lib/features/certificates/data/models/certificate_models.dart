class Certificate {
  final String id;
  final String title;
  final String? issuer;
  final DateTime? issuedAt;
  final String? fileUrl;

  Certificate({
    required this.id,
    required this.title,
    required this.issuer,
    required this.issuedAt,
    required this.fileUrl,
  });

  factory Certificate.fromJson(Map<String, dynamic> json) {
    return Certificate(
      id: json['id'].toString(),
      title: (json['title'] as String?) ?? '',
      issuer: json['issuer'] as String?,
      issuedAt: json['issued_at'] != null
          ? DateTime.parse(json['issued_at'] as String)
          : null,
      fileUrl: (json['file_url'] ?? json['fileUrl']) as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        if (issuer != null && issuer!.isNotEmpty) 'issuer': issuer,
        if (issuedAt != null) 'issuedAt': issuedAt!.toIso8601String(),
        if (fileUrl != null && fileUrl!.isNotEmpty) 'fileUrl': fileUrl,
      };
}
