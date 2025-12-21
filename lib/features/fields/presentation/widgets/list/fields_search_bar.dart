import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';

/// Floating search bar widget for fields list.
///
/// Displays a search input with:
/// - Search icon
/// - Clear button (when text is present)
/// - Filter button
class FieldsSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback? onClear;
  final VoidCallback? onFilter;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  const FieldsSearchBar({
    super.key,
    required this.controller,
    this.onClear,
    this.onFilter,
    this.onChanged,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: context.l10n.searchByNameCityAddress,
          hintStyle: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.lightTextSecondary.withValues(alpha: 0.6),
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: AppColors.lightAccent,
            size: 24,
          ),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (controller.text.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.clear, color: Colors.grey),
                  onPressed: onClear,
                ),
              Container(
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: AppColors.lightBackground,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.tune,
                    color: AppColors.lightTextSecondary,
                    size: 20,
                  ),
                  onPressed: onFilter,
                ),
              ),
            ],
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
        onChanged: onChanged,
        onSubmitted: onSubmitted,
      ),
    );
  }
}
