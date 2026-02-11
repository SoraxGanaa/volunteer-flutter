enum UserRole { SUPERADMIN, ORG_ADMIN, ORG_STAFF, USER }

UserRole userRoleFromString(String value) {
  switch (value) {
    case 'SUPERADMIN':
      return UserRole.SUPERADMIN;
    case 'ORG_ADMIN':
      return UserRole.ORG_ADMIN;
    case 'ORG_STAFF':
      return UserRole.ORG_STAFF;
    case 'USER':
      return UserRole.USER;
    default:
      return UserRole.USER;
  }
}

class LoginRequest {
  final String identifier;
  final String password;

  LoginRequest({required this.identifier, required this.password});

  Map<String, dynamic> toJson() => {
        'identifier': identifier,
        'password': password,
      };
}

class AuthUser {
  final String id;
  final UserRole role;
  final String email;
  final String? phone;
  final String? firstName;
  final String? lastName;

  AuthUser({
    required this.id,
    required this.role,
    required this.email,
    this.phone,
    this.firstName,
    this.lastName,
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    final roleRaw = json['role'];
    final roleValue = roleRaw is Map<String, dynamic>
        ? (roleRaw['name']?.toString() ?? 'USER')
        : (roleRaw?.toString() ?? (json['role_name']?.toString() ?? 'USER'));
    return AuthUser(
      id: json['id'].toString(),
      role: userRoleFromString(roleValue),
      email: (json['email'] as String?) ?? '',
      phone: json['phone'] as String?,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
    );
  }
}

class RegisterRequest {
  final String? email;
  final String? phone;
  final String password;
  final String? firstName;
  final String? lastName;

  RegisterRequest({
    this.email,
    this.phone,
    required this.password,
    this.firstName,
    this.lastName,
  });

  Map<String, dynamic> toJson() => {
        if (email != null && email!.isNotEmpty) 'email': email,
        if (phone != null && phone!.isNotEmpty) 'phone': phone,
        'password': password,
        if (firstName != null && firstName!.isNotEmpty) 'firstName': firstName,
        if (lastName != null && lastName!.isNotEmpty) 'lastName': lastName,
      };
}

class LoginResponse {
  final AuthUser user;
  final String accessToken;

  LoginResponse({required this.user, required this.accessToken});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      user: AuthUser.fromJson(json['user'] as Map<String, dynamic>),
      accessToken: (json['accessToken'] ?? json['access_token']) as String,
    );
  }
}
