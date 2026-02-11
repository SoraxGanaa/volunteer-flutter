import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../models/org_models.dart';

class OrgRepo {
  final Dio _dio;
  OrgRepo(ApiClient api) : _dio = api.dio;

  Future<List<OrgSummary>> myOrgs() async {
    final res = await _dio.get('/orgs/my');
    return MyOrgsResponse.fromJson(res.data).orgs;
  }

  Future<void> createOrg(CreateOrgRequest req) async {
    await _dio.post('/orgs', data: req.toJson());
  }
}
