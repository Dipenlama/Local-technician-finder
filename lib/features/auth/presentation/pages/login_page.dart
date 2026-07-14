import 'package:flutter/material.dart';
import 'package:mistrix/core/constants/app_constants.dart';
import 'package:mistrix/features/auth/presentation/widgets/auth_scaffold.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    required this.onLogin,
    required this.onCreateAccount,
    super.key,
  });

  final void Function(String email, String password) onLogin;
  final VoidCallback onCreateAccount;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'Welcome back',
      subtitle: 'Sign in to find and book trusted technicians near you.',
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              autofillHints: const [AutofillHints.email],
              decoration: const InputDecoration(
                labelText: 'Email address',
                prefixIcon: Icon(Icons.mail_outline_rounded),
              ),
              validator: (value) {
                if (value == null || !value.contains('@')) {
                  return 'Enter a valid email address';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              autofillHints: const [AutofillHints.password],
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: const Icon(Icons.lock_outline_rounded),
                suffixIcon: IconButton(
                  onPressed: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                  icon: Icon(_obscurePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined),
                ),
              ),
              validator: (value) {
                if (value == null || value.length < 6) {
                  return 'Password must contain at least 6 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Checkbox(
                  value: _rememberMe,
                  onChanged: (value) =>
                      setState(() => _rememberMe = value ?? false),
                ),
                const Text('Remember me'),
                const Spacer(),
                TextButton(
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            'Password recovery will be connected to the backend.')),
                  ),
                  child: const Text('Forgot password?'),
                ),
              ],
            ),
            const SizedBox(height: 14),
            FilledButton(
              onPressed: _submit,
              child: const Text('Sign in'),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .primaryContainer
                    .withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.admin_panel_settings_outlined, size: 20),
                  SizedBox(width: 9),
                  Expanded(
                    child: Text(
                      'Admin demo: ${AppConstants.adminEmail} / ${AppConstants.adminPassword}',
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account?"),
                TextButton(
                  onPressed: widget.onCreateAccount,
                  child: const Text('Create account'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      widget.onLogin(
        _emailController.text.trim().toLowerCase(),
        _passwordController.text,
      );
    }
  }
}
