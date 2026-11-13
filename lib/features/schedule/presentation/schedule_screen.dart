import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/models/schedule_model.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/empty_state.dart';
import 'add_schedule_dialog.dart';
import 'add_subject_dialog.dart';

class ScheduleScreen extends ConsumerWidget {
  const ScheduleScreen({super.key});

  static const List<String> _dayNames = [
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Sabtu',
    'Minggu',
  ];

  static const List<String> _dayShortNames = [
    'Sen',
    'Sel',
    'Rab',
    'Kam',
    'Jum',
    'Sab',
    'Min',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDay = ref.watch(selectedDayProvider);
    final schedulesAsync = ref.watch(schedulesProvider);
    final today = DateTime.now().weekday;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            // Header: Title and Actions
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        selectedDay == today ? 'Hari Ini' : 'Jadwal Kuliah',
                        style: AppTypography.subtitle,
                      ),
                      Text(
                        _dayNames[selectedDay - 1],
                        style: AppTypography.screenTitle,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton.filledTonal(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => const AddSubjectDialog(),
                          );
                        },
                        icon: const Icon(Icons.bookmark_add_outlined, size: 20),
                        tooltip: 'Tambah Mata Kuliah',
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.brandGreenLight,
                          foregroundColor: AppColors.brandGreen,
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AddScheduleDialog(initialDay: selectedDay),
                          );
                        },
                        icon: const Icon(Icons.add, size: 18, color: Colors.white),
                        label: const Text('Jadwal', style: TextStyle(fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.brandGreen,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Horizontal Day Selector Strip
            SizedBox(
              height: 70,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                itemCount: 7,
                separatorBuilder: (context, index) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final dayNumber = index + 1;
                  final isSelected = selectedDay == dayNumber;
                  final isCurrentDay = today == dayNumber;

                  return GestureDetector(
                    onTap: () {
                      ref.read(selectedDayProvider.notifier).state = dayNumber;
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 52,
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.brandGreen : AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(16),
                        border: isSelected
                            ? null
                            : Border.all(
                                color: isCurrentDay
                                    ? AppColors.brandGreen.withValues(alpha: 0.5)
                                    : AppColors.divider,
                                width: isCurrentDay ? 1.5 : 1,
                              ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: AppColors.brandGreen.withValues(alpha: 0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ]
                            : null,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _dayShortNames[index],
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isSelected ? Colors.white70 : AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$dayNumber',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              color: isSelected ? Colors.white : AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),
            const Divider(height: 1, color: AppColors.divider),

            // Timeline View
            Expanded(
              child: schedulesAsync.when(
                data: (schedules) {
                  final daySchedules = schedules
                      .where((s) => s.dayOfWeek == selectedDay)
                      .toList()
                    ..sort((a, b) => a.startMinute.compareTo(b.startMinute));

                  if (daySchedules.isEmpty) {
                    return EmptyStateView(
                      icon: Icons.event_available_rounded,
                      title: 'Tidak Ada Jadwal Kuliah',
                      subtitle: 'Belum ada kelas terjadwal untuk hari ${_dayNames[selectedDay - 1]}.',
                      buttonText: 'Tambah Jadwal',
                      onButtonPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AddScheduleDialog(initialDay: selectedDay),
                        );
                      },
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    itemCount: daySchedules.length,
                    itemBuilder: (context, index) {
                      final schedule = daySchedules[index];
                      final isViolet = index % 2 == 0;
                      return _buildTimelineItem(context, ref, schedule, isViolet);
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Error: $e')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineItem(
    BuildContext context,
    WidgetRef ref,
    ClassSchedule schedule,
    bool isViolet,
  ) {
    final bgColor = isViolet ? AppColors.scheduleViolet : AppColors.scheduleMint;
    final textColor = isViolet ? Colors.white : AppColors.textPrimary;
    final subtextColor = isViolet ? Colors.white.withValues(alpha: 0.85) : AppColors.textSecondary;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Time Column (Left)
          SizedBox(
            width: 58,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  schedule.startTimeFormatted,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  schedule.endTimeFormatted,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Timeline Dot & Line
          Column(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: isViolet ? AppColors.scheduleViolet : AppColors.brandGreen,
                  shape: BoxShape.circle,
                ),
              ),
              Container(
                width: 2,
                height: 80,
                color: AppColors.divider,
              ),
            ],
          ),

          const SizedBox(width: 12),

          // Schedule Card (Right)
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: isViolet
                        ? AppColors.scheduleViolet.withValues(alpha: 0.2)
                        : Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          schedule.subjectName ?? 'Mata Kuliah',
                          style: TextStyle(
                            color: textColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      IconButton(
                        constraints: const BoxConstraints(),
                        padding: EdgeInsets.zero,
                        icon: Icon(
                          Icons.delete_outline_rounded,
                          size: 18,
                          color: textColor.withValues(alpha: 0.8),
                        ),
                        onPressed: () {
                          _confirmDelete(context, ref, schedule.id);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  if (schedule.room != null && schedule.room!.isNotEmpty)
                    Row(
                      children: [
                        Icon(Icons.location_on_rounded, size: 13, color: textColor),
                        const SizedBox(width: 4),
                        Text(
                          schedule.room!,
                          style: TextStyle(
                            color: textColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  if (schedule.note != null && schedule.note!.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      schedule.note!,
                      style: TextStyle(
                        color: subtextColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Jadwal?'),
        content: const Text('Jadwal perkuliahan ini akan dihapus dari daftar.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(schedulesProvider.notifier).deleteSchedule(id);
              Navigator.of(ctx).pop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
            child: const Text('Hapus', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
