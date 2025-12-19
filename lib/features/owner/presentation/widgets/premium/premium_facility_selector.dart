import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';

/// Premium facility selector (multi-select chips).
///
/// Features:
/// - Multi-select chips
/// - Gradient selected state
/// - Icon for each facility
/// - Tap animation
class PremiumFacilitySelector extends StatelessWidget {
  final String label;
  final List<String> allFacilities;
  final List<String> selectedFacilities;
  final ValueChanged<List<String>> onChanged;

  const PremiumFacilitySelector({
    super.key,
    required this.label,
    required this.allFacilities,
    required this.selectedFacilities,
    required this.onChanged,
  });

  IconData _getIconForFacility(String facility) {
    final lower = facility.toLowerCase();
    if (lower.contains('parking')) return Icons.local_parking;
    if (lower.contains('shower')) return Icons.shower;
    if (lower.contains('locker')) return Icons.storage;
    if (lower.contains('light')) return Icons.light_mode;
    if (lower.contains('cafe')) return Icons.local_cafe;
    if (lower.contains('wifi')) return Icons.wifi;
    return Icons.check_circle_outline;
  }

  void _toggleFacility(String facility) {
    final updated = List<String>.from(selectedFacilities);
    if (updated.contains(facility)) {
      updated.remove(facility);
    } else {
      updated.add(facility);
    }
    onChanged(updated);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: allFacilities.map((facility) {
            final isSelected = selectedFacilities.contains(facility);
            return _FacilityChip(
              label: facility,
              icon: _getIconForFacility(facility),
              isSelected: isSelected,
              onTap: () {
                HapticFeedback.selectionClick();
                _toggleFacility(facility);
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}

/// Individual facility chip.
class _FacilityChip extends StatefulWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _FacilityChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_FacilityChip> createState() => _FacilityChipState();
}

class _FacilityChipState extends State<_FacilityChip>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            gradient: widget.isSelected
                ? const LinearGradient(
                    colors: [AppColors.accentCyan, AppColors.accentCyanDark],
                  )
                : null,
            color: widget.isSelected ? null : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: widget.isSelected ? Colors.transparent : AppColors.border,
            ),
            boxShadow: widget.isSelected
                ? [
                    BoxShadow(
                      color: AppColors.accentCyan.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.icon,
                size: 16,
                color: widget.isSelected
                    ? Colors.white
                    : AppColors.textSecondary,
              ),
              const SizedBox(width: 6),
              Text(
                widget.label,
                style: AppTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: widget.isSelected
                      ? Colors.white
                      : AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
