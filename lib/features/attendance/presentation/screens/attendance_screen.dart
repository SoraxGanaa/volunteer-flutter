import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/state/auth_controller.dart';
import '../../data/models/attendance_models.dart';
import '../../data/repos/attendance_repo.dart';
import '../../../../core/utils/api_error_ui.dart';

final _attendanceRepoProvider =
    Provider((ref) => AttendanceRepo(ref.watch(apiClientProvider)));

final attendanceProvider =
    FutureProvider.family<List<AttendanceRow>, String>((ref, eventId) async {
  return ref.watch(_attendanceRepoProvider).listAttendance(eventId);
});

class AttendanceScreen extends ConsumerWidget {
  final String eventId;
  const AttendanceScreen({super.key, required this.eventId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(attendanceProvider(eventId));

    return Scaffold(
      appBar: AppBar(title: const Text('Attendance')),
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
        data: (rows) {
          if (rows.isEmpty) return const Center(child: Text('No attendance records'));
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: rows.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (_, i) {
              final row = rows[i];
              return Card(
                child: ListTile(
                  title: Text(row.userName),
                  subtitle: Text(row.status.name),
                  onTap: () async {
                    AttendanceStatus selected = row.status;
                    final noteCtrl = TextEditingController(text: row.note ?? '');
                    final updated = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Update attendance'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            DropdownButton<AttendanceStatus>(
                              value: selected,
                              isExpanded: true,
                              items: AttendanceStatus.values
                                  .map((s) => DropdownMenuItem(
                                        value: s,
                                        child: Text(s.name),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  selected = value;
                                }
                              },
                            ),
                            TextField(
                              controller: noteCtrl,
                              decoration: const InputDecoration(labelText: 'Note'),
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
                      await ref.read(_attendanceRepoProvider).markAttendance(
                            eventId,
                            row.userId,
                            status: selected,
                            note: noteCtrl.text.trim().isEmpty ? null : noteCtrl.text.trim(),
                          );
                      ref.invalidate(attendanceProvider(eventId));
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
