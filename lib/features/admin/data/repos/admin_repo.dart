import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../org_admin/data/models/org_models.dart';

class AdminRepo {
  final Dio _dio;
  AdminRepo(ApiClient api) : _dio = api.dio;

  Future<List<OrgSummary>> pendingOrgs() async {
    final res = await _dio.get('/admin/orgs/pending');
    final data = res.data;
    final list = data is List
        ? data
        : ((data as Map<String, dynamic>)['items'] ??
            (data as Map<String, dynamic>)['orgs'] ??
            []);
    return list.cast<Map<String, dynamic>>().map(OrgSummary.fromJson).toList();
  }

  Future<void> approveOrg(String id) async {
    await _dio.post('/admin/orgs/$id/approve');
  }

  Future<void> suspendOrg(String id) async {
    await _dio.post('/admin/orgs/$id/suspend');
  }
}
