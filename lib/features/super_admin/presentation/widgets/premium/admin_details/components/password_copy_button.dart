import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Copy button widget for password credentials.
class PasswordCopyButton extends StatefulWidget {
  final String value;

  const PasswordCopyButton({required this.value, super.key});

  @override
  State<PasswordCopyButton> createState() => _PasswordCopyButtonState();
}

class _PasswordCopyButtonState extends State<PasswordCopyButton> {
  bool _copied = false;

  Future<void> _copyToClipboard() async {
    await Clipboard.setData(ClipboardData(text: widget.value));
    HapticFeedback.lightImpact();

    setState(() => _copied = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() => _copied = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _copyToClipboard,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: _copied
              ? Colors.green.withValues(alpha: 0.1)
              : Colors.blue.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          _copied ? Icons.check : Icons.copy,
          size: 18,
          color: _copied ? Colors.green : Colors.blue,
        ),
      ),
    );
  }
}
