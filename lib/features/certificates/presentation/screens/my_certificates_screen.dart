import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/state/auth_controller.dart';
import '../../data/models/certificate_models.dart';
import '../../data/repos/certificates_repo.dart';
import '../../../../core/utils/api_error_ui.dart';

final _certRepoProvider =
    Provider((ref) => CertificatesRepo(ref.watch(apiClientProvider)));

final myCertificatesProvider = FutureProvider<List<Certificate>>((ref) async {
  return ref.watch(_certRepoProvider).list();
});

class MyCertificatesScreen extends ConsumerWidget {
  const MyCertificatesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(myCertificatesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('My certificates')),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final titleCtrl = TextEditingController();
          final issuerCtrl = TextEditingController();
          final fileCtrl = TextEditingController();

          final created = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Add certificate'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Title')),
                  TextField(controller: issuerCtrl, decoration: const InputDecoration(labelText: 'Issuer')),
                  TextField(controller: fileCtrl, decoration: const InputDecoration(labelText: 'File URL')),
                ],
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Save')),
              ],
            ),
          );

          if (created == true) {
            await ref.read(_certRepoProvider).create(
                  Certificate(
                    id: '0',
                    title: titleCtrl.text.trim(),
                    issuer: issuerCtrl.text.trim().isEmpty ? null : issuerCtrl.text.trim(),
                    issuedAt: null,
                    fileUrl: fileCtrl.text.trim().isEmpty ? null : fileCtrl.text.trim(),
                  ),
                );
            ref.invalidate(myCertificatesProvider);
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
        data: (items) {
          if (items.isEmpty) return const Center(child: Text('No certificates'));
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (_, i) {
              final cert = items[i];
              return Card(
                child: ListTile(
                  title: Text(cert.title),
                  subtitle: Text(cert.issuer ?? ''),
                  onTap: () async {
                    final titleCtrl = TextEditingController(text: cert.title);
                    final issuerCtrl = TextEditingController(text: cert.issuer ?? '');
                    final fileCtrl = TextEditingController(text: cert.fileUrl ?? '');

                    final updated = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Edit certificate'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              controller: titleCtrl,
                              decoration: const InputDecoration(labelText: 'Title'),
                            ),
                            TextField(
                              controller: issuerCtrl,
                              decoration: const InputDecoration(labelText: 'Issuer'),
                            ),
                            TextField(
                              controller: fileCtrl,
                              decoration: const InputDecoration(labelText: 'File URL'),
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Save'),
                          ),
                        ],
                      ),
                    );

                    if (updated == true) {
                      await ref.read(_certRepoProvider).update(
                            Certificate(
                              id: cert.id,
                              title: titleCtrl.text.trim(),
                              issuer: issuerCtrl.text.trim().isEmpty ? null : issuerCtrl.text.trim(),
                              issuedAt: cert.issuedAt,
                              fileUrl: fileCtrl.text.trim().isEmpty ? null : fileCtrl.text.trim(),
                            ),
                          );
                      ref.invalidate(myCertificatesProvider);
                    }
                  },
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      await ref.read(_certRepoProvider).delete(cert.id);
                      ref.invalidate(myCertificatesProvider);
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
