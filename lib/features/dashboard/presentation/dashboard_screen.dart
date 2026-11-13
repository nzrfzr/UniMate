import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import 'widgets/course_carousel.dart';
import 'widgets/upcoming_schedule_card.dart';
import '../../schedule/presentation/add_subject_dialog.dart';
import '../../schedule/presentation/add_schedule_dialog.dart';
import '../../tasks/presentation/add_task_dialog.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subjectsAsync = ref.watch(subjectsProvider);
    final schedulesAsync = ref.watch(schedulesProvider);
    final tasksAsync = ref.watch(tasksProvider);

    final now = DateTime.now();
    String dateFormatted;
    try {
      dateFormatted = DateFormat('EEEE, d MMM', 'id_ID').format(now);
    } catch (_) {
      dateFormatted = DateFormat('EEEE, d MMM').format(now);
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.brandGreen,
          onRefresh: () async {
            await Future.wait([
              ref.read(subjectsProvider.notifier).loadSubjects(),
              ref.read(schedulesProvider.notifier).loadSchedules(),
              ref.read(tasksProvider.notifier).loadTasks(),
            ]);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                // Header & Greeting
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                dateFormatted,
                                style: AppTypography.subtitle.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Hello, Nizar!',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.brandGreenLight,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.brandGreen.withValues(alpha: 0.3), width: 1.5),
                        ),
                        child: const Icon(
                          Icons.person_rounded,
                          color: AppColors.brandGreen,
                          size: 26,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Hero Headline
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: tasksAsync.when(
                    data: (tasks) {
                      final pendingTasks = tasks.where((t) => !t.isDone).length;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("You've got", style: AppTypography.display),
                          Text(
                            pendingTasks > 0
                                ? '$pendingTasks tasks to do'
                                : 'all tasks done today!',
                            style: AppTypography.displayHighlight,
                          ),
                        ],
                      );
                    },
                    loading: () => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("You've got", style: AppTypography.display),
                        Text('loading tasks...', style: AppTypography.displayHighlight),
                      ],
                    ),
                    error: (e, s) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Welcome to", style: AppTypography.display),
                        Text('UniMate Assistant', style: AppTypography.displayHighlight),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                // Section: Courses
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Courses', style: AppTypography.sectionTitle),
                          SizedBox(height: 2),
                          Text('Your running subjects', style: AppTypography.subtitle),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => const AddSubjectDialog(),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.brandGreenLight,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.add, size: 16, color: AppColors.brandGreen),
                              SizedBox(width: 4),
                              Text(
                                'Tambah',
                                style: TextStyle(
                                  color: AppColors.brandGreen,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // Horizontal Course Carousel
                subjectsAsync.when(
                  data: (subjects) => CourseCarousel(
                    subjects: subjects,
                    onAddSubject: () {
                      showDialog(
                        context: context,
                        builder: (context) => const AddSubjectDialog(),
                      );
                    },
                  ),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text('Error: $e')),
                ),

                const SizedBox(height: 32),

                // Section: Your Schedule
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Your Schedule', style: AppTypography.sectionTitle),
                          SizedBox(height: 2),
                          Text('Upcoming classes and activities', style: AppTypography.subtitle),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => const AddScheduleDialog(),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.brandGreenLight,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.add, size: 16, color: AppColors.brandGreen),
                              SizedBox(width: 4),
                              Text(
                                'Tambah',
                                style: TextStyle(
                                  color: AppColors.brandGreen,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Upcoming schedule list
                schedulesAsync.when(
                  data: (schedules) {
                    final today = DateTime.now().weekday;
                    final todaySchedules = schedules.where((s) => s.dayOfWeek == today).toList();

                    if (todaySchedules.isEmpty) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.scheduleMint,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.wb_sunny_rounded, color: AppColors.brandGreen, size: 36),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Tidak ada jadwal kuliah hari ini',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Waktu luang untuk belajar atau istirahat!',
                                    style: AppTypography.subtitle.copyWith(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return Column(
                      children: List.generate(todaySchedules.length, (index) {
                        final schedule = todaySchedules[index];
                        return UpcomingScheduleCard(
                          schedule: schedule,
                          isViolet: index % 2 == 0,
                        );
                      }),
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text('Error: $e')),
                ),

                const SizedBox(height: 24),

                // Quick Action Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => const AddTaskDialog(),
                            );
                          },
                          icon: const Icon(Icons.add_task_rounded, size: 18, color: Colors.white),
                          label: const Text('Tambah Tugas', style: TextStyle(fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.brandGreen,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 13),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            elevation: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
