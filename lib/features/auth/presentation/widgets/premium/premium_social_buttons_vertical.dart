import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/features/auth/presentation/widgets/premium/premium_social_buttons.dart';

/// Alternative social buttons layout (vertical).
class PremiumSocialButtonsVertical extends StatelessWidget {
  final VoidCallback? onGooglePressed;
  final VoidCallback? onFacebookPressed;
  final VoidCallback? onApplePressed;
  final bool isLoading;

  const PremiumSocialButtonsVertical({
    super.key,
    this.onGooglePressed,
    this.onFacebookPressed,
    this.onApplePressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _FullWidthSocialButton(
          icon: const GoogleIcon(),
          label: context.l10n.continueWithGoogle,
          onPressed: onGooglePressed,
          isLoading: isLoading,
        ),
        const SizedBox(height: 12),
        _FullWidthSocialButton(
          icon: const Icon(Icons.facebook, color: Color(0xFF1877F2), size: 24),
          label: context.l10n.continueWithFacebook,
          onPressed: onFacebookPressed,
          isLoading: isLoading,
        ),
        if (onApplePressed != null) ...[
          const SizedBox(height: 12),
          _FullWidthSocialButton(
            icon: const Icon(Icons.apple, color: Colors.black, size: 24),
            label: context.l10n.continueWithApple,
            onPressed: onApplePressed,
            isLoading: isLoading,
            backgroundColor: Colors.black,
            textColor: Colors.white,
          ),
        ],
      ],
    );
  }
}

class _FullWidthSocialButton extends StatefulWidget {
  final Widget icon;
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? textColor;

  const _FullWidthSocialButton({
    required this.icon,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
  });

  @override
  State<_FullWidthSocialButton> createState() => _FullWidthSocialButtonState();
}

class _FullWidthSocialButtonState extends State<_FullWidthSocialButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
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
        if (widget.onPressed != null && !widget.isLoading) {
          HapticFeedback.lightImpact();
          widget.onPressed!();
        }
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Builder(
          builder: (context) {
            final colorScheme = Theme.of(context).colorScheme;
            return Container(
              height: 52,
              decoration: BoxDecoration(
                color: widget.backgroundColor ?? colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: colorScheme.outline.withValues(alpha: 0.2),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  widget.icon,
                  const SizedBox(width: 12),
                  Text(
                    widget.label,
                    style: AppTextStyles.labelMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: widget.textColor ?? colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
