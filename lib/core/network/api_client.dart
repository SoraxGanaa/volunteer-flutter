import 'package:dio/dio.dart';
import '../../config/app_config.dart';
import '../storage/token_storage.dart';
import 'auth_interceptor.dart';

class ApiClient {
  late final Dio dio;

  ApiClient({required TokenStorage tokenStorage, void Function()? onUnauthorized}) {
    dio = Dio(BaseOptions(
      baseUrl: AppConfig.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 20),
      headers: {'Content-Type': 'application/json'},
    ));

    dio.interceptors.add(AuthInterceptor(tokenStorage));
    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (e, handler) async {
          if (e.response?.statusCode == 401) {
            await tokenStorage.clearToken();
            if (onUnauthorized != null) onUnauthorized();
          }
          handler.next(e);
        },
      ),
    );
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));
  }
}
