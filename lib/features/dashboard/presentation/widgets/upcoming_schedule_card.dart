import 'package:flutter/material.dart';
import '../../../../core/database/models/schedule_model.dart';
import '../../../../core/theme/app_colors.dart';

class UpcomingScheduleCard extends StatelessWidget {
  final ClassSchedule schedule;
  final bool isViolet;

  const UpcomingScheduleCard({
    super.key,
    required this.schedule,
    this.isViolet = true,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isViolet ? AppColors.scheduleViolet : AppColors.scheduleMint;
    final textColor = isViolet ? Colors.white : AppColors.textPrimary;
    final subtextColor = isViolet ? Colors.white.withValues(alpha: 0.85) : AppColors.textSecondary;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: isViolet
            ? [
                BoxShadow(
                  color: AppColors.scheduleViolet.withValues(alpha: 0.25),
                  blurRadius: 12,
                  offset: const Offset(0, 5),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isViolet ? Colors.white.withValues(alpha: 0.2) : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.access_time_filled_rounded, size: 14, color: textColor),
                    const SizedBox(width: 5),
                    Text(
                      schedule.timeRange,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              if (schedule.room != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: isViolet ? Colors.white.withValues(alpha: 0.15) : AppColors.brandGreenLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    schedule.room!,
                    style: TextStyle(
                      color: isViolet ? Colors.white : AppColors.brandGreen,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            schedule.subjectName ?? 'Mata Kuliah',
            style: TextStyle(
              color: textColor,
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
          if (schedule.note != null && schedule.note!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              schedule.note!,
              style: TextStyle(
                color: subtextColor,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
