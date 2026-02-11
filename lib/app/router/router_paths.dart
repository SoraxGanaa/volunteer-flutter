class RoutePaths {
  static const login = '/login';
  static const register = '/register';
  static const profile = '/profile';
  static const events = '/events';
  static String eventDetail(String id) => '/events/$id';
  static const myApplications = '/me/applications';
  static const myCertificates = '/me/certificates';
  static const myHistory = '/me/history';

  static const adminOrgs = '/admin/orgs';
  static String adminOrgEvents(String orgId) => '/admin/orgs/$orgId/events';
  static const adminPendingOrgs = '/admin/pending-orgs';

  static const staffHome = '/staff';
  static String staffApplications(String eventId) => '/staff/events/$eventId/applications';
  static String staffAttendance(String eventId) => '/staff/events/$eventId/attendance';
}
