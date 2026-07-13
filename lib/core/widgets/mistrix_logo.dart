import 'package:flutter/material.dart';

class MistrixLogo extends StatelessWidget {
  const MistrixLogo({this.compact = false, super.key});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: compact ? 38 : 48,
          height: compact ? 38 : 48,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(compact ? 12 : 15),
          ),
          child: Icon(
            Icons.handyman_rounded,
            color: Colors.white,
            size: compact ? 22 : 28,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          'mistrix',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w900,
                letterSpacing: -1,
              ),
        ),
      ],
    );
  }
}
