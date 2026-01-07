import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/widgets/premium/premium_button.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/reports/reports_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/reports/reports_state.dart';

/// Export Section Widget
///
/// Displays export options for reports with:
/// - CSV export button
/// - PDF export button
/// - Navy gradient background
/// - Descriptive header
///
/// Manages export operations through [ReportsCubit]
class ExportSection extends StatelessWidget {
  /// The reports cubit for triggering exports
  final ReportsCubit cubit;

  /// The current reports state
  final ReportsState state;

  const ExportSection({required this.cubit, required this.state, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.navyGradient,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.download_rounded, color: AppColors.goldAccent),
              const SizedBox(width: 12),
              Text(
                context.l10n.exportData,
                style: AppTextStyles.bold(AppTextStyles.headlineSmallWhite),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            context.l10n.generateAndDownloadDetailedReportsIn,
            style: AppTextStyles.withColor(
              AppTextStyles.bodyMedium,
              AppColors.textOnNavySecondary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: PremiumButton(
                  label: context.l10n.csv,
                  onPressed: () {
                    HapticFeedback.mediumImpact();
                    cubit.exportAllDataToCSV();
                  },
                  icon: Icons.table_chart_rounded,
                  style: PremiumButtonStyle.outline,
                  height: 44,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: PremiumButton(
                  label: context.l10n.pdf,
                  onPressed: () {
                    HapticFeedback.mediumImpact();
                    cubit.exportStatisticsToPDF();
                  },
                  icon: Icons.picture_as_pdf_rounded,
                  style: PremiumButtonStyle.secondary,
                  height: 44,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
