import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/router_paths.dart';
import '../../../auth/presentation/state/auth_controller.dart';
import '../../data/models/org_models.dart';
import '../../data/repos/org_repo.dart';

final orgRepoProvider = Provider((ref) => OrgRepo(ref.watch(apiClientProvider)));

final myOrgsProvider = FutureProvider<List<OrgSummary>>((ref) async {
  return ref.watch(orgRepoProvider).myOrgs();
});

class MyOrgsScreen extends ConsumerWidget {
  const MyOrgsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orgsAsync = ref.watch(myOrgsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Миний байгууллагууд'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authControllerProvider.notifier).logout(),
          )
        ],
      ),
      body: orgsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (orgs) {
          if (orgs.isEmpty) return const Center(child: Text('Org байхгүй байна'));

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: orgs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, i) {
              final o = orgs[i];
              return Card(
                child: ListTile(
                  title: Text(o.name),
                  subtitle: Text('Status: ${o.status}'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.go(RoutePaths.adminOrgEvents(o.id)),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
