import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spo_kick/core/constants/app_colors.dart';

/// Copy to clipboard button widget.
class BookingCopyButton extends StatelessWidget {
  final String textToCopy;
  final String successMessage;

  const BookingCopyButton({
    super.key,
    required this.textToCopy,
    this.successMessage = 'Copied to clipboard',
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => _copyToClipboard(context),
      icon: const Icon(Icons.copy, size: 18),
      color: AppColors.textSecondary,
      tooltip: 'Copy',
      style: IconButton.styleFrom(
        backgroundColor: AppColors.backgroundLight,
        padding: const EdgeInsets.all(8),
      ),
    );
  }

  void _copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: textToCopy));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(successMessage),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.success,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
