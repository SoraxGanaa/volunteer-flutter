import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/auth_controller.dart';
import '../widgets/auth_text_field.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final firstNameCtrl = TextEditingController();
  final lastNameCtrl = TextEditingController();

  @override
  void dispose() {
    emailCtrl.dispose();
    phoneCtrl.dispose();
    passwordCtrl.dispose();
    firstNameCtrl.dispose();
    lastNameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);
    final notifier = ref.read(authControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            AuthTextField(
              controller: emailCtrl,
              label: 'Email (optional)',
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            AuthTextField(
              controller: phoneCtrl,
              label: 'Phone (optional)',
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 12),
            AuthTextField(
              controller: passwordCtrl,
              label: 'Password',
              obscureText: true,
            ),
            const SizedBox(height: 12),
            AuthTextField(
              controller: firstNameCtrl,
              label: 'First name (optional)',
            ),
            const SizedBox(height: 12),
            AuthTextField(
              controller: lastNameCtrl,
              label: 'Last name (optional)',
            ),
            const SizedBox(height: 16),
            if (state.error != null)
              Text(state.error!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: state.isLoading
                  ? null
                  : () {
                      final email = emailCtrl.text.trim();
                      final phone = phoneCtrl.text.trim();
                      if (email.isEmpty && phone.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Email or phone is required')),
                        );
                        return;
                      }
                      notifier.register(
                        email: email.isEmpty ? null : email,
                        phone: phone.isEmpty ? null : phone,
                        password: passwordCtrl.text,
                        firstName: firstNameCtrl.text.trim().isEmpty
                            ? null
                            : firstNameCtrl.text.trim(),
                        lastName: lastNameCtrl.text.trim().isEmpty
                            ? null
                            : lastNameCtrl.text.trim(),
                      );
                    },
              child: state.isLoading
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Create account'),
            ),
          ],
        ),
      ),
    );
  }
}
