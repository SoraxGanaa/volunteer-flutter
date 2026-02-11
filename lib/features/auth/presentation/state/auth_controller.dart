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

final unauthorizedTickProvider = StateProvider<int>((ref) => 0);

final apiClientProvider =
    Provider((ref) => ApiClient(
          tokenStorage: ref.watch(tokenStorageProvider),
          onUnauthorized: () {
            final notifier = ref.read(unauthorizedTickProvider.notifier);
            notifier.state = notifier.state + 1;
          },
        ));

final authRepoProvider = Provider(
  (ref) => AuthRepo(ref.watch(apiClientProvider), ref.watch(tokenStorageProvider)),
);

final authControllerProvider =
    NotifierProvider<AuthController, AuthState>(AuthController.new);

class AuthController extends Notifier<AuthState> {
  @override
  AuthState build() {
    ref.listen<int>(unauthorizedTickProvider, (prev, next) {
      if (prev == null || next > prev) {
        logout();
      }
    });
    return const AuthState();
  }

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

  Future<void> register({
    String? email,
    String? phone,
    required String password,
    String? firstName,
    String? lastName,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final user = await ref.read(authRepoProvider).register(
            RegisterRequest(
              email: email,
              phone: phone,
              password: password,
              firstName: firstName,
              lastName: lastName,
            ),
          );
      state = state.copyWith(user: user, isLoading: false);
    } catch (_) {
      state = state.copyWith(isLoading: false, error: 'Register failed');
    }
  }

  Future<void> logout() async {
    await ref.read(authRepoProvider).logout();
    state = const AuthState();
  }
}
