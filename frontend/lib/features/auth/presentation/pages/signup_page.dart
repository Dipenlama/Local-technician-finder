import 'package:flutter/material.dart';
import 'package:mistrix/features/auth/presentation/widgets/auth_scaffold.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({required this.onSignup, super.key});

  final VoidCallback onSignup;

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _acceptTerms = false;

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      showBackButton: true,
      title: 'Create your account',
      subtitle: 'Join Mistrix and get reliable help whenever you need it.',
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Full name',
                prefixIcon: Icon(Icons.person_outline_rounded),
              ),
              validator: (value) => value == null || value.trim().length < 3
                  ? 'Enter your full name'
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email address',
                prefixIcon: Icon(Icons.mail_outline_rounded),
              ),
              validator: (value) => value == null || !value.contains('@')
                  ? 'Enter a valid email address'
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Phone number',
                prefixIcon: Icon(Icons.phone_outlined),
              ),
              validator: (value) => value == null || value.trim().length < 8
                  ? 'Enter a valid phone number'
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              obscureText: _obscurePassword,
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
              validator: (value) => value == null || value.length < 6
                  ? 'Use at least 6 characters'
                  : null,
            ),
            const SizedBox(height: 12),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              value: _acceptTerms,
              onChanged: (value) =>
                  setState(() => _acceptTerms = value ?? false),
              title: const Text(
                  'I agree to the Terms of Service and Privacy Policy.'),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _submit,
              child: const Text('Create account'),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Already have an account? Sign in'),
            ),
          ],
        ),
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (!_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please accept the terms to continue.')),
      );
      return;
    }
    widget.onSignup();
  }
}
