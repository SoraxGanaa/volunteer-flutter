import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/state/auth_controller.dart';
import '../../data/models/application_models.dart';
import '../../data/repos/applications_repo.dart';
import '../../../../core/utils/api_error_ui.dart';
import '../../../events/data/repos/event_repo.dart';

final _applicationsRepoProvider =
    Provider((ref) => ApplicationsRepo(ref.watch(apiClientProvider)));
final _eventRepoProvider = Provider((ref) => EventRepo(ref.watch(apiClientProvider)));

final myApplicationsProvider = FutureProvider<List<EventApplication>>((ref) async {
  return ref.watch(_applicationsRepoProvider).myApplications();
});

class MyApplicationsScreen extends ConsumerWidget {
  const MyApplicationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(myApplicationsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('My applications')),
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
        data: (items) {
          if (items.isEmpty) return const Center(child: Text('No applications'));
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (_, i) {
              final app = items[i];
              return Card(
                child: ListTile(
                  title: Text(app.eventTitle),
                  subtitle: Text('${app.orgName} • ${app.status.name}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.cancel),
                    onPressed: () async {
                      await ref.read(_eventRepoProvider).cancelMyApply(app.eventId);
                      ref.invalidate(myApplicationsProvider);
                    },
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
