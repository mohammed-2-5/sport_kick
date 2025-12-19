import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/features/owner/presentation/widgets/dashboard/quick_action_card.dart';

class DashboardQuickActions extends StatelessWidget {
  final VoidCallback onManualBooking;
  final VoidCallback onManageBookings;
  final VoidCallback onManageFields;
  final VoidCallback onAnalytics;
  final VoidCallback onSettings;

  const DashboardQuickActions({
    required this.onManualBooking,
    required this.onManageBookings,
    required this.onManageFields,
    required this.onAnalytics,
    required this.onSettings,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.quickActions,
          style: AppTextStyles.appBarTitle.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),

        // Create Manual Booking - Primary Action
        SizedBox(
          width: double.infinity,
          height: 70,
          child: ElevatedButton(
            onPressed: onManualBooking,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4CAF50),
              foregroundColor: Colors.white,
              elevation: 2,
              shadowColor: const Color(0xFF4CAF50).withValues(alpha: 0.4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add_circle_outline, size: 28),
                ),
                const SizedBox(width: 16),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.createManualBooking,
                      style: AppTextStyles.titleMedium.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      context.l10n.forWalkInCustomers,
                      style: AppTextStyles.labelMedium.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: QuickActionCard(
                title: context.l10n.manageBookings,
                icon: Icons.list_alt_rounded,
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
                ),
                onTap: onManageBookings,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: QuickActionCard(
                title: context.l10n.manageFields,
                icon: Icons.stadium_rounded,
                gradient: const LinearGradient(
                  colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                ),
                onTap: onManageFields,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: QuickActionCard(
                title: context.l10n.analytics,
                icon: Icons.bar_chart_rounded,
                gradient: const LinearGradient(
                  colors: [Color(0xFF26A69A), Color(0xFF4DB6AC)],
                ),
                onTap: onAnalytics,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: QuickActionCard(
                title: context.l10n.settings,
                icon: Icons.settings_rounded,
                gradient: const LinearGradient(
                  colors: [Color(0xFFAB47BC), Color(0xFFBA68C8)],
                ),
                onTap: onSettings,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
