import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/database/models/subject_model.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class AddSubjectDialog extends ConsumerStatefulWidget {
  const AddSubjectDialog({super.key});

  @override
  ConsumerState<AddSubjectDialog> createState() => _AddSubjectDialogState();
}

class _AddSubjectDialogState extends ConsumerState<AddSubjectDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _codeController = TextEditingController();
  final _lecturerController = TextEditingController();
  int _credits = 3;
  String _selectedColor = 'pink';
  String _selectedIcon = 'book';

  final List<String> _colors = ['pink', 'amber', 'violet', 'blue'];
  final List<String> _icons = ['book', 'code', 'science', 'math', 'globe', 'art'];

  Color _resolveColor(String key) {
    switch (key) {
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

  IconData _resolveIcon(String key) {
    switch (key) {
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
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _lecturerController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final subject = Subject(
      id: const Uuid().v4(),
      name: _nameController.text.trim(),
      code: _codeController.text.trim().isEmpty ? null : _codeController.text.trim(),
      lecturerName: _lecturerController.text.trim().isEmpty ? null : _lecturerController.text.trim(),
      credits: _credits,
      colorKey: _selectedColor,
      iconKey: _selectedIcon,
    );

    await ref.read(subjectsProvider.notifier).addSubject(subject);
    if (mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mata kuliah berhasil ditambahkan!'),
          backgroundColor: AppColors.brandGreen,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: AppColors.surface,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Tambah Mata Kuliah', style: AppTypography.cardTitle),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded, color: AppColors.textSecondary),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Mata Kuliah *',
                  hintText: 'Contoh: Algoritma & Struktur Data',
                ),
                validator: (val) => val == null || val.trim().isEmpty ? 'Nama wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _codeController,
                      decoration: const InputDecoration(
                        labelText: 'Kode (Opsional)',
                        hintText: 'IF2101',
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 110,
                    child: DropdownButtonFormField<int>(
                      initialValue: _credits,
                      decoration: const InputDecoration(labelText: 'SKS'),
                      items: [1, 2, 3, 4, 6]
                          .map((c) => DropdownMenuItem(value: c, child: Text('$c SKS')))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _credits = val);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _lecturerController,
                decoration: const InputDecoration(
                  labelText: 'Dosen Pengampu (Opsional)',
                  hintText: 'Nama dosen',
                ),
              ),
              const SizedBox(height: 16),
              const Text('Warna Kartu', style: AppTypography.caption),
              const SizedBox(height: 8),
              Row(
                children: _colors.map((c) {
                  final isSelected = _selectedColor == c;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedColor = c),
                    child: Container(
                      margin: const EdgeInsets.only(right: 12),
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: _resolveColor(c),
                        shape: BoxShape.circle,
                        border: isSelected ? Border.all(color: AppColors.navBlack, width: 3) : null,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              const Text('Ikon Mata Kuliah', style: AppTypography.caption),
              const SizedBox(height: 8),
              Wrap(
                spacing: 10,
                children: _icons.map((ic) {
                  final isSelected = _selectedIcon == ic;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedIcon = ic),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.brandGreenLight : AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isSelected ? AppColors.brandGreen : AppColors.divider,
                        ),
                      ),
                      child: Icon(
                        _resolveIcon(ic),
                        size: 22,
                        color: isSelected ? AppColors.brandGreen : AppColors.textPrimary,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.brandGreen,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('Simpan Mata Kuliah', style: AppTypography.button),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
