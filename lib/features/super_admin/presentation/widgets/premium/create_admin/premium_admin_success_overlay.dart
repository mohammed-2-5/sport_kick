import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/widgets/premium/premium_button.dart';
import 'package:spo_kick/features/super_admin/domain/entities/admin_invitation_entity.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Premium success overlay for admin creation.
///
/// Features:
/// - Animated checkmark
/// - Credential display with copy buttons
/// - Gold theme styling
/// - Premium card layout
class PremiumAdminSuccessOverlay extends StatefulWidget {
  final AdminInvitationEntity invitation;
  final VoidCallback onDone;

  const PremiumAdminSuccessOverlay({
    super.key,
    required this.invitation,
    required this.onDone,
  });

  @override
  State<PremiumAdminSuccessOverlay> createState() =>
      _PremiumAdminSuccessOverlayState();
}

class _PremiumAdminSuccessOverlayState extends State<PremiumAdminSuccessOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _controller.forward();
    HapticFeedback.heavyImpact();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black54,
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
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppColors.premiumGold.withValues(alpha: 0.3),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Success icon
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        AppColors.premiumGold,
                        AppColors.premiumGoldDark,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.premiumGold.withValues(alpha: 0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 40),
                ),

                const SizedBox(height: 24),

                Text(
                  context.l10n.adminCreatedSuccessfully,
                  style: AppTextStyles.titleLarge.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8),

                Text(
                  context.l10n.shareTheseCredentialsSecurely,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary.withValues(alpha: 0.8),
                  ),
                ),

                const SizedBox(height: 24),

                // Credentials section
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundLight,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.premiumGold.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Column(
                    children: [
                      _CredentialRow(
                        label: context.l10n.email,
                        value: widget.invitation.email,
                        icon: Icons.email_outlined,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Divider(height: 1),
                      ),
                      _CredentialRow(
                        label: context.l10n.password,
                        value: widget.invitation.defaultPassword,
                        icon: Icons.lock_outline,
                        isPassword: true,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Security reminder
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.orange.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        size: 20,
                        color: Colors.orange.shade700,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          context.l10n.adminMustChangePasswordOnFirst,
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.orange.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                PremiumButton(
                  label: context.l10n.done,
                  onPressed: widget.onDone,
                  icon: Icons.check,
                  fullWidth: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Credential row widget with copy functionality.
class _CredentialRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final bool isPassword;

  const _CredentialRow({
    required this.label,
    required this.value,
    required this.icon,
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.premiumGold.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 20, color: AppColors.premiumGold),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                isPassword ? value : value,
                style: AppTextStyles.labelLarge.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                  fontFamily: isPassword ? 'monospace' : null,
                ),
              ),
            ],
          ),
        ),
        _CopyButton(value: value),
      ],
    );
  }
}

/// Copy button widget.
class _CopyButton extends StatefulWidget {
  final String value;

  const _CopyButton({required this.value});

  @override
  State<_CopyButton> createState() => _CopyButtonState();
}

class _CopyButtonState extends State<_CopyButton> {
  bool _copied = false;

  Future<void> _copyToClipboard() async {
    await Clipboard.setData(ClipboardData(text: widget.value));
    HapticFeedback.lightImpact();

    setState(() => _copied = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() => _copied = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _copyToClipboard,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: _copied
              ? Colors.green.withValues(alpha: 0.1)
              : AppColors.premiumGold.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          _copied ? Icons.check : Icons.copy,
          size: 18,
          color: _copied ? Colors.green : AppColors.premiumGold,
        ),
      ),
    );
  }
}
