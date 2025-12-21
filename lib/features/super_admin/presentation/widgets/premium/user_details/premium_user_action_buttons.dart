import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/widgets/premium/premium_card.dart';
import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Premium user action buttons.
///
/// Features:
/// - Status toggle button
/// - Send message button
/// - Color-coded based on status
/// - Tap animations
class PremiumUserActionButtons extends StatelessWidget {
  final UserEntity user;
  final bool isTogglingStatus;
  final VoidCallback onToggleStatus;
  final VoidCallback? onSendMessage;

  const PremiumUserActionButtons({
    super.key,
    required this.user,
    required this.isTogglingStatus,
    required this.onToggleStatus,
    this.onSendMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: PremiumCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: _ActionButton(
                label: user.isActive
                    ? context.l10n.deactivate
                    : context.l10n.activate,
                icon: user.isActive ? Icons.block : Icons.check_circle_outline,
                color: user.isActive ? Colors.orange : Colors.green,
                isLoading: isTogglingStatus,
                onTap: onToggleStatus,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ActionButton(
                label: context.l10n.sendMessage,
                icon: Icons.message_outlined,
                color: AppColors.accentCyan,
                onTap: onSendMessage ?? () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Action button widget.
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
        if (!widget.isLoading) {
          _controller.forward();
        }
      },
      onTapUp: (_) {
        _controller.reverse();
      },
      onTapCancel: () {
        _controller.reverse();
      },
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
                style: AppTextStyles.withColor(
                  AppTextStyles.bold(AppTextStyles.bodyMedium),
                  widget.color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
