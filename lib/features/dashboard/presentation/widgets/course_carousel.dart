import 'package:flutter/material.dart';
import '../../../../core/database/models/subject_model.dart';
import '../../../../core/theme/app_colors.dart';

class CourseCarousel extends StatelessWidget {
  final List<Subject> subjects;
  final VoidCallback onAddSubject;

  const CourseCarousel({
    super.key,
    required this.subjects,
    required this.onAddSubject,
  });

  Color _getColor(String colorKey) {
    switch (colorKey.toLowerCase()) {
      case 'pink':
        return AppColors.coursePink;
      case 'amber':
        return AppColors.courseAmber;
      case 'violet':
        return AppColors.scheduleViolet;
      case 'blue':
        return AppColors.courseBlue;
      default:
        return AppColors.brandGreen;
    }
  }

  IconData _getIcon(String iconKey) {
    switch (iconKey.toLowerCase()) {
      case 'code':
        return Icons.code_rounded;
      case 'science':
        return Icons.science_outlined;
      case 'math':
        return Icons.calculate_outlined;
      case 'globe':
        return Icons.public_rounded;
      case 'art':
        return Icons.palette_outlined;
      default:
        return Icons.auto_stories_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (subjects.isEmpty) {
      return Container(
        height: 120,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.divider),
        ),
        child: Center(
          child: TextButton.icon(
            onPressed: onAddSubject,
            icon: const Icon(Icons.add_circle_outline, color: AppColors.brandGreen),
            label: const Text('Tambah Mata Kuliah Pertama', style: TextStyle(color: AppColors.brandGreen, fontWeight: FontWeight.bold)),
          ),
        ),
      );
    }

    return SizedBox(
      height: 125,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: subjects.length + 1,
        separatorBuilder: (context, index) => const SizedBox(width: 14),
        itemBuilder: (context, index) {
          if (index == subjects.length) {
            // Add Course Card button
            return GestureDetector(
              onTap: onAddSubject,
              child: Container(
                width: 90,
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.divider, width: 1.5),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_rounded, size: 30, color: AppColors.textSecondary),
                    SizedBox(height: 6),
                    Text('Tambah', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                  ],
                ),
              ),
            );
          }

          final subject = subjects[index];
          final bgColor = _getColor(subject.colorKey);
          final iconData = _getIcon(subject.iconKey);

          return Container(
            width: 170,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: bgColor.withValues(alpha: 0.35),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(iconData, color: Colors.white, size: 28),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${subject.credits} SKS',
                        style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subject.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subject.lecturerName ?? subject.code ?? 'Kuliah Aktif',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
