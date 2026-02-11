import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/state/auth_controller.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/profile_screen.dart';
import '../../features/events/presentation/screens/events_list_screen.dart';
import '../../features/events/presentation/screens/event_detail_screen.dart';
import '../../features/events/presentation/screens/my_history_screen.dart';
import '../../features/applications/presentation/screens/my_applications_screen.dart';
import '../../features/certificates/presentation/screens/my_certificates_screen.dart';
import '../../features/org_admin/presentation/screens/my_org_screen.dart';
import '../../features/org_admin/presentation/screens/org_events_screen.dart';
import '../../features/applications/presentation/screens/event_applications_screen.dart';
import '../../features/attendance/presentation/screens/attendance_screen.dart';
import '../../features/attendance/presentation/screens/staff_home_screen.dart';
import '../../features/admin/presentation/screens/pending_orgs_screen.dart';
import 'router_paths.dart';

String homeForRole(String role) {
  switch (role) {
    case 'ORG_ADMIN':
      return RoutePaths.adminOrgs;
    case 'ORG_STAFF':
      return RoutePaths.staffHome;
    case 'SUPERADMIN':
      return RoutePaths.adminPendingOrgs;
    case 'USER':
    default:
      return RoutePaths.events;
  }
}

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authControllerProvider);

  return GoRouter(
    initialLocation: RoutePaths.events,
    redirect: (context, state) {
      final loggedIn = authState.user != null;
      final roleName = authState.user?.role.name;
      final location = state.matchedLocation;
      final goingLogin = location == RoutePaths.login;
      final goingRegister = location == RoutePaths.register;
      final publicRoutes = [
        RoutePaths.events,
        RoutePaths.login,
        RoutePaths.register,
      ];
      final isPublicEventDetail = location.startsWith('/events/');

      if (!loggedIn && !publicRoutes.contains(location) && !isPublicEventDetail) {
        return RoutePaths.login;
      }
      if (loggedIn && (goingLogin || goingRegister)) return homeForRole(roleName!);

      if (loggedIn && location == '/') return homeForRole(roleName!);

      if (loggedIn && roleName == 'USER' && location.startsWith('/admin')) {
        return RoutePaths.events;
      }

      if (loggedIn && roleName == 'ORG_ADMIN' && location.startsWith('/staff')) {
        return RoutePaths.adminOrgs;
      }

      if (loggedIn && roleName == 'SUPERADMIN' && !location.startsWith('/admin')) {
        return RoutePaths.adminPendingOrgs;
      }

      return null;
    },
    routes: [
      GoRoute(path: RoutePaths.login, builder: (_, __) => const LoginScreen()),
      GoRoute(path: RoutePaths.register, builder: (_, __) => const RegisterScreen()),
      GoRoute(path: RoutePaths.profile, builder: (_, __) => const ProfileScreen()),
      GoRoute(path: RoutePaths.events, builder: (_, __) => const EventsListScreen()),
      GoRoute(
        path: '/events/:id',
        builder: (_, state) {
          final id = state.pathParameters['id']!;
          return EventDetailScreen(eventId: id);
        },
      ),
      GoRoute(path: RoutePaths.myApplications, builder: (_, __) => const MyApplicationsScreen()),
      GoRoute(path: RoutePaths.myCertificates, builder: (_, __) => const MyCertificatesScreen()),
      GoRoute(path: RoutePaths.myHistory, builder: (_, __) => const MyHistoryScreen()),

      // ORG_ADMIN
      GoRoute(path: RoutePaths.adminOrgs, builder: (_, __) => const MyOrgsScreen()),
      GoRoute(
        path: '/admin/orgs/:orgId/events',
        builder: (_, state) {
          final orgId = state.pathParameters['orgId']!;
          return OrgEventsScreen(orgId: orgId);
        },
      ),

      // ORG_STAFF
      GoRoute(path: RoutePaths.staffHome, builder: (_, __) => const StaffHomeScreen()),
      GoRoute(
        path: '/staff/events/:eventId/applications',
        builder: (_, state) {
          final eventId = state.pathParameters['eventId']!;
          return EventApplicationsScreen(eventId: eventId);
        },
      ),
      GoRoute(
        path: '/staff/events/:eventId/attendance',
        builder: (_, state) {
          final eventId = state.pathParameters['eventId']!;
          return AttendanceScreen(eventId: eventId);
        },
      ),

      // SUPERADMIN
      GoRoute(path: RoutePaths.adminPendingOrgs, builder: (_, __) => const PendingOrgsScreen()),
    ],
  );
});
