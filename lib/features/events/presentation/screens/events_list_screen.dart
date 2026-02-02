import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../auth/presentation/state/auth_controller.dart';
import '../state/events_controller.dart';
import '../../data/models/event_models.dart';

class EventsListScreen extends ConsumerStatefulWidget {
  const EventsListScreen({super.key});

  @override
  ConsumerState<EventsListScreen> createState() => _EventsListScreenState();
}

class _EventsListScreenState extends ConsumerState<EventsListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(eventsControllerProvider.notifier).load());
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authControllerProvider);
    final eventsState = ref.watch(eventsControllerProvider);

    final dateFmt = DateFormat('yyyy-MM-dd');
    final timeFmt = DateFormat('HH:mm');

    return Scaffold(
      appBar: AppBar(
        title: Text(auth.user?.role.name == 'ORG_ADMIN' ? 'My Events' : 'Events'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(eventsControllerProvider.notifier).load(),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authControllerProvider.notifier).logout(),
          ),
        ],
      ),
      body: eventsState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (events) {
          if (events.isEmpty) return const Center(child: Text('No events'));

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: events.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, i) {
              final ev = events[i];
              final dateText = dateFmt.format(ev.startAt);
              final timeText = '${timeFmt.format(ev.startAt)} - ${timeFmt.format(ev.endAt)}';

              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(ev.orgName, style: const TextStyle(fontWeight: FontWeight.w600)),
                          ),
                          Text(ev.status.name, style: const TextStyle(fontSize: 12)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(ev.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 18),
                          const SizedBox(width: 8),
                          Text(dateText),
                          const SizedBox(width: 14),
                          const Icon(Icons.access_time, size: 18),
                          const SizedBox(width: 8),
                          Text(timeText),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 18),
                          const SizedBox(width: 8),
                          Expanded(child: Text(ev.city)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(Icons.people, size: 18),
                          const SizedBox(width: 8),
                          Text('Capacity: ${ev.capacity}'),
                          const Spacer(),
                          ElevatedButton(
                            onPressed: () {},
                            child: const Text('View'),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
