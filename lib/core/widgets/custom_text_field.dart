import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/widgets/utils/text_field_decorator.dart';
import 'package:spo_kick/core/widgets/utils/text_field_suffix_icon.dart';
import 'package:spo_kick/core/widgets/utils/text_field_utils.dart';

// Re-export for convenience
export 'package:spo_kick/core/widgets/utils/text_field_suffix_icon.dart'
    show TextFieldType;

/// Custom text field widget with validation support.
///
/// Provides consistent input field styling with support for:
/// - Different input types (email, password, phone, text)
/// - Validation
/// - Prefix and suffix icons
/// - Character counters
/// - Helper and error text
///
/// Usage:
/// ```dart
/// CustomTextField(
///   label: 'Email',
///   hint: 'Enter your email',
///   type: TextFieldType.email,
///   controller: _emailController,
///   validator: (value) => Validators.validateEmail(value),
/// )
/// ```
class CustomTextField extends StatefulWidget {
  final String label; // Label text displayed above the field
  final String hint; // Placeholder text when empty
  final TextFieldType type; // Determines keyboard and validation
  final TextEditingController? controller;
  final String? initialValue;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixIconTap;
  final bool enabled;
  final bool showCounter;
  final int? maxLength;
  final int? maxLines;
  final int minLines;
  final bool readOnly;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? helperText;
  final bool autocorrect;
  final TextCapitalization textCapitalization;
  final TextInputAction? textInputAction;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hint,
    this.type = TextFieldType.text,
    this.controller,
    this.initialValue,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconTap,
    this.enabled = true,
    this.showCounter = false,
    this.maxLength,
    this.maxLines = 1,
    this.minLines = 1,
    this.readOnly = false,
    this.keyboardType,
    this.inputFormatters,
    this.helperText,
    this.autocorrect = true,
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  String? _errorText;
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.type == TextFieldType.password;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_buildLabel(), _buildTextField()],
    );
  }

  /// Build label and spacing
  Widget _buildLabel() => widget.label.isEmpty
      ? const SizedBox.shrink()
      : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.label,
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
          ],
        );

  /// Build the main text form field
  Widget _buildTextField() {
    return TextFormField(
      controller: widget.controller,
      initialValue: widget.initialValue,
      obscureText: widget.type == TextFieldType.password && _obscureText,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      maxLength: widget.maxLength,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      autocorrect: widget.autocorrect,
      textCapitalization: widget.textCapitalization,
      textInputAction: widget.textInputAction,
      keyboardType: TextFieldUtils.getKeyboardType(
        widget.type,
        customKeyboardType: widget.keyboardType,
      ),
      inputFormatters: TextFieldUtils.getInputFormatters(
        widget.type,
        customFormatters: widget.inputFormatters,
      ),
      style: AppTextStyles.bodyMedium,
      decoration: TextFieldDecorator.build(
        hint: widget.hint,
        prefixIcon: _buildPrefixIcon(),
        suffixIcon: _buildSuffixIcon(),
        helperText: widget.helperText,
        errorText: _errorText,
        enabled: widget.enabled,
        showCounter: widget.showCounter,
      ),
      validator: (value) {
        final error = widget.validator?.call(value);
        setState(() => _errorText = error);
        return error;
      },
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onSubmitted,
    );
  }

  /// Build the prefix icon widget
  Widget? _buildPrefixIcon() {
    if (widget.prefixIcon == null) return null;
    return Icon(widget.prefixIcon, color: AppColors.textSecondary, size: 20);
  }

  /// Build the suffix icon widget (password toggle or custom icon)
  Widget _buildSuffixIcon() {
    // Password visibility toggle
    if (widget.type == TextFieldType.password) {
      return IconButton(
        icon: Icon(
          _obscureText
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined,
          color: AppColors.textSecondary,
          size: 20,
        ),
        onPressed: () => setState(() => _obscureText = !_obscureText),
      );
    }
    // Custom suffix icon
    if (widget.suffixIcon != null) {
      return IconButton(
        icon: Icon(widget.suffixIcon, color: AppColors.textSecondary, size: 20),
        onPressed: widget.onSuffixIconTap,
      );
    }
    return const SizedBox.shrink();
  }
}
