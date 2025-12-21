import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/auth/presentation/widgets/premium/password_strength_indicator.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';

/// Premium auth text field with glass styling.
///
/// Features:
/// - Glass background for dark theme
/// - White/light background for light theme
/// - Password visibility toggle
/// - Password strength indicator
/// - Animated focus state
/// - Validation error display
class PremiumAuthTextField extends StatefulWidget {
  final String label;
  final String? hintText;
  final TextEditingController? controller;
  final bool isPassword;
  final bool obscureText;
  final VoidCallback? onTogglePassword;
  final IconData? prefixIcon;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final String? errorText;
  final bool showPasswordStrength;
  final bool isDark;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;
  final bool enabled;

  const PremiumAuthTextField({
    super.key,
    required this.label,
    this.hintText,
    this.controller,
    this.isPassword = false,
    this.obscureText = false,
    this.onTogglePassword,
    this.prefixIcon,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.errorText,
    this.showPasswordStrength = false,
    this.isDark = true,
    this.onChanged,
    this.validator,
    this.enabled = true,
  });

  @override
  State<PremiumAuthTextField> createState() => _PremiumAuthTextFieldState();
}

class _PremiumAuthTextFieldState extends State<PremiumAuthTextField>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _focusAnimation;
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;
  String _currentText = '';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _focusAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _focusNode.addListener(_onFocusChange);
    _currentText = widget.controller?.text ?? '';
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
    if (_focusNode.hasFocus) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasError = widget.errorText != null && widget.errorText!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          widget.label,
          style: AppTextStyles.labelMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: widget.isDark
                ? Colors.white.withValues(alpha: 0.9)
                : AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),

        // Input field
        AnimatedBuilder(
          animation: _focusAnimation,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: hasError
                      ? Colors.red
                      : _isFocused
                      ? AppColors.accentCyan
                      : (widget.isDark
                            ? Colors.white.withValues(alpha: 0.2)
                            : AppColors.border),
                  width: _isFocused ? 2 : 1.5,
                ),
                boxShadow: _isFocused
                    ? [
                        BoxShadow(
                          color: AppColors.accentCyan.withValues(alpha: 0.2),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  color: widget.isDark
                      ? Colors.white.withValues(alpha: 0.08)
                      : Colors.white,
                  child: TextFormField(
                    controller: widget.controller,
                    focusNode: _focusNode,
                    obscureText: widget.obscureText,
                    keyboardType: widget.keyboardType,
                    textInputAction: widget.textInputAction,
                    enabled: widget.enabled,
                    validator: widget.validator,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: widget.isDark
                          ? Colors.white
                          : AppColors.textPrimary,
                    ),
                    onChanged: (value) {
                      setState(() {
                        _currentText = value;
                      });
                      widget.onChanged?.call(value);
                    },
                    decoration: InputDecoration(
                      hintText: widget.hintText,
                      hintStyle: AppTextStyles.bodyMedium.copyWith(
                        color: widget.isDark
                            ? Colors.white.withValues(alpha: 0.4)
                            : AppColors.textSecondary.withValues(alpha: 0.6),
                      ),
                      prefixIcon: widget.prefixIcon != null
                          ? Icon(
                              widget.prefixIcon,
                              color: _isFocused
                                  ? AppColors.accentCyan
                                  : (widget.isDark
                                        ? Colors.white.withValues(alpha: 0.5)
                                        : AppColors.textSecondary),
                              size: 20,
                            )
                          : null,
                      suffixIcon: widget.isPassword
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (widget.showPasswordStrength &&
                                    _currentText.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: CompactPasswordStrength(
                                      password: _currentText,
                                    ),
                                  ),
                                IconButton(
                                  icon: Icon(
                                    widget.obscureText
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    color: widget.isDark
                                        ? Colors.white.withValues(alpha: 0.5)
                                        : AppColors.textSecondary,
                                    size: 20,
                                  ),
                                  onPressed: widget.onTogglePassword,
                                ),
                              ],
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),

        // Error text
        if (hasError) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.error_outline, size: 14, color: Colors.red),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  widget.errorText!,
                  style: AppTextStyles.bodySmall.copyWith(color: Colors.red),
                ),
              ),
            ],
          ),
        ],

        // Password strength indicator
        if (widget.showPasswordStrength &&
            widget.isPassword &&
            _currentText.isNotEmpty) ...[
          const SizedBox(height: 12),
          PasswordStrengthIndicator(
            password: _currentText,
            showRequirements: false,
          ),
        ],
      ],
    );
  }
}
