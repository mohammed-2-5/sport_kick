import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/theme/theme_extensions.dart';
import 'package:spo_kick/features/owner/presentation/widgets/premium/bookings/premium_owner_bookings_header/header_back_button.dart';
import 'package:spo_kick/features/owner/presentation/widgets/premium/bookings/premium_owner_bookings_header/header_search_bar.dart';
import 'package:spo_kick/features/owner/presentation/widgets/premium/bookings/premium_owner_bookings_header/header_stat_chip.dart';

/// Premium header for owner bookings page.
///
/// Features:
/// - Navy gradient background
/// - Search bar with blur effect
/// - Stats chips showing counts
/// - Back button
class PremiumOwnerBookingsHeader extends StatelessWidget {
  final String searchQuery;
  final Function(String) onSearchChanged;
  final VoidCallback onClearSearch;
  final Map<String, int> stats;

  const PremiumOwnerBookingsHeader({
    super.key,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.onClearSearch,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16,
        left: 20,
        right: 20,
        bottom: 24,
      ),
      decoration: BoxDecoration(gradient: context.navyGradient),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row
          Row(
            children: [
              HeaderBackButton(onTap: () => Navigator.pop(context)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.manageBookings,
                      style: AppTextStyles.headlineSmall.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      context.l10n.reviewManageBookings,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Search bar
          HeaderSearchBar(
            query: searchQuery,
            onChanged: onSearchChanged,
            onClear: onClearSearch,
          ),

          const SizedBox(height: 16),

          // Stats chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                HeaderStatChip(
                  label: context.l10n.total,
                  count: stats[context.l10n.total2] ?? 0,
                ),
                const SizedBox(width: 8),
                HeaderStatChip(
                  label: context.l10n.pending,
                  count: stats[context.l10n.pendingStatus] ?? 0,
                  color: Colors.orange,
                ),
                const SizedBox(width: 8),
                HeaderStatChip(
                  label: context.l10n.statusConfirmed,
                  count: stats[context.l10n.confirmed] ?? 0,
                  color: Colors.green,
                ),
                const SizedBox(width: 8),
                HeaderStatChip(
                  label: context.l10n.statusCanceled,
                  count: stats[context.l10n.canceled] ?? 0,
                  color: Colors.red,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
