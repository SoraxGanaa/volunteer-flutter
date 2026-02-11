import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/state/auth_controller.dart';
import '../../data/repos/event_repo.dart';
import '../../data/models/event_models.dart';
import '../../../../core/utils/date_format.dart';
import '../../../../core/utils/api_error_ui.dart';

final _eventRepoProvider = Provider((ref) => EventRepo(ref.watch(apiClientProvider)));

final eventDetailProvider =
    FutureProvider.family<EventDetail, String>((ref, id) async {
  return ref.watch(_eventRepoProvider).eventDetail(id);
});

class EventDetailScreen extends ConsumerWidget {
  final String eventId;
  const EventDetailScreen({super.key, required this.eventId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(eventDetailProvider(eventId));
    final auth = ref.watch(authControllerProvider);
    final canApply = auth.user?.role.name == 'USER';

    return Scaffold(
      appBar: AppBar(title: const Text('Event detail')),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) {
          final msg = handleApiError(
            context,
            e,
            onUnauthorized: () => ref.read(authControllerProvider.notifier).logout(),
          );
          return Center(child: Text(msg));
        },
        data: (event) {
          final dateText = DateFormatUtil.date(event.startAt);
          final timeText = DateFormatUtil.timeRange(event.startAt, event.endAt);

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (event.bannerUrl != null && event.bannerUrl!.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    event.bannerUrl!,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              if (event.bannerUrl != null && event.bannerUrl!.isNotEmpty)
                const SizedBox(height: 12),
              Text(event.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              Text(event.orgName),
              const SizedBox(height: 8),
              Text('${event.city} • ${event.address}'),
              const SizedBox(height: 8),
              Text('$dateText • $timeText'),
              const SizedBox(height: 8),
              Text('Category: ${event.category}'),
              const SizedBox(height: 8),
              Text('Capacity: ${event.capacity}'),
              const SizedBox(height: 12),
              Text(event.description),
              const SizedBox(height: 16),
              if (canApply)
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await ref.read(_eventRepoProvider).applyToEvent(event.id);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Applied')),
                        );
                      }
                    } catch (e) {
                      final msg = handleApiError(
                        context,
                        e,
                        onUnauthorized: () => ref.read(authControllerProvider.notifier).logout(),
                      );
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(msg)),
                        );
                      }
                    }
                  },
                  child: const Text('Apply'),
                ),
            ],
          );
        },
      ),
    );
  }
}
