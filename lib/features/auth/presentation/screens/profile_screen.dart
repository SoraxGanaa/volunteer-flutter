import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/auth_controller.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider).user;
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Not logged in')),
      );
    }

    final fullName = [
      if (user.firstName != null && user.firstName!.isNotEmpty) user.firstName,
      if (user.lastName != null && user.lastName!.isNotEmpty) user.lastName,
    ].join(' ');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authControllerProvider.notifier).logout(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Role: ${user.role.name}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            if (fullName.isNotEmpty) Text('Name: $fullName'),
            if (user.email.isNotEmpty) Text('Email: ${user.email}'),
            if (user.phone != null && user.phone!.isNotEmpty)
              Text('Phone: ${user.phone}'),
          ],
        ),
      ),
    );
  }
}
