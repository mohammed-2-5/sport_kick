import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/utils/locale_formatters.dart';

/// Data for a top field.
class TopFieldData {
  /// Field name.
  final String name;

  /// Total revenue.
  final double revenue;

  /// Number of bookings.
  final int bookings;

  /// Currency symbol.
  final String currency;

  const TopFieldData({
    required this.name,
    required this.revenue,
    required this.bookings,
    this.currency = 'EGP',
  });
}

/// Premium Top Field Card widget.
///
/// Features:
/// - Rank badge with medal colors
/// - Field name and booking count
/// - Revenue badge
class PremiumTopFieldCard extends StatelessWidget {
  /// Field data to display.
  final TopFieldData field;

  /// Rank of the field (1-based).
  final int rank;

  const PremiumTopFieldCard({
    super.key,
    required this.field,
    required this.rank,
  });

  Color get _rankColor {
    switch (rank) {
      case 1:
        return const Color(0xFFFFD700); // Gold
      case 2:
        return const Color(0xFFC0C0C0); // Silver
      case 3:
        return const Color(0xFFCD7F32); // Bronze
      default:
        return AppColors.textSecondary;
    }
  }

  IconData get _rankIcon {
    if (rank <= 3) return Icons.emoji_events_rounded;
    return Icons.sports_soccer_rounded;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: rank <= 3
            ? Border.all(color: _rankColor.withValues(alpha: 0.3), width: 2)
            : null,
        boxShadow: [
          BoxShadow(
            color: _rankColor.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildRankBadge(),
          const SizedBox(width: 12),
          _buildFieldInfo(context),
          _buildRevenueBadge(context),
        ],
      ),
    );
  }

  Widget _buildRankBadge() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: _rankColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: rank <= 3
            ? Icon(_rankIcon, color: _rankColor, size: 22)
            : Text(
                '#$rank',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: _rankColor,
                ),
              ),
      ),
    );
  }

  Widget _buildFieldInfo(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            field.name,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            context.l10n.bookingsCount(
              field.bookings,
              LocaleFormatters.formatNumber(context, field.bookings),
            ),
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueBadge(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.goldAccent.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        LocaleFormatters.formatPrice(
          context,
          amount: field.revenue,
          currency: field.currency,
          decimalDigits: 0,
        ),
        style: AppTextStyles.labelSmall.copyWith(
          fontWeight: FontWeight.w700,
          color: AppColors.goldAccent,
        ),
      ),
    );
  }
}
