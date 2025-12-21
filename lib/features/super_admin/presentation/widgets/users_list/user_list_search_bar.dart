import 'package:flutter/material.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

class UserListSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String searchQuery;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const UserListSearchBar({
    required this.controller,
    required this.searchQuery,
    required this.onChanged,
    required this.onClear,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: context.l10n.searchUsersByNameEmailOrPhone,
          prefixIcon: const Icon(Icons.search),
          suffixIcon: searchQuery.isNotEmpty
              ? IconButton(icon: const Icon(Icons.clear), onPressed: onClear)
              : null,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
        onChanged: onChanged,
      ),
    );
  }
}
