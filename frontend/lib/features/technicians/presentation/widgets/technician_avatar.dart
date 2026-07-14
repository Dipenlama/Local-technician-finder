import 'dart:convert';

import 'package:flutter/material.dart';

class TechnicianAvatar extends StatelessWidget {
  const TechnicianAvatar({
    required this.name,
    this.imageUrl = '',
    this.radius = 24,
    super.key,
  });

  final String name;
  final String imageUrl;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final fallback = ColoredBox(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Center(
        child: Text(
          name.trim().isEmpty ? 'T' : name.trim()[0].toUpperCase(),
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
            fontSize: radius * 0.72,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
    final image = _buildImage(fallback);
    return ClipOval(
      child: SizedBox.square(dimension: radius * 2, child: image ?? fallback),
    );
  }

  Widget? _buildImage(Widget fallback) {
    final value = imageUrl.trim();
    if (value.isEmpty) return null;

    if (value.startsWith('data:image/')) {
      final separator = value.indexOf(',');
      if (separator == -1) return null;
      try {
        final bytes = base64Decode(value.substring(separator + 1));
        return Image.memory(
          bytes,
          fit: BoxFit.cover,
          gaplessPlayback: true,
          errorBuilder: (_, __, ___) => fallback,
        );
      } on FormatException {
        return null;
      }
    }

    final uri = Uri.tryParse(value);
    if (uri == null || !uri.hasScheme) return null;
    return Image.network(
      value,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => fallback,
    );
  }
}
