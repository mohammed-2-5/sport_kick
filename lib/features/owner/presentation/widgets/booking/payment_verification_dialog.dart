import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';

/// Dialog for verifying or rejecting payment proofs.
///
/// Shows confirmation for verify action and requires reason for rejection.
class PaymentVerificationDialog extends StatelessWidget {
  final bool isVerify;
  final VoidCallback onConfirm;
  final ValueChanged<String>? onRejectWithReason;

  const PaymentVerificationDialog._({
    required this.isVerify,
    required this.onConfirm,
    this.onRejectWithReason,
  });

  /// Show verification confirmation dialog.
  static Future<bool?> showVerifyDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => _VerifyConfirmationDialog(),
    );
  }

  /// Show rejection dialog with reason input.
  static Future<String?> showRejectDialog(BuildContext context) {
    return showDialog<String>(
      context: context,
      builder: (context) => _RejectReasonDialog(),
    );
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

class _VerifyConfirmationDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle_outline,
              color: AppColors.success,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'Verify Payment',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
        ],
      ),
      content: const Text(
        'Are you sure you want to verify this payment? '
        'This will confirm that the customer has paid for the booking.',
        style: TextStyle(
          fontSize: 14,
          color: AppColors.textSecondary,
          height: 1.5,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text(
            'Cancel',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.success,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text('Verify Payment'),
        ),
      ],
    );
  }
}

class _RejectReasonDialog extends StatefulWidget {
  @override
  State<_RejectReasonDialog> createState() => _RejectReasonDialogState();
}

class _RejectReasonDialogState extends State<_RejectReasonDialog> {
  final _reasonController = TextEditingController();
  bool _isValid = false;

  @override
  void initState() {
    super.initState();
    _reasonController.addListener(_validateInput);
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  void _validateInput() {
    setState(() {
      _isValid = _reasonController.text.trim().length >= 10;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.cancel_outlined,
              color: AppColors.error,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'Reject Payment',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Please provide a reason for rejecting this payment. '
            'The customer will be notified.',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _reasonController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Enter rejection reason (min 10 characters)',
              hintStyle: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.error, width: 2),
              ),
              contentPadding: const EdgeInsets.all(14),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${_reasonController.text.trim().length}/10 characters minimum',
            style: TextStyle(
              fontSize: 12,
              color: _isValid ? AppColors.success : AppColors.textSecondary,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Cancel',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
        ElevatedButton(
          onPressed: _isValid
              ? () => Navigator.pop(context, _reasonController.text.trim())
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.error,
            foregroundColor: Colors.white,
            disabledBackgroundColor: AppColors.error.withValues(alpha: 0.3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text('Reject Payment'),
        ),
      ],
    );
  }
}
