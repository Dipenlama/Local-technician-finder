import 'package:flutter/material.dart';
import 'package:mistrix/features/technicians/domain/entities/technician.dart';
import 'package:mistrix/features/technicians/presentation/widgets/technician_avatar.dart';

class TechnicianCard extends StatelessWidget {
  const TechnicianCard({
    required this.technician,
    this.onBook,
    super.key,
  });

  final Technician technician;
  final VoidCallback? onBook;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            TechnicianAvatar(
              name: technician.name,
              imageUrl: technician.imageUrl,
              radius: 28,
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
                      const Icon(Icons.star_rounded,
                          color: Colors.amber, size: 20),
                      Text(' ${technician.rating} (${technician.reviewCount})'),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                  decoration: BoxDecoration(
                    color: technician.isAvailable
                        ? Colors.green.withValues(alpha: 0.12)
                        : Colors.grey.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    technician.isAvailable ? 'Available' : 'Busy',
                    style: TextStyle(
                      color: technician.isAvailable
                          ? Colors.green.shade700
                          : Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (onBook != null && technician.isAvailable) ...[
                  const SizedBox(height: 8),
                  FilledButton(
                    onPressed: onBook,
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(74, 34),
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      visualDensity: VisualDensity.compact,
                    ),
                    child: const Text('Book'),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
