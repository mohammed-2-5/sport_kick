import 'package:flutter/material.dart';

/// Refresh button with loading state for the booking table header.
///
/// Features:
/// - Shows refresh icon when idle
/// - Shows circular progress indicator when loading
/// - Disabled during loading
class BookingTableRefreshButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool isLoading;

  const BookingTableRefreshButton({
    super.key,
    required this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        icon: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Icon(Icons.refresh_rounded, color: Colors.white, size: 22),
        onPressed: isLoading ? null : onTap,
      ),
    );
  }
}
