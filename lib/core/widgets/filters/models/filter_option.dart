/// Model class representing a filter option with value and display label.
///
/// Used in [DropdownFilterWidget] and [ChipFilterWidget] to represent
/// selectable filter options. The value is used for filtering logic while
/// the label is displayed to the user.
///
/// Example:
/// ```dart
/// FilterOption(
///   value: 'active',
///   label: 'Active',
/// )
/// ```
class FilterOption {
  /// Internal value used for filtering operations.
  final String value;

  /// Display label shown to the user in the UI.
  final String label;

  /// Creates a filter option.
  ///
  /// Both [value] and [label] are required.
  FilterOption({required this.value, required this.label});
}
