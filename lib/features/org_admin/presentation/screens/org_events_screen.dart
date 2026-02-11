import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../events/data/repos/event_repo.dart';
import '../../../events/data/models/event_models.dart';
import '../../../events/presentation/widgets/event_card.dart';
import '../../../auth/presentation/state/auth_controller.dart';
import '../../../../core/utils/api_error_ui.dart';

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
    final repo = EventRepo(ref.watch(apiClientProvider));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Миний эвентүүд'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(orgEventsProvider(orgId)),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authControllerProvider.notifier).logout(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final titleCtrl = TextEditingController();
          final descCtrl = TextEditingController();
          final categoryCtrl = TextEditingController();
          final cityCtrl = TextEditingController();
          final addressCtrl = TextEditingController();
          final capacityCtrl = TextEditingController();
          final bannerCtrl = TextEditingController();
          DateTime? startAt;
          DateTime? endAt;

          final created = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Эвент үүсгэх'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Title')),
                    TextField(controller: descCtrl, decoration: const InputDecoration(labelText: 'Description')),
                    TextField(controller: categoryCtrl, decoration: const InputDecoration(labelText: 'Category')),
                    TextField(controller: cityCtrl, decoration: const InputDecoration(labelText: 'City')),
                    TextField(controller: addressCtrl, decoration: const InputDecoration(labelText: 'Address')),
                    TextField(
                      controller: capacityCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Capacity'),
                    ),
                    TextField(controller: bannerCtrl, decoration: const InputDecoration(labelText: 'Banner URL')),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030),
                        );
                        final time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                        if (date != null && time != null) {
                          startAt = DateTime(date.year, date.month, date.day, time.hour, time.minute);
                        }
                      },
                      child: const Text('Pick start time'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030),
                        );
                        final time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                        if (date != null && time != null) {
                          endAt = DateTime(date.year, date.month, date.day, time.hour, time.minute);
                        }
                      },
                      child: const Text('Pick end time'),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Create')),
              ],
            ),
          );

          if (created == true && startAt != null && endAt != null) {
            final req = EventDetail(
              id: '0',
              title: titleCtrl.text.trim(),
              description: descCtrl.text.trim(),
              category: categoryCtrl.text.trim(),
              city: cityCtrl.text.trim(),
              address: addressCtrl.text.trim(),
              startAt: startAt!,
              endAt: endAt!,
              capacity: int.tryParse(capacityCtrl.text.trim()) ?? 0,
              bannerUrl: bannerCtrl.text.trim().isEmpty ? null : bannerCtrl.text.trim(),
              status: EventStatus.DRAFT,
              orgId: orgId,
              orgName: '',
            );
            await repo.createEvent(orgId, req);
            ref.invalidate(orgEventsProvider(orgId));
          }
        },
        child: const Icon(Icons.add),
      ),
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
                onPrimary: () async {
                  await showModalBottomSheet(
                    context: context,
                    builder: (context) => SafeArea(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            title: const Text('Publish'),
                            onTap: () async {
                              await repo.publishEvent(ev.id);
                              if (context.mounted) Navigator.pop(context);
                              ref.invalidate(orgEventsProvider(orgId));
                            },
                          ),
                          ListTile(
                            title: const Text('Cancel'),
                            onTap: () async {
                              await repo.cancelEvent(ev.id);
                              if (context.mounted) Navigator.pop(context);
                              ref.invalidate(orgEventsProvider(orgId));
                            },
                          ),
                          ListTile(
                            title: const Text('Complete'),
                            onTap: () async {
                              await repo.completeEvent(ev.id);
                              if (context.mounted) Navigator.pop(context);
                              ref.invalidate(orgEventsProvider(orgId));
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
                primaryText: 'Удирдах  >',
              );
            },
          );
        },
      ),
    );
  }
}
