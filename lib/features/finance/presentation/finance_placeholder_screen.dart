import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/empty_state.dart';

class FinancePlaceholderScreen extends StatelessWidget {
  const FinancePlaceholderScreen({super.key});

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
                  Text('Dompet & Pengeluaran', style: AppTypography.subtitle),
                  Text('Finance', style: AppTypography.screenTitle),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Divider(height: 1, color: AppColors.divider),
            const Expanded(
              child: EmptyStateView(
                icon: Icons.account_balance_wallet_outlined,
                title: 'Modul Keuangan (Phase 2)',
                subtitle: 'Fitur pencatatan multi-dompet, transaksi ledger, anggaran, dan tabungan akan diaktifkan pada fase berikutnya sesuai roadmap UniMate.',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

