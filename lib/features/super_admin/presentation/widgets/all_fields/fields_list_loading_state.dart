import 'package:flutter/material.dart';
import 'package:spo_kick/core/widgets/generic_loading_state.dart';

/// Loading state widget for fields list.
class FieldsListLoadingState extends StatelessWidget {
  final String message;

  const FieldsListLoadingState({required this.message, super.key});

  @override
  Widget build(BuildContext context) {
    return GenericLoadingState(message: message);
  }
}
