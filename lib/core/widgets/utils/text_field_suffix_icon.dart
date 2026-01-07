import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';

/// Enum for text field types
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

/// Widget for managing suffix icons in text fields
///
/// Handles password visibility toggle and custom suffix icons.
/// Maintains internal state for password obscurity.
class TextFieldSuffixIcon extends StatefulWidget {
  /// Text field type (determines if password visibility toggle is shown)
  final TextFieldType type;

  /// Custom icon to display as suffix (takes precedence over password toggle)
  final IconData? icon;

  /// Callback when suffix icon is tapped
  final VoidCallback? onTap;

  const TextFieldSuffixIcon({
    super.key,
    required this.type,
    this.icon,
    this.onTap,
  });

  @override
  State<TextFieldSuffixIcon> createState() => _TextFieldSuffixIconState();
}

class _TextFieldSuffixIconState extends State<TextFieldSuffixIcon> {
  late bool obscureText;

  @override
  void initState() {
    super.initState();
    // For password fields, start with text obscured
    obscureText = widget.type == TextFieldType.password;
  }

  @override
  Widget build(BuildContext context) {
    // Password visibility toggle
    if (widget.type == TextFieldType.password) {
      return IconButton(
        icon: Icon(
          obscureText
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined,
          color: AppColors.textSecondary,
          size: 20,
        ),
        onPressed: () {
          setState(() => obscureText = !obscureText);
        },
      );
    }

    // Custom suffix icon
    if (widget.icon != null) {
      return IconButton(
        icon: Icon(widget.icon, color: AppColors.textSecondary, size: 20),
        onPressed: widget.onTap,
      );
    }

    // No suffix icon needed
    return const SizedBox.shrink();
  }
}
