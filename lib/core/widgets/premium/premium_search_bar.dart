import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/widgets/premium/premium_curved_header.dart';

/// Premium curved header with search bar.
///
/// Variation of [PremiumCurvedHeader] with built-in search field.
class PremiumCurvedHeaderWithSearch extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String searchHint;
  final TextEditingController? searchController;
  final ValueChanged<String>? onSearchChanged;
  final VoidCallback? onSearchTap;
  final Widget? trailing;
  final double height;

  const PremiumCurvedHeaderWithSearch({
    super.key,
    required this.title,
    this.subtitle,
    this.searchHint = 'Search...',
    this.searchController,
    this.onSearchChanged,
    this.onSearchTap,
    this.trailing,
    this.height = 240,
  });

  @override
  Widget build(BuildContext context) {
    return PremiumCurvedHeader(
      title: title,
      subtitle: subtitle,
      trailing: trailing,
      height: height,
      bottom: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: PremiumSearchBar(
          hint: searchHint,
          controller: searchController,
          onChanged: onSearchChanged,
          onTap: onSearchTap,
        ),
      ),
    );
  }
}

/// Premium search bar widget.
///
/// Standalone search bar with premium styling.
class PremiumSearchBar extends StatefulWidget {
  final String hint;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;

  const PremiumSearchBar({
    super.key,
    required this.hint,
    this.controller,
    this.onChanged,
    this.onTap,
  });

  @override
  State<PremiumSearchBar> createState() => _PremiumSearchBarState();
}

class _PremiumSearchBarState extends State<PremiumSearchBar> {
  late TextEditingController _effectiveController;
  bool _showClear = false;

  @override
  void initState() {
    super.initState();
    _effectiveController = widget.controller ?? TextEditingController();
    _showClear = _effectiveController.text.isNotEmpty;
    _effectiveController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _effectiveController.dispose();
    } else {
      _effectiveController.removeListener(_onTextChanged);
    }
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = _effectiveController.text.isNotEmpty;
    if (hasText != _showClear) {
      setState(() => _showClear = hasText);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: _effectiveController,
        onChanged: widget.onChanged,
        onTap: widget.onTap,
        readOnly: widget.onTap != null,
        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: const TextStyle(
            color: AppColors.lightTextSecondary,
            fontSize: 16,
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: AppColors.lightTextSecondary,
          ),
          suffixIcon: _showClear
              ? IconButton(
                  icon: const Icon(
                    Icons.clear,
                    color: AppColors.lightTextSecondary,
                  ),
                  onPressed: () {
                    _effectiveController.clear();
                    widget.onChanged?.call('');
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
        ),
      ),
    );
  }
}
