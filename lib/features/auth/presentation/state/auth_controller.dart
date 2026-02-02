import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/storage/token_storage.dart';
import '../../data/models/auth_models.dart';
import '../../data/repos/auth_repo.dart';

class AuthState {
  final AuthUser? user;
  final bool isLoading;
  final String? error;

  const AuthState({this.user, this.isLoading = false, this.error});

  AuthState copyWith({
    AuthUser? user,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

// global providers (DI)
final secureStorageProvider = Provider((ref) => const FlutterSecureStorage());
final tokenStorageProvider =
    Provider((ref) => TokenStorage(ref.watch(secureStorageProvider)));

final apiClientProvider =
    Provider((ref) => ApiClient(tokenStorage: ref.watch(tokenStorageProvider)));

final authRepoProvider = Provider(
  (ref) => AuthRepo(ref.watch(apiClientProvider), ref.watch(tokenStorageProvider)),
);

final authControllerProvider =
    NotifierProvider<AuthController, AuthState>(AuthController.new);

class AuthController extends Notifier<AuthState> {
  @override
  AuthState build() => const AuthState();

  Future<void> bootstrap() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final me = await ref.read(authRepoProvider).me();
      state = state.copyWith(user: me, isLoading: false);
    } catch (_) {
      state = state.copyWith(user: null, isLoading: false);
    }
  }

  Future<void> login(String identifier, String password) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final resp = await ref
          .read(authRepoProvider)
          .login(LoginRequest(identifier: identifier, password: password));
      state = state.copyWith(user: resp.user, isLoading: false);
    } catch (_) {
      state = state.copyWith(isLoading: false, error: 'Login failed');
    }
  }

  Future<void> logout() async {
    await ref.read(authRepoProvider).logout();
    state = const AuthState();
  }
}
