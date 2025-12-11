import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spo_kick/core/constants/app_animations.dart';
import 'package:spo_kick/core/constants/app_colors.dart';

/// Premium Text Field with animated label and interactions.
///
/// Features:
/// - Animated focus border with color transition
/// - Smooth shadow elevation on focus
/// - Form validation support
/// - Customizable prefix/suffix icons
/// - Password visibility toggle
class PremiumTextField extends StatefulWidget {
  final String label;
  final TextEditingController? controller;
  final String? errorText; // Manual error text
  final bool isPassword;
  final TextInputType keyboardType;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final VoidCallback? onTap;
  final bool readOnly;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLines;
  final bool obscureText;
  final VoidCallback? onTogglePassword;
  final FormFieldValidator<String>? validator;

  const PremiumTextField({
    super.key,
    required this.label,
    this.controller,
    this.errorText,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.suffixIcon,
    this.onTap,
    this.readOnly = false,
    this.hintText,
    this.onChanged,
    this.textInputAction,
    this.inputFormatters,
    this.maxLines = 1,
    this.obscureText = false,
    this.onTogglePassword,
    this.validator,
  });

  @override
  State<PremiumTextField> createState() => _PremiumTextFieldState();
}

class _PremiumTextFieldState extends State<PremiumTextField> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      validator: widget.validator,
      initialValue: widget.controller?.text,
      builder: (FormFieldState<String> field) {
        final hasError = field.hasError || widget.errorText != null;
        final errorText = widget.errorText ?? field.errorText;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Label
            Text(
              widget.label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color:
                    _isFocused || (widget.controller?.text.isNotEmpty ?? false)
                    ? AppColors.primary
                    : AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),

            // Input Container
            GestureDetector(
              onTap: () {
                if (!widget.readOnly) {
                  FocusScope.of(context).requestFocus(_focusNode);
                }
                widget.onTap?.call();
              },
              child: AnimatedContainer(
                duration: AppAnimations.fast,
                curve: AppAnimations.easeInOut,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: hasError
                        ? AppColors.error
                        : _isFocused
                        ? AppColors.primary
                        : AppColors.surface,
                    width: _isFocused || hasError ? 1.5 : 1.0,
                  ),
                  boxShadow: _isFocused
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                ),
                child: Row(
                  children: [
                    if (widget.prefixIcon != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Icon(
                          widget.prefixIcon,
                          color: _isFocused
                              ? AppColors.primary
                              : AppColors.icon,
                          size: 20,
                        ),
                      ),
                    Expanded(
                      child: TextField(
                        controller: widget.controller,
                        focusNode: _focusNode,
                        obscureText: widget.isPassword && widget.obscureText,
                        keyboardType: widget.keyboardType,
                        readOnly: widget.readOnly,
                        onChanged: (value) {
                          field.didChange(value);
                          widget.onChanged?.call(value);
                        },
                        textInputAction: widget.textInputAction,
                        inputFormatters: widget.inputFormatters,
                        maxLines: widget.isPassword ? 1 : widget.maxLines,
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.textPrimary,
                        ),
                        decoration: InputDecoration(
                          hintText: widget.hintText,
                          hintStyle: TextStyle(
                            color: AppColors.textSecondary.withValues(
                              alpha: 0.5,
                            ),
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical:
                                widget.maxLines != null && widget.maxLines! > 1
                                ? 16
                                : 16,
                          ),
                          isDense: true,
                        ),
                      ),
                    ),
                    if (widget.isPassword)
                      IconButton(
                        icon: Icon(
                          widget.obscureText
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: AppColors.textSecondary,
                          size: 20,
                        ),
                        onPressed: widget.onTogglePassword,
                      )
                    else if (widget.suffixIcon != null)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: widget.suffixIcon,
                      ),
                  ],
                ),
              ),
            ),

            // Error Text
            if (errorText != null)
              Padding(
                padding: const EdgeInsets.only(top: 6, left: 4),
                child: Row(
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 14,
                      color: AppColors.error,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        errorText,
                        style: const TextStyle(
                          color: AppColors.error,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}
