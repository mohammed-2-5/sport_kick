import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/theme/theme_extensions.dart';
import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Premium status toggle confirmation dialog.
///
/// Features:
/// - Animated entrance
/// - Clear warning message
/// - Action buttons
/// - User avatar display
class PremiumStatusToggleDialog extends StatefulWidget {
  final UserEntity user;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const PremiumStatusToggleDialog({
    super.key,
    required this.user,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  State<PremiumStatusToggleDialog> createState() =>
      _PremiumStatusToggleDialogState();
}

class _PremiumStatusToggleDialogState extends State<PremiumStatusToggleDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isActivating = !widget.user.isActive;
    final actionColor = isActivating
        ? colorScheme.success
        : colorScheme.warning;

    return Material(
      color: context.overlayColor,
      child: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Opacity(
              opacity: _fadeAnimation.value,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: child,
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.all(24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: actionColor.withValues(alpha: 0.2),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: actionColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isActivating ? Icons.check_circle : Icons.block,
                    color: actionColor,
                    size: 36,
                  ),
                ),

                const SizedBox(height: 20),

                // Title
                Text(
                  isActivating
                      ? context.l10n.activateUser
                      : context.l10n.deactivateUser,
                  style: AppTextStyles.titleLargeBold,
                ),

                const SizedBox(height: 12),

                // User info
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.accentCyan,
                              AppColors.accentCyanDark,
                            ],
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            widget.user.initials,
                            style: AppTextStyles.withColor(
                              AppTextStyles.bold(AppTextStyles.labelLarge),
                              Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.user.displayName,
                            style: AppTextStyles.bold(
                              AppTextStyles.labelLarge,
                            ).copyWith(color: colorScheme.onSurface),
                          ),
                          Text(
                            widget.user.email,
                            style: AppTextStyles.bodySmallSecondary.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Warning message
                Text(
                  isActivating
                      ? context.l10n.thisUserWillBeAbleTo
                      : 'This user will no longer be able to login or make new bookings.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMediumSecondary.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),

                const SizedBox(height: 24),

                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          widget.onCancel();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: colorScheme.outline),
                          ),
                          child: Center(
                            child: Text(
                              context.l10n.cancel,
                              style: AppTextStyles.withColor(
                                AppTextStyles.bold(AppTextStyles.titleMedium),
                                colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          HapticFeedback.mediumImpact();
                          widget.onConfirm();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: actionColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              isActivating
                                  ? context.l10n.activate
                                  : context.l10n.deactivate,
                              style: AppTextStyles.titleMediumWhite,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
