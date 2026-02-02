import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/state/auth_controller.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/events/presentation/screens/events_list_screen.dart';
import '../../features/org_admin/presentation/screens/my_org_screen.dart';
import '../../features/org_admin/presentation/screens/org_events_screen.dart';
import 'router_paths.dart';

String homeForRole(String role) {
  switch (role) {
    case 'ORG_ADMIN':
      return RoutePaths.adminOrgs;
    case 'USER':
      return RoutePaths.events;
    default:
      return RoutePaths.login;
  }
}

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authControllerProvider);

  return GoRouter(
    initialLocation: RoutePaths.events,
    redirect: (context, state) {
      final loggedIn = authState.user != null;
      final roleName = authState.user?.role.name;
      final goingLogin = state.matchedLocation == RoutePaths.login;

      if (!loggedIn && !goingLogin) return RoutePaths.login;
      if (loggedIn && goingLogin) return homeForRole(roleName!);

      // SUPERADMIN app-д хэрэггүй
      if (loggedIn && roleName == 'SUPERADMIN') return RoutePaths.login;

      if (loggedIn && state.matchedLocation == '/') return homeForRole(roleName!);

      // USER admin руу оруулахгүй
      if (loggedIn && roleName == 'USER' && state.matchedLocation.startsWith('/admin')) {
        return RoutePaths.events;
      }

      return null;
    },
    routes: [
      GoRoute(path: RoutePaths.login, builder: (_, __) => const LoginScreen()),
      GoRoute(path: RoutePaths.events, builder: (_, __) => const EventsListScreen()),

      // ORG_ADMIN
      GoRoute(path: RoutePaths.adminOrgs, builder: (_, __) => const MyOrgsScreen()),
      GoRoute(
        path: '/admin/orgs/:orgId/events',
        builder: (_, state) {
          final orgId = state.pathParameters['orgId']!;
          return OrgEventsScreen(orgId: orgId);
        },
      ),
    ],
  );
});
