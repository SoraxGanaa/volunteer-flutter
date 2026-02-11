import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/state/auth_controller.dart';
import '../../data/models/application_models.dart';
import '../../data/repos/applications_repo.dart';
import '../../../../core/utils/api_error_ui.dart';

final _applicationsRepoProvider =
    Provider((ref) => ApplicationsRepo(ref.watch(apiClientProvider)));

final eventApplicationsProvider = FutureProvider.family<List<EventApplication>, EventApplicationsArgs>(
  (ref, args) async {
    return ref.watch(_applicationsRepoProvider).eventApplications(
          args.eventId,
          status: args.status,
        );
  },
);

class EventApplicationsArgs {
  final String eventId;
  final String? status;
  EventApplicationsArgs(this.eventId, {this.status});
}

class EventApplicationsScreen extends ConsumerWidget {
  final String eventId;
  const EventApplicationsScreen({super.key, required this.eventId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(eventApplicationsProvider(EventApplicationsArgs(eventId)));

    return Scaffold(
      appBar: AppBar(title: const Text('Event applications')),
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
                ),
              );
            },
          );
        },
      ),
    );
  }
}
