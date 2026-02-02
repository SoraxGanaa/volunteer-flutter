enum UserRole { SUPERADMIN, ORG_ADMIN, USER }

UserRole userRoleFromString(String value) {
  switch (value) {
    case 'SUPERADMIN':
      return UserRole.SUPERADMIN;
    case 'ORG_ADMIN':
      return UserRole.ORG_ADMIN;
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

  AuthUser({
    required this.id,
    required this.role,
    required this.email,
    this.phone,
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: json['id'].toString(),
      role: userRoleFromString(json['role'] as String),
      email: (json['email'] as String?) ?? '',
      phone: json['phone'] as String?,
    );
  }
}

class LoginResponse {
  final AuthUser user;
  final String accessToken;

  LoginResponse({required this.user, required this.accessToken});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      user: AuthUser.fromJson(json['user'] as Map<String, dynamic>),
      accessToken: json['accessToken'] as String,
    );
  }
}
