import 'package:flutter/material.dart';
import 'package:mistrix/core/widgets/mistrix_logo.dart';

class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    required this.title,
    required this.subtitle,
    required this.child,
    this.showBackButton = false,
    super.key,
  });

  final String title;
  final String subtitle;
  final Widget child;
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showBackButton ? AppBar() : null,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const MistrixLogo(),
              const SizedBox(height: 44),
              Text(
                title,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.8,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.blueGrey.shade600,
                    ),
              ),
              const SizedBox(height: 32),
              child,
            ],
          ),
        ),
      ),
    );
  }
}
