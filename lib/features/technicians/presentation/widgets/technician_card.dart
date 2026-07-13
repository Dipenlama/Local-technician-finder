import 'package:flutter/material.dart';
import 'package:mistrix/features/technicians/domain/entities/technician.dart';

class TechnicianCard extends StatelessWidget {
  const TechnicianCard({required this.technician, super.key});

  final Technician technician;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              child: Text(
                technician.name.substring(0, 1),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    technician.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text('${technician.profession} • ${technician.location}'),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, color: Colors.amber, size: 20),
                      Text(' ${technician.rating} (${technician.reviewCount})'),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
              decoration: BoxDecoration(
                color: technician.isAvailable
                    ? Colors.green.withValues(alpha: 0.12)
                    : Colors.grey.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                technician.isAvailable ? 'Available' : 'Busy',
                style: TextStyle(
                  color: technician.isAvailable ? Colors.green.shade700 : Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
