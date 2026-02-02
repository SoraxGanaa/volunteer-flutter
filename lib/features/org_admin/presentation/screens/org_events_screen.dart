import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../events/data/repos/event_repo.dart';
import '../../../events/data/models/event_models.dart';
import '../../../events/presentation/widgets/event_card.dart';
import '../../../auth/presentation/state/auth_controller.dart';

final orgEventsProvider = FutureProvider.family<List<EventSummary>, String>((ref, orgId) async {
  final repo = EventRepo(ref.watch(apiClientProvider));
  return repo.orgEvents(orgId);
});

class OrgEventsScreen extends ConsumerWidget {
  final String orgId;
  const OrgEventsScreen({super.key, required this.orgId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(orgEventsProvider(orgId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Миний эвентүүд'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authControllerProvider.notifier).logout(),
          ),
        ],
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (events) {
          if (events.isEmpty) return const Center(child: Text('Event байхгүй'));
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: events.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, i) {
              final ev = events[i];
              return EventCard(
                ev: ev,
                onPrimary: () {
                  // next: publish/cancel/complete actions
                },
              );
            },
          );
        },
      ),
    );
  }
}
