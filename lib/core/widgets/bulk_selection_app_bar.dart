import 'package:flutter/material.dart';

/// Reusable Bulk Selection App Bar
///
/// Provides bulk selection functionality with:
/// - Selection counter
/// - Select all / Deselect all actions
/// - Custom bulk action buttons
/// - Animated appearance
class BulkSelectionAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final int selectedCount;
  final int totalCount;
  final VoidCallback onCancel;
  final VoidCallback onSelectAll;
  final VoidCallback onDeselectAll;
  final List<BulkAction> actions;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const BulkSelectionAppBar({
    super.key,
    required this.selectedCount,
    required this.totalCount,
    required this.onCancel,
    required this.onSelectAll,
    required this.onDeselectAll,
    required this.actions,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = backgroundColor ?? theme.colorScheme.primaryContainer;
    final fgColor = foregroundColor ?? theme.colorScheme.onPrimaryContainer;

    return AppBar(
      elevation: 4,
      backgroundColor: bgColor,
      foregroundColor: fgColor,
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: onCancel,
        tooltip: 'Cancel selection',
      ),
      title: Text(
        '$selectedCount selected',
        style: TextStyle(color: fgColor, fontWeight: FontWeight.bold),
      ),
      actions: [
        // Select/Deselect All
        if (selectedCount < totalCount)
          IconButton(
            icon: const Icon(Icons.select_all),
            onPressed: onSelectAll,
            tooltip: 'Select all',
          )
        else
          IconButton(
            icon: const Icon(Icons.deselect),
            onPressed: onDeselectAll,
            tooltip: 'Deselect all',
          ),

        // Custom actions
        ...actions.map(
          (action) => IconButton(
            icon: Icon(action.icon),
            onPressed: selectedCount > 0 ? action.onPressed : null,
            tooltip: action.label,
            color: action.color ?? fgColor,
          ),
        ),
      ],
    );
  }
}

/// Bulk action definition
class BulkAction {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final Color? color;

  const BulkAction({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.color,
  });
}

/// Mixin for bulk selection functionality
///
/// Add this to your StatefulWidget's State to get bulk selection features
mixin BulkSelectionMixin<T> on State {
  /// Set of selected item IDs
  final Set<String> selectedIds = {};

  /// Whether bulk selection mode is active
  bool get isSelectionMode => selectedIds.isNotEmpty;

  /// Number of selected items
  int get selectedCount => selectedIds.length;

  /// Toggle selection for an item
  void toggleSelection(String id) {
    setState(() {
      if (selectedIds.contains(id)) {
        selectedIds.remove(id);
      } else {
        selectedIds.add(id);
      }
    });
  }

  /// Select all items
  void selectAll(List<T> items, String Function(T) getId) {
    setState(() {
      selectedIds.clear();
      selectedIds.addAll(items.map(getId));
    });
  }

  /// Deselect all items
  void deselectAll() {
    setState(() {
      selectedIds.clear();
    });
  }

  /// Check if an item is selected
  bool isSelected(String id) {
    return selectedIds.contains(id);
  }

  /// Get list of selected items
  List<T> getSelectedItems(List<T> allItems, String Function(T) getId) {
    return allItems.where((item) => selectedIds.contains(getId(item))).toList();
  }

  /// Cancel selection mode
  void cancelSelection() {
    deselectAll();
  }
}
