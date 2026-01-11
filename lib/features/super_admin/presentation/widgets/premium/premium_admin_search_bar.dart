import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/components/search_filter_button.dart';

/// Premium search bar for super admin.
///
/// Features:
/// - Gradient border on focus
/// - Filter button
/// - Clear button
/// - Search icon
class PremiumAdminSearchBar extends StatefulWidget {
  final String hintText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onFilterTap;
  final bool hasActiveFilters;

  const PremiumAdminSearchBar({
    super.key,
    this.hintText = 'Search...',
    this.controller,
    this.onChanged,
    this.onFilterTap,
    this.hasActiveFilters = false,
  });

  @override
  State<PremiumAdminSearchBar> createState() => _PremiumAdminSearchBarState();
}

class _PremiumAdminSearchBarState extends State<PremiumAdminSearchBar> {
  late TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _focusNode.addListener(() {
      setState(() => _isFocused = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: _isFocused ? AppColors.premiumGold : colorScheme.outline,
          width: _isFocused ? 2 : 1,
        ),
        boxShadow: _isFocused
            ? [
                BoxShadow(
                  color: AppColors.premiumGold.withValues(alpha: 0.2),
                  blurRadius: 8,
                  spreadRadius: 0,
                ),
              ]
            : null,
      ),
      child: Row(
        children: [
          // Search field
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              onChanged: widget.onChanged,
              style: AppTextStyles.bodyMedium.copyWith(
                color: colorScheme.onSurface,
              ),
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: AppTextStyles.bodyMedium.copyWith(
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                ),
                prefixIcon: Icon(
                  Icons.search,
                  size: 20,
                  color: _isFocused
                      ? AppColors.premiumGold
                      : colorScheme.onSurfaceVariant,
                ),
                suffixIcon: _controller.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        color: colorScheme.onSurfaceVariant,
                        onPressed: () {
                          _controller.clear();
                          widget.onChanged?.call('');
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),
          ),

          // Filter button
          if (widget.onFilterTap != null) ...[
            Container(width: 1, height: 30, color: colorScheme.outline),
            SearchFilterButton(
              hasActiveFilters: widget.hasActiveFilters,
              onTap: () {
                HapticFeedback.lightImpact();
                widget.onFilterTap?.call();
              },
            ),
          ],
        ],
      ),
    );
  }
}
