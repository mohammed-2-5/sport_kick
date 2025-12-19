import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Copy to clipboard button widget.
class BookingCopyButton extends StatelessWidget {
  final String textToCopy;
  final String successMessage;

  const BookingCopyButton({
    super.key,
    required this.textToCopy,
    this.successMessage = '',
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return IconButton(
      onPressed: () => _copyToClipboard(context),
      icon: const Icon(Icons.copy, size: 18),
      color: AppColors.textSecondary,
      tooltip: l10n.copy,
      style: IconButton.styleFrom(
        backgroundColor: AppColors.backgroundLight,
        padding: const EdgeInsets.all(8),
      ),
    );
  }

  void _copyToClipboard(BuildContext context) {
    final l10n = context.l10n;
    Clipboard.setData(ClipboardData(text: textToCopy));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          successMessage.isNotEmpty ? successMessage : l10n.copiedToClipboard,
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.success,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
