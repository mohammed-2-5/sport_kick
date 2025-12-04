import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';

/// Loading indicator widget with different variants.
///
/// Provides consistent loading states across the app with support for:
/// - Full screen overlay
/// - Inline widget
/// - Small button loader
/// - Custom messages
///
/// Usage:
/// ```dart
/// // Full screen
/// LoadingIndicator.fullScreen(message: 'Loading fields...')
///
/// // Inline
/// LoadingIndicator.inline()
///
/// // Button
/// LoadingIndicator.button()
/// ```
class LoadingIndicator extends StatelessWidget {
  /// Loading indicator variant
  final LoadingVariant variant;

  /// Optional message to display
  final String? message;

  /// Size of the spinner
  final double size;

  /// Color of the spinner
  final Color? color;

  const LoadingIndicator({
    super.key,
    this.variant = LoadingVariant.inline,
    this.message,
    this.size = 40.0,
    this.color,
  });

  /// Full screen loading overlay
  const LoadingIndicator.fullScreen({super.key, this.message})
    : variant = LoadingVariant.fullScreen,
      size = 48.0,
      color = null;

  /// Inline loading indicator
  const LoadingIndicator.inline({
    super.key,
    this.message,
    this.size = 40.0,
    this.color,
  }) : variant = LoadingVariant.inline;

  /// Small button loading indicator
  const LoadingIndicator.button({super.key, this.size = 20.0, this.color})
    : variant = LoadingVariant.button,
      message = null;

  @override
  Widget build(BuildContext context) {
    switch (variant) {
      case LoadingVariant.fullScreen:
        return _buildFullScreenLoader(context);
      case LoadingVariant.inline:
        return _buildInlineLoader(context);
      case LoadingVariant.button:
        return _buildButtonLoader(context);
    }
  }

  Widget _buildFullScreenLoader(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: 0.5),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: size,
                height: size,
                child: CircularProgressIndicator(
                  strokeWidth: 4,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    color ?? AppColors.primary,
                  ),
                ),
              ),
              if (message != null) ...[
                const SizedBox(height: 24),
                Text(
                  message!,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInlineLoader(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(
                color ?? AppColors.primary,
              ),
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildButtonLoader(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(color ?? Colors.white),
      ),
    );
  }
}

/// Loading indicator variant types
enum LoadingVariant {
  /// Full screen overlay with backdrop
  fullScreen,

  /// Inline loading in the middle of content
  inline,

  /// Small loading for buttons
  button,
}

/// Extension to show full screen loading overlay
extension LoadingOverlay on BuildContext {
  /// Show full screen loading
  void showLoading({String? message}) {
    showDialog(
      context: this,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (context) => PopScope(
        canPop: false,
        child: LoadingIndicator.fullScreen(message: message),
      ),
    );
  }

  /// Hide loading overlay
  void hideLoading() {
    Navigator.of(this, rootNavigator: true).pop();
  }
}
