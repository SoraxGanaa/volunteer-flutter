import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static const _accessTokenKey = 'access_token';

  final FlutterSecureStorage _storage;
  TokenStorage(this._storage);

  Future<void> saveToken(String token) =>
      _storage.write(key: _accessTokenKey, value: token);

  Future<String?> readToken() => _storage.read(key: _accessTokenKey);

  Future<void> clearToken() => _storage.delete(key: _accessTokenKey);
}
