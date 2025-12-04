import 'package:flutter/material.dart';

/// Loading state widget for fields list.
class FieldsListLoadingState extends StatelessWidget {
  final String message;

  const FieldsListLoadingState({required this.message, super.key});

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
