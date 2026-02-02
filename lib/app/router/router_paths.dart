class RoutePaths {
  static const login = '/login';
  static const events = '/events';

  static const adminOrgs = '/admin/orgs';
  static String adminOrgEvents(String orgId) => '/admin/orgs/$orgId/events';
}
