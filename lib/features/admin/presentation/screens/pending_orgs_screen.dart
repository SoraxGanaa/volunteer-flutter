import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/state/auth_controller.dart';
import '../../data/repos/admin_repo.dart';
import '../../../org_admin/data/models/org_models.dart';
import '../../../../core/utils/api_error_ui.dart';

final _adminRepoProvider = Provider((ref) => AdminRepo(ref.watch(apiClientProvider)));

final pendingOrgsProvider = FutureProvider<List<OrgSummary>>((ref) async {
  return ref.watch(_adminRepoProvider).pendingOrgs();
});

class PendingOrgsScreen extends ConsumerWidget {
  const PendingOrgsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(pendingOrgsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Pending organizations')),
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
        data: (orgs) {
          if (orgs.isEmpty) return const Center(child: Text('No pending orgs'));
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: orgs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (_, i) {
              final o = orgs[i];
              return Card(
                child: ListTile(
                  title: Text(o.name),
                  subtitle: Text('Status: ${o.status}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton(
                        onPressed: () async {
                          await ref.read(_adminRepoProvider).approveOrg(o.id);
                          ref.invalidate(pendingOrgsProvider);
                        },
                        child: const Text('Approve'),
                      ),
                      TextButton(
                        onPressed: () async {
                          await ref.read(_adminRepoProvider).suspendOrg(o.id);
                          ref.invalidate(pendingOrgsProvider);
                        },
                        child: const Text('Suspend'),
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
