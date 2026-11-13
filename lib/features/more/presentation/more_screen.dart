import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  final List<Map<String, dynamic>> _modules = const [
    {'title': 'Reminder Center', 'icon': Icons.alarm_rounded, 'color': AppColors.coursePink},
    {'title': 'Catatan Kuliah', 'icon': Icons.notes_rounded, 'color': AppColors.courseAmber},
    {'title': 'Habit Tracker', 'icon': Icons.repeat_rounded, 'color': AppColors.scheduleViolet},
    {'title': 'Study Tracker', 'icon': Icons.timer_outlined, 'color': AppColors.brandGreen},
    {'title': 'Nilai & IPK', 'icon': Icons.school_outlined, 'color': AppColors.courseBlue},
    {'title': 'Kehadiran', 'icon': Icons.fact_check_outlined, 'color': AppColors.coursePink},
    {'title': 'Dokumen', 'icon': Icons.folder_outlined, 'color': AppColors.courseAmber},
    {'title': 'Proyek Kelompok', 'icon': Icons.group_work_outlined, 'color': AppColors.scheduleViolet},
    {'title': 'Agenda Pribadi', 'icon': Icons.event_note_outlined, 'color': AppColors.brandGreen},
    {'title': 'Pengaturan', 'icon': Icons.settings_outlined, 'color': AppColors.textPrimary},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Modul Tambahan', style: AppTypography.subtitle),
                  Text('More Menu', style: AppTypography.screenTitle),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Divider(height: 1, color: AppColors.divider),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 1.5,
                ),
                itemCount: _modules.length,
                itemBuilder: (context, index) {
                  final item = _modules[index];
                  final color = item['color'] as Color;
                  return Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceLight,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.divider),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(item['icon'] as IconData, color: color, size: 28),
                        const SizedBox(height: 8),
                        Text(
                          item['title'] as String,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
