import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/database/models/task_model.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/empty_state.dart';
import 'add_task_dialog.dart';

final taskFilterProvider = StateProvider<String>((ref) => 'all'); // 'all', 'pending', 'done'

class TasksScreen extends ConsumerWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(tasksProvider);
    final filter = ref.watch(taskFilterProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Tugas Kuliah', style: AppTypography.subtitle),
                      Text('Tasks', style: AppTypography.screenTitle),
                    ],
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => const AddTaskDialog(),
                      );
                    },
                    icon: const Icon(Icons.add, size: 18, color: Colors.white),
                    label: const Text('Tugas Baru', style: TextStyle(fontWeight: FontWeight.bold)),
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
            ),

            const SizedBox(height: 16),

            // Filter Tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _buildFilterTab(ref, 'all', 'Semua', filter),
                  const SizedBox(width: 8),
                  _buildFilterTab(ref, 'pending', 'Belum Selesai', filter),
                  const SizedBox(width: 8),
                  _buildFilterTab(ref, 'done', 'Selesai', filter),
                ],
              ),
            ),

            const SizedBox(height: 16),
            const Divider(height: 1, color: AppColors.divider),

            // Tasks List
            Expanded(
              child: tasksAsync.when(
                data: (tasks) {
                  final filteredTasks = tasks.where((t) {
                    if (filter == 'pending') return !t.isDone;
                    if (filter == 'done') return t.isDone;
                    return true;
                  }).toList();

                  if (filteredTasks.isEmpty) {
                    return EmptyStateView(
                      icon: Icons.assignment_turned_in_outlined,
                      title: filter == 'done'
                          ? 'Belum Ada Tugas Selesai'
                          : 'Tidak Ada Tugas Aktif',
                      subtitle: filter == 'done'
                          ? 'Selesaikan tugas-tugas Anda untuk melihat riwayat di sini.'
                          : 'Semua tugas kuliah Anda sudah tuntas!',
                      buttonText: filter != 'done' ? 'Tambah Tugas' : null,
                      onButtonPressed: filter != 'done'
                          ? () {
                              showDialog(
                                context: context,
                                builder: (context) => const AddTaskDialog(),
                              );
                            }
                          : null,
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    itemCount: filteredTasks.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final task = filteredTasks[index];
                      return _buildTaskCard(context, ref, task);
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

  Widget _buildFilterTab(WidgetRef ref, String key, String label, String current) {
    final isSelected = key == current;
    return GestureDetector(
      onTap: () => ref.read(taskFilterProvider.notifier).state = key,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.brandGreen : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(12),
          border: isSelected ? null : Border.all(color: AppColors.divider),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildTaskCard(BuildContext context, WidgetRef ref, TaskItem task) {
    Color priorityColor;
    String priorityText;
    switch (task.priority) {
      case 'high':
        priorityColor = AppColors.danger;
        priorityText = 'Tinggi';
        break;
      case 'low':
        priorityColor = Colors.blue;
        priorityText = 'Rendah';
        break;
      default:
        priorityColor = AppColors.warning;
        priorityText = 'Sedang';
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: task.isDone ? AppColors.surfaceLight : AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: task.isDone ? AppColors.divider : AppColors.divider.withValues(alpha: 0.8),
        ),
        boxShadow: task.isDone
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Checkbox Toggle
              GestureDetector(
                onTap: () {
                  ref.read(tasksProvider.notifier).toggleTask(task.id);
                },
                child: Container(
                  width: 24,
                  height: 24,
                  margin: const EdgeInsets.only(top: 2, right: 12),
                  decoration: BoxDecoration(
                    color: task.isDone ? AppColors.brandGreen : Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: task.isDone ? AppColors.brandGreen : AppColors.textSecondary,
                      width: 2,
                    ),
                  ),
                  child: task.isDone
                      ? const Icon(Icons.check, size: 16, color: Colors.white)
                      : null,
                ),
              ),

              // Title and Description
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: task.isDone ? AppColors.textSecondary : AppColors.textPrimary,
                        decoration: task.isDone ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    if (task.description != null && task.description!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        task.description!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                          decoration: task.isDone ? TextDecoration.lineThrough : null,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Delete button
              IconButton(
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.only(left: 8),
                icon: const Icon(Icons.delete_outline_rounded, size: 18, color: AppColors.textMuted),
                onPressed: () {
                  _confirmDeleteTask(context, ref, task.id);
                },
              ),
            ],
          ),

          const SizedBox(height: 12),
          const Divider(height: 1, color: AppColors.divider),
          const SizedBox(height: 10),

          // Metadata row (Subject, Deadline, Priority)
          Row(
            children: [
              if (task.subjectName != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.brandGreenLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    task.subjectName!,
                    style: const TextStyle(
                      color: AppColors.brandGreen,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: priorityColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  priorityText,
                  style: TextStyle(
                    color: priorityColor,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              if (task.dueAt != null)
                Row(
                  children: [
                    const Icon(Icons.access_time_rounded, size: 13, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      DateFormat('d MMM, HH:mm').format(task.dueAt!),
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }

  void _confirmDeleteTask(BuildContext context, WidgetRef ref, String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Tugas?'),
        content: const Text('Tugas ini akan dihapus secara permanen.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(tasksProvider.notifier).deleteTask(id);
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
