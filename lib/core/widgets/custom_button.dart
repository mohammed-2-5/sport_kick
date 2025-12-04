import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';

/// Custom button widget with different variants.
///
/// Provides consistent button styling across the app with support for:
/// - Primary, secondary, and text button variants
/// - Loading states
/// - Disabled states
/// - Custom icons
///
/// Usage:
/// ```dart
/// CustomButton(
///   text: 'Login',
///   onPressed: () => _handleLogin(),
///   isLoading: state is LoginLoading,
/// )
/// ```
class CustomButton extends StatelessWidget {
  /// The text to display on the button
  final String text;

  /// Callback when button is pressed
  final VoidCallback? onPressed;

  /// Whether the button is in loading state
  final bool isLoading;

  /// Button variant type
  final ButtonVariant variant;

  /// Optional icon to display before text
  final IconData? icon;

  /// Button width (defaults to double.infinity)
  final double? width;

  /// Button height
  final double height;

  /// Custom background color (overrides variant color)
  final Color? backgroundColor;

  /// Custom text color
  final Color? textColor;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.variant = ButtonVariant.primary,
    this.icon,
    this.width,
    this.height = 52.0,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    // Disable button if loading or onPressed is null
    final bool isDisabled = onPressed == null || isLoading;

    switch (variant) {
      case ButtonVariant.primary:
        return _buildPrimaryButton(context, isDisabled);
      case ButtonVariant.secondary:
        return _buildSecondaryButton(context, isDisabled);
      case ButtonVariant.text:
        return _buildTextButton(context, isDisabled);
      case ButtonVariant.outline:
        return _buildOutlineButton(context, isDisabled);
    }
  }

  Widget _buildPrimaryButton(BuildContext context, bool isDisabled) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: isDisabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.primary,
          foregroundColor: textColor ?? Colors.white,
          disabledBackgroundColor: AppColors.disabled,
          disabledForegroundColor: AppColors.textDisabled,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        ),
        child: _buildButtonContent(context),
      ),
    );
  }

  Widget _buildSecondaryButton(BuildContext context, bool isDisabled) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: isDisabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.secondary,
          foregroundColor: textColor ?? Colors.white,
          disabledBackgroundColor: AppColors.disabled,
          disabledForegroundColor: AppColors.textDisabled,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        ),
        child: _buildButtonContent(context),
      ),
    );
  }

  Widget _buildOutlineButton(BuildContext context, bool isDisabled) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: OutlinedButton(
        onPressed: isDisabled ? null : onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: textColor ?? AppColors.primary,
          side: BorderSide(
            color: isDisabled
                ? AppColors.disabled
                : (backgroundColor ?? AppColors.primary),
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        ),
        child: _buildButtonContent(context),
      ),
    );
  }

  Widget _buildTextButton(BuildContext context, bool isDisabled) {
    return SizedBox(
      width: width,
      height: height,
      child: TextButton(
        onPressed: isDisabled ? null : onPressed,
        style: TextButton.styleFrom(
          foregroundColor: textColor ?? AppColors.primary,
          disabledForegroundColor: AppColors.textDisabled,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        child: _buildButtonContent(context),
      ),
    );
  }

  Widget _buildButtonContent(BuildContext context) {
    if (isLoading) {
      return SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            variant == ButtonVariant.text || variant == ButtonVariant.outline
                ? AppColors.primary
                : Colors.white,
          ),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Text(text, style: AppTextStyles.buttonText),
        ],
      );
    }

    return Text(text, style: AppTextStyles.buttonText);
  }
}

/// Button variant types
enum ButtonVariant {
  /// Primary button with filled background
  primary,

  /// Secondary button with different color
  secondary,

  /// Text-only button
  text,

  /// Outline button with border
  outline,
}
