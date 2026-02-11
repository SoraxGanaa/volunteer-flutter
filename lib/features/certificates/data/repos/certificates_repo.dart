import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../models/certificate_models.dart';

class CertificatesRepo {
  final Dio _dio;
  CertificatesRepo(ApiClient api) : _dio = api.dio;

  Future<List<Certificate>> list() async {
    final res = await _dio.get('/me/certificates');
    final data = res.data;
    final list = data is List
        ? data
        : ((data as Map<String, dynamic>)['items'] ??
            (data as Map<String, dynamic>)['certificates'] ??
            []);
    return list.cast<Map<String, dynamic>>().map(Certificate.fromJson).toList();
  }

  Future<void> create(Certificate cert) async {
    await _dio.post('/me/certificates', data: cert.toJson());
  }

  Future<void> update(Certificate cert) async {
    await _dio.patch('/me/certificates/${cert.id}', data: cert.toJson());
  }

  Future<void> delete(String id) async {
    await _dio.delete('/me/certificates/$id');
  }
}
