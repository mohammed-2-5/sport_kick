import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/theme/theme_extensions.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/all_bookings/components/tab_item.dart';

/// Premium tab bar.
class PremiumTabBar extends StatelessWidget {
  final TabController controller;
  final List<TabItem> tabs;

  const PremiumTabBar({
    super.key,
    required this.controller,
    required this.tabs,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: context.cardShadow,
      ),
      child: TabBar(
        controller: controller,
        isScrollable: true,
        indicator: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: Theme.of(context).colorScheme.onPrimary,
        unselectedLabelColor: Theme.of(context).colorScheme.onSurfaceVariant,
        labelStyle: AppTextStyles.labelMedium.copyWith(
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
        dividerColor: Colors.transparent,
        padding: const EdgeInsets.all(4),
        tabs: tabs.map((tab) => Tab(text: tab.label)).toList(),
      ),
    );
  }
}
