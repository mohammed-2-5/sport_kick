import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Copy to clipboard button widget.
class BookingCopyButton extends StatelessWidget {
  final String textToCopy;
  final String successMessage;
  final VoidCallback? onCopied;

  const BookingCopyButton({
    super.key,
    required this.textToCopy,
    this.successMessage = '',
    this.onCopied,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return IconButton(
      onPressed: () {
        final message = successMessage.isNotEmpty
            ? successMessage
            : l10n.copiedToClipboard;
        _performCopy(context, textToCopy, message, isDark);
        onCopied?.call();
      },
      icon: const Icon(Icons.copy, size: 18),
      color: colorScheme.onSurfaceVariant,
      tooltip: l10n.copy,
      style: IconButton.styleFrom(
        backgroundColor: isDark
            ? colorScheme.surfaceContainerHigh
            : colorScheme.surfaceContainerHighest,
        padding: const EdgeInsets.all(8),
      ),
    );
  }

  static void _performCopy(
    BuildContext context,
    String text,
    String message,
    bool isDark,
  ) {
    Clipboard.setData(ClipboardData(text: text));
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: isDark ? AppColors.darkSuccess : AppColors.success,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
