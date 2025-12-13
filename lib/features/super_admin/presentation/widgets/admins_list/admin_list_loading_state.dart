import 'package:flutter/material.dart';
import 'package:spo_kick/core/widgets/generic_loading_state.dart';

/// Loading state widget for admins list.
///
/// Displays a centered loading indicator with message.
class AdminListLoadingState extends StatelessWidget {
  /// Loading message to display
  final String message;

  const AdminListLoadingState({this.message = 'Loading admins...', super.key});

  @override
  Widget build(BuildContext context) {
    return GenericLoadingState(message: message);
  }
}
