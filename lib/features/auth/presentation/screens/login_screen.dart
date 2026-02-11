import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/router_paths.dart';
import '../state/auth_controller.dart';
import '../widgets/auth_text_field.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final identifierCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  @override
  void dispose() {
    identifierCtrl.dispose();
    passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            AuthTextField(
              controller: identifierCtrl,
              label: 'Email or phone',
            ),
            const SizedBox(height: 12),
            AuthTextField(
              controller: passwordCtrl,
              label: 'Password',
              obscureText: true,
            ),
            const SizedBox(height: 16),
            if (state.error != null)
              Text(state.error!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: state.isLoading
                  ? null
                  : () => ref
                      .read(authControllerProvider.notifier)
                      .login(identifierCtrl.text.trim(), passwordCtrl.text),
              child: state.isLoading
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Login'),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => context.push(RoutePaths.register),
              child: const Text('Create account'),
            ),
          ],
        ),
      ),
    );
  }
}
