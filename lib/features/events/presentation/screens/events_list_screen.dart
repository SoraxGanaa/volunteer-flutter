import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/router_paths.dart';
import '../../../auth/presentation/state/auth_controller.dart';
import '../state/events_controller.dart';
import '../widgets/event_card.dart';
import '../../../../core/utils/api_error_ui.dart';

class EventsListScreen extends ConsumerStatefulWidget {
  const EventsListScreen({super.key});

  @override
  ConsumerState<EventsListScreen> createState() => _EventsListScreenState();
}

class _EventsListScreenState extends ConsumerState<EventsListScreen> {
  final cityCtrl = TextEditingController();
  final qCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(eventsControllerProvider.notifier).load());
  }

  @override
  void dispose() {
    cityCtrl.dispose();
    qCtrl.dispose();
    super.dispose();
  }

  void _load() {
    ref.read(eventsControllerProvider.notifier).load(
          city: cityCtrl.text.trim(),
          q: qCtrl.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authControllerProvider);
    final eventsState = ref.watch(eventsControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Арга хэмжээ'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _load,
          ),
          if (auth.user != null)
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'profile') {
                  context.push(RoutePaths.profile);
                } else if (value == 'applications') {
                  context.push(RoutePaths.myApplications);
                } else if (value == 'certificates') {
                  context.push(RoutePaths.myCertificates);
                } else if (value == 'history') {
                  context.push(RoutePaths.myHistory);
                } else if (value == 'logout') {
                  ref.read(authControllerProvider.notifier).logout();
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'profile', child: Text('Profile')),
                if (auth.user?.role.name == 'USER')
                  const PopupMenuItem(value: 'applications', child: Text('My applications')),
                if (auth.user?.role.name == 'USER')
                  const PopupMenuItem(value: 'certificates', child: Text('My certificates')),
                if (auth.user?.role.name == 'USER')
                  const PopupMenuItem(value: 'history', child: Text('My history')),
                const PopupMenuItem(value: 'logout', child: Text('Logout')),
              ],
            ),
        ],
      ),
      body: eventsState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) {
          final msg = handleApiError(
            context,
            e,
            onUnauthorized: () => ref.read(authControllerProvider.notifier).logout(),
          );
          return Center(child: Text(msg));
        },
        data: (events) {
          if (events.isEmpty) return const Center(child: Text('Event алга'));

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: events.length + 1,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, i) {
              if (i == 0) {
                return Column(
                  children: [
                    TextField(
                      controller: qCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Search',
                        prefixIcon: Icon(Icons.search),
                      ),
                      onSubmitted: (_) => _load(),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: cityCtrl,
                      decoration: const InputDecoration(
                        labelText: 'City',
                        prefixIcon: Icon(Icons.location_on),
                      ),
                      onSubmitted: (_) => _load(),
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: _load,
                        child: const Text('Filter'),
                      ),
                    ),
                  ],
                );
              }

              final ev = events[i - 1];

              return EventCard(
                ev: ev,
                onTap: () => context.push(RoutePaths.eventDetail(ev.id)),
                onPrimary: () => context.push(RoutePaths.eventDetail(ev.id)),
                primaryText: auth.user?.role.name == 'USER' ? 'Бүртгүүлэх  >' : 'Дэлгэрэнгүй  >',
              );
            },
          );
        },
      ),
    );
  }
}
