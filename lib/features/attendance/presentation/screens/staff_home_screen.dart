import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/router_paths.dart';

class StaffHomeScreen extends ConsumerStatefulWidget {
  const StaffHomeScreen({super.key});

  @override
  ConsumerState<StaffHomeScreen> createState() => _StaffHomeScreenState();
}

class _StaffHomeScreenState extends ConsumerState<StaffHomeScreen> {
  final eventIdCtrl = TextEditingController();

  @override
  void dispose() {
    eventIdCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Staff tools')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: eventIdCtrl,
              decoration: const InputDecoration(labelText: 'Event ID'),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      final id = eventIdCtrl.text.trim();
                      if (id.isNotEmpty) context.push(RoutePaths.staffApplications(id));
                    },
                    child: const Text('Applications'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      final id = eventIdCtrl.text.trim();
                      if (id.isNotEmpty) context.push(RoutePaths.staffAttendance(id));
                    },
                    child: const Text('Attendance'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
