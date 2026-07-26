import 'package:flutter/material.dart';
import 'package:mistrix/core/theme/app_colors.dart';
import 'package:mistrix/features/technicians/domain/entities/technician.dart';
import 'package:mistrix/features/technicians/presentation/widgets/technician_avatar.dart';

class TechnicianCard extends StatelessWidget {
  const TechnicianCard({
    required this.technician,
    this.onBook,
    this.isFavorite = false,
    this.isFavoriteUpdating = false,
    this.onFavoriteToggle,
    super.key,
  });

  final Technician technician;
  final VoidCallback? onBook;
  final bool isFavorite;
  final bool isFavoriteUpdating;
  final VoidCallback? onFavoriteToggle;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TechnicianAvatar(
                  name: technician.name,
                  imageUrl: technician.imageUrl,
                  radius: 29,
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        technician.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w800,
                                ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        technician.profession,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 15,
                            color: AppColors.inkMuted,
                          ),
                          const SizedBox(width: 3),
                          Expanded(
                            child: Text(
                              technician.location,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: AppColors.inkMuted,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (onFavoriteToggle != null)
                  isFavoriteUpdating
                      ? const Padding(
                          padding: EdgeInsets.all(10),
                          child: SizedBox.square(
                            dimension: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                      : IconButton(
                          tooltip: isFavorite
                              ? 'Remove from favourites'
                              : 'Add to favourites',
                          visualDensity: VisualDensity.compact,
                          onPressed: onFavoriteToggle,
                          style: IconButton.styleFrom(
                            backgroundColor: isFavorite
                                ? const Color(0xFFFFEDEE)
                                : AppColors.surfaceMuted,
                          ),
                          icon: Icon(
                            isFavorite
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            color: isFavorite
                                ? AppColors.danger
                                : AppColors.inkMuted,
                          ),
                        ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF7E7),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: AppColors.accent,
                        size: 17,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${technician.rating}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        ' (${technician.reviewCount})',
                        style: const TextStyle(
                          color: AppColors.inkMuted,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: technician.isAvailable
                        ? AppColors.secondarySoft
                        : AppColors.surfaceMuted,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    technician.isAvailable ? 'Available' : 'Busy',
                    style: TextStyle(
                      color: technician.isAvailable
                          ? AppColors.success
                          : AppColors.inkMuted,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const Spacer(),
                if (onBook != null && technician.isAvailable)
                  FilledButton(
                    onPressed: onBook,
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(82, 38),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      visualDensity: VisualDensity.compact,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
                    ),
                    child: const Text(
                      'Book',
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
