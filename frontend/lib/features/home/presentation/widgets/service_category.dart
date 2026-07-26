import 'package:flutter/material.dart';
import 'package:mistrix/core/theme/app_colors.dart';

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
      borderRadius: BorderRadius.circular(20),
      child: Ink(
        padding: const EdgeInsets.all(11),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.outline),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0A24315E),
              blurRadius: 12,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: data.color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(data.icon, color: data.color, size: 27),
            ),
            const SizedBox(height: 9),
            Text(
              data.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.ink,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
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
