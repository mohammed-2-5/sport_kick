import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';

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
  /// The label text displayed above the field
  final String label;

  /// Placeholder text when field is empty
  final String hint;

  /// Text field type (determines keyboard and validation)
  final TextFieldType type;

  /// Controller for the text field
  final TextEditingController? controller;

  /// Initial value for the field
  final String? initialValue;

  /// Validation function
  final String? Function(String?)? validator;

  /// Callback when text changes
  final void Function(String)? onChanged;

  /// Callback when field is submitted
  final void Function(String)? onSubmitted;

  /// Icon to display before the input
  final IconData? prefixIcon;

  /// Icon to display after the input
  final IconData? suffixIcon;

  /// Callback when suffix icon is tapped
  final VoidCallback? onSuffixIconTap;

  /// Whether the field is enabled
  final bool enabled;

  /// Whether to show character counter
  final bool showCounter;

  /// Maximum length of input
  final int? maxLength;

  /// Maximum number of lines
  final int? maxLines;

  /// Minimum number of lines
  final int minLines;

  /// Whether field is read-only
  final bool readOnly;

  /// Custom keyboard type (overrides type-based keyboard)
  final TextInputType? keyboardType;

  /// Input formatters
  final List<TextInputFormatter>? inputFormatters;

  /// Helper text displayed below field
  final String? helperText;

  /// Whether to autocorrect input
  final bool autocorrect;

  /// Text capitalization
  final TextCapitalization textCapitalization;

  /// Text input action (keyboard action button)
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
  bool _obscureText = true;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    // For password fields, start with text obscured
    _obscureText = widget.type == TextFieldType.password;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        if (widget.label.isNotEmpty) ...[
          Text(
            widget.label,
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
        ],

        // Text Field
        TextFormField(
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
          keyboardType: _getKeyboardType(),
          inputFormatters: widget.inputFormatters ?? _getInputFormatters(),
          style: AppTextStyles.bodyMedium,
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            prefixIcon: widget.prefixIcon != null
                ? Icon(widget.prefixIcon, color: AppColors.textSecondary, size: 20)
                : null,
            suffixIcon: _buildSuffixIcon(),
            helperText: widget.helperText,
            errorText: _errorText,
            counterText: widget.showCounter ? null : '',
            filled: true,
            fillColor: widget.enabled ? AppColors.inputBackground : AppColors.disabled,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.error, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.error, width: 2),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.border),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
          validator: (value) {
            final error = widget.validator?.call(value);
            setState(() => _errorText = error);
            return error;
          },
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onSubmitted,
        ),
      ],
    );
  }

  Widget? _buildSuffixIcon() {
    // Password visibility toggle
    if (widget.type == TextFieldType.password) {
      return IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          color: AppColors.textSecondary,
          size: 20,
        ),
        onPressed: () {
          setState(() => _obscureText = !_obscureText);
        },
      );
    }

    // Custom suffix icon
    if (widget.suffixIcon != null) {
      return IconButton(
        icon: Icon(widget.suffixIcon, color: AppColors.textSecondary, size: 20),
        onPressed: widget.onSuffixIconTap,
      );
    }

    return null;
  }

  TextInputType _getKeyboardType() {
    if (widget.keyboardType != null) {
      return widget.keyboardType!;
    }

    switch (widget.type) {
      case TextFieldType.email:
        return TextInputType.emailAddress;
      case TextFieldType.phone:
        return TextInputType.phone;
      case TextFieldType.number:
        return TextInputType.number;
      case TextFieldType.multiline:
        return TextInputType.multiline;
      case TextFieldType.password:
      case TextFieldType.text:
        return TextInputType.text;
    }
  }

  List<TextInputFormatter>? _getInputFormatters() {
    switch (widget.type) {
      case TextFieldType.phone:
        return [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(11),
        ];
      case TextFieldType.number:
        return [FilteringTextInputFormatter.digitsOnly];
      default:
        return null;
    }
  }
}

/// Text field type enum
enum TextFieldType {
  /// Standard text input
  text,

  /// Email input with email keyboard
  email,

  /// Password input with obscured text
  password,

  /// Phone number input (digits only)
  phone,

  /// Numeric input
  number,

  /// Multiline text input
  multiline,
}
