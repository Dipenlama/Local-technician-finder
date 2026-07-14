import 'package:flutter/material.dart';

class ServiceCategory extends StatelessWidget {
  const ServiceCategory({
    required this.data,
    required this.onTap,
    super.key,
  });

  final ServiceCategoryData data;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Ink(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: data.color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(data.icon, color: data.color, size: 27),
            ),
            const SizedBox(height: 9),
            Text(
              data.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class ServiceCategoryData {
  const ServiceCategoryData({
    required this.label,
    required this.icon,
    required this.color,
    this.query,
  });

  final String label;
  final IconData icon;
  final Color color;
  final String? query;
}
