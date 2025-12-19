import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/widgets/premium/premium_card.dart';
import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';

/// Premium admin action buttons.
///
/// Features:
/// - Status toggle button
/// - Assign field button
/// - Reset password button
/// - Gold theme styling
/// - Tap animations
class PremiumAdminActionButtons extends StatelessWidget {
  final UserEntity admin;
  final bool isTogglingStatus;
  final bool isAssigningField;
  final bool isResettingPassword;
  final VoidCallback onToggleStatus;
  final VoidCallback onAssignField;
  final VoidCallback onResetPassword;

  const PremiumAdminActionButtons({
    super.key,
    required this.admin,
    required this.isTogglingStatus,
    required this.isAssigningField,
    required this.isResettingPassword,
    required this.onToggleStatus,
    required this.onAssignField,
    required this.onResetPassword,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: PremiumCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // First row: Activate/Deactivate and Assign Field
            Row(
              children: [
                Expanded(
                  child: _ActionButton(
                    label: admin.isActive ? 'Deactivate' : 'Activate',
                    icon: admin.isActive
                        ? Icons.block
                        : Icons.check_circle_outline,
                    color: admin.isActive ? Colors.orange : Colors.green,
                    isLoading: isTogglingStatus,
                    onTap: onToggleStatus,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ActionButton(
                    label: 'Assign Field',
                    icon: Icons.add_business,
                    color: AppColors.premiumGold,
                    isLoading: isAssigningField,
                    onTap: onAssignField,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Second row: Reset Password (full width)
            SizedBox(
              width: double.infinity,
              child: _ActionButton(
                label: 'Reset Password',
                icon: Icons.lock_reset,
                color: Colors.blue,
                isLoading: isResettingPassword,
                onTap: onResetPassword,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Action button widget with animation.
class _ActionButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final Color color;
  final bool isLoading;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    this.isLoading = false,
    required this.onTap,
  });

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
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
      onTapDown: (_) {
        if (!widget.isLoading) _controller.forward();
      },
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: () {
        if (!widget.isLoading) {
          HapticFeedback.mediumImpact();
          widget.onTap();
        }
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(scale: _scaleAnimation.value, child: child);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: widget.color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: widget.color.withValues(alpha: 0.3)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.isLoading)
                SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: widget.color,
                  ),
                )
              else
                Icon(widget.icon, size: 18, color: widget.color),
              const SizedBox(width: 8),
              Text(
                widget.label,
                style: AppTextStyles.labelLarge.copyWith(
                  fontWeight: FontWeight.w600,
                  color: widget.color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
