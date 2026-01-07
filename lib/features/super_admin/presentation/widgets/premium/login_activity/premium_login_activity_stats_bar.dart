import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/theme/theme_extensions.dart';

/// Stats bar for login activity overview.
///
/// Shows:
/// - Total logins
/// - Success rate
/// - Failed attempts
/// - Blocked attempts
class PremiumLoginActivityStatsBar extends StatelessWidget {
  final int totalLogins;
  final int successLogins;
  final int failedLogins;
  final int blockedLogins;

  const PremiumLoginActivityStatsBar({
    required this.totalLogins,
    required this.successLogins,
    required this.failedLogins,
    required this.blockedLogins,
    super.key,
  });

  double get successRate =>
      totalLogins > 0 ? (successLogins / totalLogins * 100) : 0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _StatCard(
            icon: Icons.login_rounded,
            label: context.l10n.totalLogins,
            value: totalLogins.toString(),
            gradient: const [Color(0xFF6366F1), Color(0xFF8B5CF6)],
          ),
          const SizedBox(width: 12),
          _StatCard(
            icon: Icons.trending_up_rounded,
            label: context.l10n.successRate,
            value: '${successRate.toStringAsFixed(1)}%',
            gradient: const [Color(0xFF10B981), Color(0xFF059669)],
          ),
          const SizedBox(width: 12),
          _StatCard(
            icon: Icons.error_outline_rounded,
            label: context.l10n.loginStatusFailed,
            value: failedLogins.toString(),
            gradient: const [Color(0xFFEF4444), Color(0xFFDC2626)],
          ),
          const SizedBox(width: 12),
          _StatCard(
            icon: Icons.block_rounded,
            label: context.l10n.loginStatusBlocked,
            value: blockedLogins.toString(),
            gradient: const [Color(0xFFF59E0B), Color(0xFFD97706)],
          ),
        ],
      ),
    );
  }
}

/// Individual stat card.
class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final List<Color> gradient;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: context.cardShadow,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: AppTextStyles.titleMedium.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              Text(
                label,
                style: AppTextStyles.bodySmall.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
