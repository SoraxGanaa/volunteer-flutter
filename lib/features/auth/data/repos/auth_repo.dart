import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/storage/token_storage.dart';
import '../models/auth_models.dart';

class AuthRepo {
  final Dio _dio;
  final TokenStorage _tokenStorage;

  AuthRepo(ApiClient api, this._tokenStorage) : _dio = api.dio;

  Future<LoginResponse> login(LoginRequest req) async {
    final res = await _dio.post('/auth/login', data: req.toJson());
    final data = res.data as Map<String, dynamic>;
    final parsed = LoginResponse.fromJson(data);
    await _tokenStorage.saveToken(parsed.accessToken);
    return parsed;
  }

  Future<AuthUser> me() async {
    final res = await _dio.get('/auth/me');
    return AuthUser.fromJson(res.data as Map<String, dynamic>);
  }

  Future<AuthUser> register(RegisterRequest req) async {
    final res = await _dio.post('/auth/register', data: req.toJson());
    return AuthUser.fromJson(res.data as Map<String, dynamic>);
  }

  Future<void> logout() => _tokenStorage.clearToken();
}
