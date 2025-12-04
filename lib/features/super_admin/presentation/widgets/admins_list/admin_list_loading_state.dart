import 'package:flutter/material.dart';

/// Loading state widget for admins list.
///
/// Displays a centered loading indicator with message.
class AdminListLoadingState extends StatelessWidget {
  /// Loading message to display
  final String message;

  const AdminListLoadingState({this.message = 'Loading admins...', super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(message, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}
