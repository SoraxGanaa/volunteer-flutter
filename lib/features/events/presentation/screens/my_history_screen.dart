import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/state/auth_controller.dart';
import '../../data/models/history_models.dart';
import '../../data/repos/history_repo.dart';
import '../../../../core/utils/api_error_ui.dart';

final _historyRepoProvider = Provider((ref) => HistoryRepo(ref.watch(apiClientProvider)));

final myHistoryProvider = FutureProvider<List<HistoryItem>>((ref) async {
  return ref.watch(_historyRepoProvider).myHistory();
});

class MyHistoryScreen extends ConsumerWidget {
  const MyHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(myHistoryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('My history')),
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
          if (items.isEmpty) return const Center(child: Text('No history'));
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (_, i) {
              final h = items[i];
              return Card(
                child: ListTile(
                  title: Text(h.eventTitle),
                  subtitle: Text('${h.orgName} • ${h.attendanceStatus.name}'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
